package controller.admin;

import dal.ChatbotRuleDAO;
import model.ChatbotRule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet điều khiển giao diện quản lý Chatbot của Admin.
 * Hỗ trợ chức năng xem danh sách, thêm, sửa và xóa quy tắc trả lời.
 */
@WebServlet("/admin/chatbot")
public class ChatbotManageServlet extends HttpServlet {
    private final ChatbotRuleDAO dao = new ChatbotRuleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            
            // Xử lý logic Xóa quy tắc
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.delete(id);
                req.getSession().setAttribute("msg", "Xóa thành công!");
                resp.sendRedirect(req.getContextPath() + "/admin/chatbot");
                return;
            }
            
            // Lấy danh sách đổ ra giao diện hiển thị
            req.setAttribute("rules", dao.getAll());
            req.getRequestDispatcher("/views/admin/chatbot-manage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String keywords = req.getParameter("keywords");
            String reply = req.getParameter("reply");

            // Xử lý thêm mới
            if ("add".equals(action)) {
                ChatbotRule rule = new ChatbotRule(0, keywords, reply);
                dao.insert(rule);
                req.getSession().setAttribute("msg", "Thêm mới thành công!");
            } 
            // Xử lý cập nhật thông tin
            else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("ruleID"));
                ChatbotRule rule = new ChatbotRule(id, keywords, reply);
                dao.update(rule);
                req.getSession().setAttribute("msg", "Cập nhật thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        // Hoàn tất thì quay về trang quản lý Chatbot
        resp.sendRedirect(req.getContextPath() + "/admin/chatbot");
    }
}
