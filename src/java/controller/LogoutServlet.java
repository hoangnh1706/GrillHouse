package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Hủy toàn bộ session (xóa thông tin đăng nhập, giỏ hàng, v.v.) rồi về trang chủ
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
