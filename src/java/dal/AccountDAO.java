package dal;

import model.Account;
import java.sql.*;

public class AccountDAO extends DBContext {

    /**
     * Đăng nhập bằng email + password (đã hash SHA-256)
     * Trả về Account nếu đúng, null nếu sai
     */
    public Account login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM Account WHERE Email=? AND Password=? AND IsActive=1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password); // truyền vào password đã hash ở tầng Controller
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /**
     * Tìm account theo email (dùng cho Google Login & kiểm tra trùng email khi đăng ký)
     */
    public Account findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Account WHERE Email=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /**
     * Đăng ký tài khoản mới
     * Trả về true nếu thành công
     */
    public boolean register(Account a) throws SQLException {
        // Kiểm tra email trùng trước
        if (findByEmail(a.getEmail()) != null) return false;

        String sql = "INSERT INTO Account(FullName,Email,Phone,Password,Address) VALUES(?,?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getEmail());
            ps.setString(3, a.getPhone());
            ps.setString(4, a.getPassword()); // đã hash từ Controller
            ps.setString(5, a.getAddress());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tạo tài khoản từ Google (không cần password)
     */
    public boolean insertGoogleAccount(Account a) throws SQLException {
        String sql = "INSERT INTO Account(FullName,Email,Password,Avatar,IsAdmin) VALUES(?,?,'GOOGLE_AUTH',?,0)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getEmail());
            ps.setString(3, a.getAvatar());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin cá nhân
     */
    public boolean updateProfile(Account a) throws SQLException {
        String sql = "UPDATE Account SET FullName=?, Phone=?, Address=?, Avatar=? WHERE AccountID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getPhone());
            ps.setString(3, a.getAddress());
            ps.setString(4, a.getAvatar());
            ps.setInt(5, a.getAccountID());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- helper ----
    private Account mapRow(ResultSet rs) throws SQLException {
        Account a = new Account();
        a.setAccountID(rs.getInt("AccountID"));
        a.setFullName(rs.getString("FullName"));
        a.setEmail(rs.getString("Email"));
        a.setPhone(rs.getString("Phone"));
        a.setAddress(rs.getString("Address"));
        a.setAvatar(rs.getString("Avatar"));
        a.setAdmin(rs.getBoolean("IsAdmin"));
        a.setActive(rs.getBoolean("IsActive"));
        a.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return a;
    }
}