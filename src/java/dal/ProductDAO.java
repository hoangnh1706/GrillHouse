package dal;

import model.Product;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ProductDAO extends DBContext {

    // ===================== KHÁCH HÀNG =====================

    /** Lấy tất cả món đang bán, kèm điểm đánh giá */
    public List<Product> getAllProducts() throws SQLException {
        String sql =
            "SELECT p.*, c.CategoryName, " +
            "       ISNULL(AVG(CAST(r.Rating AS FLOAT)),0) AS AvgRating, " +
            "       COUNT(r.ReviewID) AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "LEFT JOIN Review r ON p.ProductID = r.ProductID " +
            "WHERE p.IsActive=1 AND c.IsActive=1 " +
            "GROUP BY p.ProductID,p.CategoryID,p.ProductName,p.Description," +
            "         p.Price,p.SalePrice,p.ImageURL,p.Stock,p.IsFeatured," +
            "         p.IsActive,p.CreatedAt,c.CategoryName " +
            "ORDER BY p.IsFeatured DESC, p.CreatedAt DESC";
        return query(sql);
    }

    /** Lọc theo danh mục */
    public List<Product> getByCategory(int categoryID) throws SQLException {
        String sql =
            "SELECT p.*, c.CategoryName, " +
            "       ISNULL(AVG(CAST(r.Rating AS FLOAT)),0) AS AvgRating, " +
            "       COUNT(r.ReviewID) AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "LEFT JOIN Review r ON p.ProductID = r.ProductID " +
            "WHERE p.IsActive=1 AND p.CategoryID=? " +
            "GROUP BY p.ProductID,p.CategoryID,p.ProductName,p.Description," +
            "         p.Price,p.SalePrice,p.ImageURL,p.Stock,p.IsFeatured," +
            "         p.IsActive,p.CreatedAt,c.CategoryName " +
            "ORDER BY p.IsFeatured DESC, p.CreatedAt DESC";
        return queryWithParams(sql, categoryID);
    }

    /** Tìm kiếm theo tên */
    public List<Product> search(String keyword) throws SQLException {
        String sql =
            "SELECT p.*, c.CategoryName, " +
            "       ISNULL(AVG(CAST(r.Rating AS FLOAT)),0) AS AvgRating, " +
            "       COUNT(r.ReviewID) AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "LEFT JOIN Review r ON p.ProductID = r.ProductID " +
            "WHERE p.IsActive=1 AND p.ProductName LIKE ? " +
            "GROUP BY p.ProductID,p.CategoryID,p.ProductName,p.Description," +
            "         p.Price,p.SalePrice,p.ImageURL,p.Stock,p.IsFeatured," +
            "         p.IsActive,p.CreatedAt,c.CategoryName " +
            "ORDER BY p.IsFeatured DESC";
        return queryWithParams(sql, "%" + keyword + "%");
    }

    /** Lấy chi tiết 1 món */
    public Product getByID(int productID) throws SQLException {
        String sql =
            "SELECT p.*, c.CategoryName, " +
            "       ISNULL(AVG(CAST(r.Rating AS FLOAT)),0) AS AvgRating, " +
            "       COUNT(r.ReviewID) AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "LEFT JOIN Review r ON p.ProductID = r.ProductID " +
            "WHERE p.ProductID=? " +
            "GROUP BY p.ProductID,p.CategoryID,p.ProductName,p.Description," +
            "         p.Price,p.SalePrice,p.ImageURL,p.Stock,p.IsFeatured," +
            "         p.IsActive,p.CreatedAt,c.CategoryName";
        List<Product> list = queryWithParams(sql, productID);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Món nổi bật cho trang chủ */
    public List<Product> getFeatured(int limit) throws SQLException {
        String sql =
            "SELECT TOP(?) p.*, c.CategoryName, 0 AS AvgRating, 0 AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "WHERE p.IsActive=1 AND p.IsFeatured=1 " +
            "ORDER BY p.CreatedAt DESC";
        return queryWithParams(sql, limit);
    }

    // ===================== ADMIN - CRUD =====================

    /** Thêm món mới */
    public boolean insert(Product p) throws SQLException {
        String sql =
            "INSERT INTO Product(CategoryID,ProductName,Description,Price,SalePrice,ImageURL,Stock,IsFeatured) " +
            "VALUES(?,?,?,?,?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryID());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setBigDecimal(5, p.getSalePrice()); // null nếu không KM
            ps.setString(6, p.getImageURL());
            ps.setInt(7, p.getStock());
            ps.setBoolean(8, p.isFeatured());
            return ps.executeUpdate() > 0;
        }
    }

    /** Cập nhật thông tin món */
    public boolean update(Product p) throws SQLException {
        String sql =
            "UPDATE Product SET CategoryID=?,ProductName=?,Description=?," +
            "Price=?,SalePrice=?,ImageURL=?,Stock=?,IsFeatured=?,IsActive=? " +
            "WHERE ProductID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryID());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setBigDecimal(5, p.getSalePrice());
            ps.setString(6, p.getImageURL());
            ps.setInt(7, p.getStock());
            ps.setBoolean(8, p.isFeatured());
            ps.setBoolean(9, p.isActive());
            ps.setInt(10, p.getProductID());
            return ps.executeUpdate() > 0;
        }
    }

    /** Xóa mềm (IsActive = 0) để giữ lịch sử đơn hàng */
    public boolean delete(int productID) throws SQLException {
        String sql = "UPDATE Product SET IsActive=0 WHERE ProductID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            return ps.executeUpdate() > 0;
        }
    }

    /** Admin: lấy tất cả kể cả đã ẩn */
    public List<Product> getAll_Admin() throws SQLException {
        String sql =
            "SELECT p.*, c.CategoryName, 0 AS AvgRating, 0 AS ReviewCount " +
            "FROM Product p " +
            "JOIN Category c ON p.CategoryID = c.CategoryID " +
            "ORDER BY p.CategoryID, p.ProductID";
        return query(sql);
    }

    // ===================== HELPER =====================

    private List<Product> query(String sql) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private List<Product> queryWithParams(String sql, Object... params) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductID(rs.getInt("ProductID"));
        p.setCategoryID(rs.getInt("CategoryID"));
        p.setCategoryName(rs.getString("CategoryName"));
        p.setProductName(rs.getString("ProductName"));
        p.setDescription(rs.getString("Description"));
        p.setPrice(rs.getBigDecimal("Price"));
        p.setSalePrice(rs.getBigDecimal("SalePrice")); // có thể null
        p.setImageURL(rs.getString("ImageURL"));
        p.setStock(rs.getInt("Stock"));
        p.setFeatured(rs.getBoolean("IsFeatured"));
        p.setActive(rs.getBoolean("IsActive"));
        p.setCreatedAt(rs.getTimestamp("CreatedAt"));
        p.setAvgRating(rs.getDouble("AvgRating"));
        p.setReviewCount(rs.getInt("ReviewCount"));
        return p;
    }
}