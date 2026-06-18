package dal;

import model.Category;
import java.sql.*;
import java.util.*;

public class CategoryDAO extends DBContext {

    public List<Category> getAll() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE IsActive=1 ORDER BY SortOrder";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Category getByID(int id) throws SQLException {
        String sql = "SELECT * FROM Category WHERE CategoryID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public boolean insert(Category c) throws SQLException {
        String sql = "INSERT INTO Category(CategoryName,Description,ImageURL,SortOrder) VALUES(?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getImageURL());
            ps.setInt(4, c.getSortOrder());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Category c) throws SQLException {
        String sql = "UPDATE Category SET CategoryName=?,Description=?,ImageURL=?,SortOrder=?,IsActive=? WHERE CategoryID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getImageURL());
            ps.setInt(4, c.getSortOrder());
            ps.setBoolean(5, c.isActive());
            ps.setInt(6, c.getCategoryID());
            return ps.executeUpdate() > 0;
        }
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryID(rs.getInt("CategoryID"));
        c.setCategoryName(rs.getString("CategoryName"));
        c.setDescription(rs.getString("Description"));
        c.setImageURL(rs.getString("ImageURL"));
        c.setActive(rs.getBoolean("IsActive"));
        c.setSortOrder(rs.getInt("SortOrder"));
        return c;
    }
}