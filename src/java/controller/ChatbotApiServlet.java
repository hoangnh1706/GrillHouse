package controller;

import dal.ChatbotRuleDAO;
import model.ChatbotRule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet API nhận yêu cầu tin nhắn từ người dùng (Frontend), 
 * đối chiếu với tập quy tắc trong Database để trả về câu trả lời tương ứng.
 */
@WebServlet("/api/chatbot")
public class ChatbotApiServlet extends HttpServlet {
    private final ChatbotRuleDAO dao = new ChatbotRuleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Thiết lập chuẩn mã hóa tiếng Việt và kiểu dữ liệu trả về là văn bản thường
        resp.setContentType("text/plain");
        resp.setCharacterEncoding("UTF-8");
        
        // Lấy tin nhắn của người dùng gửi lên, chuyển thành chữ thường để dễ so khớp
        String message = req.getParameter("message");
        if (message == null) message = "";
        message = message.toLowerCase().trim();
        
        // Câu trả lời mặc định nếu không khớp từ khóa nào
        String reply = "🤔 Mình chưa hiểu câu hỏi này.\nBạn hỏi về: món ăn, combo, giao hàng, thanh toán, đơn hàng?\nHotline: <b style=\"color:#f97316\">1900 1234</b>";
        
        try {
            // Lấy tất cả quy tắc từ CSDL
            List<ChatbotRule> rules = dao.getAll();
            for (ChatbotRule r : rules) {
                String[] keys = r.getKeywords().split(",");
                boolean match = false;
                
                // Kiểm tra xem tin nhắn có chứa bất kỳ từ khóa nào trong danh sách không
                for (String k : keys) {
                    if (!k.trim().isEmpty() && message.contains(k.trim().toLowerCase())) {
                        match = true;
                        break;
                    }
                }
                // Nếu khớp từ khóa, gán câu trả lời và dừng quá trình tìm kiếm
                if (match) {
                    reply = r.getReply();
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Đang có lỗi kết nối, vui lòng thử lại sau.";
        }
        
        // Gửi câu trả lời về cho client
        resp.getWriter().write(reply);
    }
}
