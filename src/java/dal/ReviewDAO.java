package dal;

import java.sql.*;
import java.util.*;
import model.Review;

public class ReviewDAO extends DBContext {

    /** Lấy tất cả đánh giá của 1 sản phẩm, mới nhất trước */
    public List<Review> getByProduct(int productID) throws SQLException {
        List<Review> list = new ArrayList<>();
        String sql =
            "SELECT r.*, a.FullName AS ReviewerName " +
            "FROM Review r JOIN Account a ON r.AccountID = a.AccountID " +
            "WHERE r.ProductID = ? ORDER BY r.ReviewDate DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review rv = new Review();
                rv.setReviewID(rs.getInt("ReviewID"));
                rv.setProductID(rs.getInt("ProductID"));
                rv.setAccountID(rs.getInt("AccountID"));
                rv.setReviewerName(rs.getString("ReviewerName"));
                rv.setRating(rs.getInt("Rating"));
                rv.setComment(rs.getString("Comment"));
                rv.setCreatedAt(rs.getTimestamp("ReviewDate"));
                list.add(rv);
            }
        }
        return list;
    }

    /** Lấy review của 1 user với 1 sản phẩm (để hiện lại khi sửa) */
    public Review getByAccountAndProduct(int accountID, int productID) throws SQLException {
        String sql =
            "SELECT r.*, a.FullName AS ReviewerName " +
            "FROM Review r JOIN Account a ON r.AccountID = a.AccountID " +
            "WHERE r.AccountID = ? AND r.ProductID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review rv = new Review();
                rv.setReviewID(rs.getInt("ReviewID"));
                rv.setProductID(rs.getInt("ProductID"));
                rv.setAccountID(rs.getInt("AccountID"));
                rv.setReviewerName(rs.getString("ReviewerName"));
                rv.setRating(rs.getInt("Rating"));
                rv.setComment(rs.getString("Comment"));
                rv.setCreatedAt(rs.getTimestamp("ReviewDate"));
                return rv;
            }
        }
        return null;
    }

    /** Cập nhật đánh giá đã có */
    public boolean update(Review rv) throws SQLException {
        String sql = "UPDATE Review SET Rating=?, Comment=? WHERE AccountID=? AND ProductID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rv.getRating());
            ps.setString(2, rv.getComment());
            ps.setInt(3, rv.getAccountID());
            ps.setInt(4, rv.getProductID());
            return ps.executeUpdate() > 0;
        }
    }

    /** Kiểm tra khách đã mua và nhận hàng thành công (status=3) */
    public boolean hasPurchased(int accountID, int productID) throws SQLException {
        String sql =
            "SELECT COUNT(*) FROM OrderDetail od " +
            "JOIN [Order] o ON od.OrderID = o.OrderID " +
            "WHERE o.AccountID = ? AND od.ProductID = ? AND o.Status = 3";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    /** Kiểm tra khách đã đánh giá sản phẩm này chưa */
    public boolean hasReviewed(int accountID, int productID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Review WHERE AccountID = ? AND ProductID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    /** Thêm đánh giá mới */
    public boolean insert(Review rv) throws SQLException {
        String sql = "INSERT INTO Review(ProductID, AccountID, Rating, Comment) VALUES(?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rv.getProductID());
            ps.setInt(2, rv.getAccountID());
            ps.setInt(3, rv.getRating());
            ps.setString(4, rv.getComment());
            return ps.executeUpdate() > 0;
        }
    }
}
