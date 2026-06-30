package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ChatbotRule;

/**
 * Lớp DAO thực hiện các thao tác tương tác với cơ sở dữ liệu (CRUD)
 * cho bảng ChatbotRule (Dữ liệu trả lời của Chatbot).
 */
public class ChatbotRuleDAO extends DBContext {
    
    /**
     * Lấy toàn bộ danh sách quy tắc Chatbot từ cơ sở dữ liệu.
     * @return Danh sách các ChatbotRule
     */
    public List<ChatbotRule> getAll() throws SQLException {
        List<ChatbotRule> list = new ArrayList<>();
        String sql = "SELECT * FROM ChatbotRule";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ChatbotRule rule = new ChatbotRule(
                        rs.getInt("RuleID"),
                        rs.getString("Keywords"),
                        rs.getString("Reply")
                );
                list.add(rule);
            }
        }
        return list;
    }
    
    /**
     * Lấy thông tin một quy tắc Chatbot dựa trên ID.
     * @param id ID của quy tắc cần tìm
     * @return Đối tượng ChatbotRule nếu tìm thấy, ngược lại trả về null
     */
    public ChatbotRule getByID(int id) throws SQLException {
        String sql = "SELECT * FROM ChatbotRule WHERE RuleID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ChatbotRule(
                            rs.getInt("RuleID"),
                            rs.getString("Keywords"),
                            rs.getString("Reply")
                    );
                }
            }
        }
        return null;
    }

    /**
     * Thêm mới một quy tắc Chatbot vào cơ sở dữ liệu.
     * @param rule Đối tượng ChatbotRule cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean insert(ChatbotRule rule) throws SQLException {
        String sql = "INSERT INTO ChatbotRule (Keywords, Reply) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rule.getKeywords());
            ps.setString(2, rule.getReply());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật thông tin một quy tắc Chatbot đã có sẵn.
     * @param rule Đối tượng ChatbotRule mang thông tin mới
     * @return true nếu cập nhật thành công
     */
    public boolean update(ChatbotRule rule) throws SQLException {
        String sql = "UPDATE ChatbotRule SET Keywords = ?, Reply = ? WHERE RuleID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rule.getKeywords());
            ps.setString(2, rule.getReply());
            ps.setInt(3, rule.getRuleID());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa một quy tắc Chatbot khỏi cơ sở dữ liệu.
     * @param id ID của quy tắc cần xóa
     * @return true nếu xóa thành công
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM ChatbotRule WHERE RuleID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
