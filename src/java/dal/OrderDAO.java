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
                "INSERT INTO [Order](AccountID,TotalAmount,DiscountAmount,ShipAddress,Phone,Note,PaymentMethod,IsPaid) " +
                "VALUES(?,?,?,?,?,?,?,?)";
            int orderID;
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getAccountID());
                ps.setBigDecimal(2, cart.getTotal());
                ps.setBigDecimal(3, cart.getDiscount());
                ps.setString(4, order.getShipAddress());
                ps.setString(5, order.getPhone());
                ps.setString(6, order.getNote());
                ps.setString(7, order.getPaymentMethod());
                ps.setBoolean(8, order.isPaid());
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

    /** Tổng doanh thu từ các đơn hoàn thành (status=3) */
    public java.math.BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT ISNULL(SUM(FinalAmount),0) FROM [Order] WHERE Status=3";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal(1);
        }
    }

    /** Admin: count đơn theo từng status (0..4) */
    public Map<Integer, Integer> getCountByStatus() throws SQLException {
        Map<Integer, Integer> map = new HashMap<>();
        for (int s = 0; s <= 4; s++) map.put(s, 0);

        String sql = "SELECT Status, COUNT(*) AS Cnt FROM [Order] GROUP BY Status";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int status = rs.getInt("Status");
                int cnt = rs.getInt("Cnt");
                if (map.containsKey(status)) map.put(status, cnt);
            }
        }
        return map;
    }

    /**
     * Doanh thu theo ngày trong 7 ngày gần nhất (theo OrderDate), chỉ tính status=3
     * Kết quả trả về list size 7 (có thể là 0 nếu không có dữ liệu).
     */
    public List<Object[]> getRevenueLast7Days() throws SQLException {
        List<Object[]> result = new ArrayList<>();

        String sql =
            "WITH D AS (\n" +
            "  SELECT TOP 7 CAST(DATEADD(day, -ROW_NUMBER() OVER(ORDER BY (SELECT NULL)), GETDATE()) AS date) AS DayKey\n" +
            "  FROM sys.objects\n" +
            ")\n" +
            "SELECT d.DayKey AS DayDate,\n" +
            "       ISNULL(SUM(o.FinalAmount),0) AS Revenue\n" +
            "FROM D d\n" +
            "LEFT JOIN [Order] o ON CAST(o.OrderDate AS date) = d.DayKey AND o.Status=3\n" +
            "GROUP BY d.DayKey\n" +
            "ORDER BY d.DayKey";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(new Object[]{rs.getDate("DayDate"), rs.getBigDecimal("Revenue")});
            }
        }
        return result;
    }

    /** Top sản phẩm bán chạy (dựa theo tổng quantity), trong đó lấy theo đơn hoàn thành status=3 */
    public List<Object[]> getTopProducts(int limit) throws SQLException {
        List<Object[]> list = new ArrayList<>();

        String sql =
            "SELECT TOP (?) "+
            "   od.ProductID,\n" +
            "   p.ProductName,\n" +
            "   SUM(od.Quantity) AS TotalQty,\n" +
            "   SUM(od.Subtotal) AS TotalRevenue\n" +
            "FROM OrderDetail od\n" +
            "JOIN [Order] o ON od.OrderID = o.OrderID\n" +
            "JOIN Product p ON od.ProductID = p.ProductID\n" +
            "WHERE o.Status = 3\n" +
            "GROUP BY od.ProductID, p.ProductName\n" +
            "ORDER BY TotalQty DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productID = rs.getInt("ProductID");
                    String name = rs.getString("ProductName");
                    int totalQty = rs.getInt("TotalQty");
                    java.math.BigDecimal totalRevenue = rs.getBigDecimal("TotalRevenue");
                    list.add(new Object[]{productID, name, totalQty, totalRevenue});
                }
            }
        }

        return list;
    }

    // ---- helper ----

    /**
     * Thống kê doanh thu theo tháng (status=3), lấy monthsBack tháng gần nhất.
     * Trả về list: [Year, Month, Revenue]
     */
    public List<Object[]> getRevenueByMonth(int monthsBack) throws SQLException {
        List<Object[]> list = new ArrayList<>();

        String sql =
            "WITH M AS (\n" +
            "  SELECT TOP (?)\n" +
            "    DATEADD(month, -ROW_NUMBER() OVER(ORDER BY (SELECT NULL)), GETDATE()) AS MonthStart\n" +
            "  FROM sys.objects\n" +
            ")\n" +
            "SELECT\n" +
            "  YEAR(m.MonthStart) AS [Year],\n" +
            "  MONTH(m.MonthStart) AS [Month],\n" +
            "  ISNULL(SUM(o.FinalAmount),0) AS Revenue\n" +
            "FROM M m\n" +
            "LEFT JOIN [Order] o\n" +
            "  ON o.Status = 3\n" +
            "  AND o.OrderDate >= m.MonthStart\n" +
            "  AND o.OrderDate < DATEADD(month, 1, m.MonthStart)\n" +
            "GROUP BY YEAR(m.MonthStart), MONTH(m.MonthStart)\n" +
            "ORDER BY [Year], [Month]";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, monthsBack);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int year = rs.getInt("Year");
                    int month = rs.getInt("Month");
                    java.math.BigDecimal revenue = rs.getBigDecimal("Revenue");
                    list.add(new Object[]{year, month, revenue});
                }
            }
        }

        return list;
    }

    /** Xu hướng doanh thu 12 tháng gần nhất (wrapper) */
    public List<Object[]> getRevenueTrend12Months() throws SQLException {
        return getRevenueByMonth(12);
    }

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