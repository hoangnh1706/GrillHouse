package dal;

import java.sql.*;
import model.Account;

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

    /**
     * Đổi mật khẩu — kiểm tra mật khẩu cũ trước
     * Trả về true nếu thành công, false nếu mật khẩu cũ sai
     */
    public boolean changePassword(int accountID, String oldHashedPw, String newHashedPw) throws SQLException {
        // Xác nhận mật khẩu cũ đúng
        String sqlCheck = "SELECT COUNT(*) FROM Account WHERE AccountID=? AND Password=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
            ps.setInt(1, accountID);
            ps.setString(2, oldHashedPw);
            ResultSet rs = ps.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) return false; // mật khẩu cũ sai
        }
        // Cập nhật mật khẩu mới
        String sqlUpdate = "UPDATE Account SET Password=? WHERE AccountID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setString(1, newHashedPw);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy thông tin account theo ID (để refresh session sau khi update)
     */
    public Account getByID(int accountID) throws SQLException {
        String sql = "SELECT * FROM Account WHERE AccountID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /**
 * Tìm tài khoản theo email (dùng cho Google Login & kiểm tra trùng email)
 */
public Account findByEmail(String email) throws SQLException {
    String sql = "SELECT * FROM Account WHERE Email = ? AND IsActive = 1";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return mapRow(rs);
    }
    return null;
}
 
/**
 * Tạo tài khoản mới từ Google OAuth2
 * Không cần mật khẩu thật — lưu 'GOOGLE_AUTH' làm placeholder
 */
public boolean insertGoogleAccount(Account a) throws SQLException {
    String sql = "INSERT INTO Account (FullName, Email, Password, Avatar, IsAdmin, IsActive) " +
                 "VALUES (?, ?, 'GOOGLE_AUTH', ?, 0, 1)";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, a.getFullName());
        ps.setString(2, a.getEmail());
        ps.setString(3, a.getAvatar()); // có thể null
        return ps.executeUpdate() > 0;
    }
}
 
// ── mapRow helper (nếu chưa có) ──
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