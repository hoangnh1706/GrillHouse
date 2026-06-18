package dal;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.*;

public class OrderDAO extends DBContext {

    /**
     * Tạo đơn hàng + chi tiết trong 1 Transaction
     * Trả về OrderID mới tạo, hoặc -1 nếu lỗi
     */
    public int createOrder(Order order, Cart cart) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // bắt đầu Transaction

            // 1. Insert Order
            // FinalAmount là computed column (TotalAmount - DiscountAmount), không INSERT trực tiếp
            String sqlOrder =
                "INSERT INTO [Order](AccountID,TotalAmount,DiscountAmount,ShipAddress,Phone,Note,PaymentMethod) " +
                "VALUES(?,?,?,?,?,?,?)";
            int orderID;
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getAccountID());
                ps.setBigDecimal(2, cart.getTotal());
                ps.setBigDecimal(3, cart.getDiscount());
                ps.setString(4, order.getShipAddress());
                ps.setString(5, order.getPhone());
                ps.setString(6, order.getNote());
                ps.setString(7, order.getPaymentMethod());
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                keys.next();
                orderID = keys.getInt(1);
            }

            // 2. Insert OrderDetail từng món trong Cart
            String sqlDetail =
                "INSERT INTO OrderDetail(OrderID,ProductID,Quantity,UnitPrice) VALUES(?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlDetail)) {
                for (CartItem item : cart.getItems()) {
                    ps.setInt(1, orderID);
                    ps.setInt(2, item.getProductID());
                    ps.setInt(3, item.getQuantity());
                    ps.setBigDecimal(4, item.getUnitPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 3. Trừ tồn kho
            String sqlStock =
                "UPDATE Product SET Stock = Stock - ? WHERE ProductID = ? AND Stock >= ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlStock)) {
                for (CartItem item : cart.getItems()) {
                    ps.setInt(1, item.getQuantity());
                    ps.setInt(2, item.getProductID());
                    ps.setInt(3, item.getQuantity()); // đảm bảo đủ hàng
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit(); // hoàn thành Transaction
            return orderID;

        } catch (SQLException e) {
            if (conn != null) conn.rollback(); // rollback nếu có lỗi
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    /** Lịch sử đơn hàng của 1 khách hàng */
    public List<Order> getByAccount(int accountID) throws SQLException {
        String sql =
            "SELECT o.*, a.FullName AS CustomerName " +
            "FROM [Order] o JOIN Account a ON o.AccountID=a.AccountID " +
            "WHERE o.AccountID=? ORDER BY o.OrderDate DESC";
        return queryOrders(sql, accountID);
    }

    /** Chi tiết 1 đơn hàng (kèm danh sách món) */
    public Order getByID(int orderID) throws SQLException {
        String sqlOrder =
            "SELECT o.*, a.FullName AS CustomerName " +
            "FROM [Order] o JOIN Account a ON o.AccountID=a.AccountID " +
            "WHERE o.OrderID=?";
        List<Order> list = queryOrders(sqlOrder, orderID);
        if (list.isEmpty()) return null;

        Order order = list.get(0);
        order.setDetails(getDetails(orderID));
        return order;
    }

    /** Admin: lấy tất cả đơn, lọc theo status (-1 = tất cả) */
    public List<Order> getAll(int status) throws SQLException {
        String sql =
            "SELECT o.*, a.FullName AS CustomerName " +
            "FROM [Order] o JOIN Account a ON o.AccountID=a.AccountID " +
            (status >= 0 ? "WHERE o.Status=? " : "") +
            "ORDER BY o.OrderDate DESC";
        return status >= 0 ? queryOrders(sql, status) : queryOrders(sql);
    }

    /** Admin: cập nhật trạng thái đơn hàng */
    public boolean updateStatus(int orderID, int status) throws SQLException {
        String sql = "UPDATE [Order] SET Status=? WHERE OrderID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- helper ----

    private List<OrderDetail> getDetails(int orderID) throws SQLException {
        List<OrderDetail> list = new ArrayList<>();
        String sql =
            "SELECT od.*, p.ProductName, p.ImageURL " +
            "FROM OrderDetail od JOIN Product p ON od.ProductID=p.ProductID " +
            "WHERE od.OrderID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail d = new OrderDetail();
                d.setOrderDetailID(rs.getInt("OrderDetailID"));
                d.setOrderID(rs.getInt("OrderID"));
                d.setProductID(rs.getInt("ProductID"));
                d.setProductName(rs.getString("ProductName"));
                d.setImageURL(rs.getString("ImageURL"));
                d.setQuantity(rs.getInt("Quantity"));
                d.setUnitPrice(rs.getBigDecimal("UnitPrice"));
                d.setSubtotal(rs.getBigDecimal("Subtotal"));
                list.add(d);
            }
        }
        return list;
    }

    private List<Order> queryOrders(String sql, Object... params) throws SQLException {
        List<Order> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i+1, params[i]);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderID(rs.getInt("OrderID"));
                o.setAccountID(rs.getInt("AccountID"));
                o.setCustomerName(rs.getString("CustomerName"));
                o.setOrderDate(rs.getTimestamp("OrderDate"));
                o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                BigDecimal discount = rs.getBigDecimal("DiscountAmount");
                if (discount == null) discount = BigDecimal.ZERO;
                o.setDiscountAmount(discount);
                BigDecimal finalAmt = rs.getBigDecimal("FinalAmount");
                if (finalAmt == null) {
                    finalAmt = o.getTotalAmount().subtract(discount);
                }
                o.setFinalAmount(finalAmt);
                o.setShipAddress(rs.getString("ShipAddress"));
                o.setPhone(rs.getString("Phone"));
                o.setNote(rs.getString("Note"));
                o.setStatus(rs.getInt("Status"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setPaid(rs.getBoolean("IsPaid"));
                list.add(o);
            }
        }
        return list;
    }
}