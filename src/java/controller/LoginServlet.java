package controller;

import dal.AccountDAO;
import dal.PasswordUtil;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    /** GET: hiển thị trang đăng nhập */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Nếu đã login rồi thì về trang chủ
        if (req.getSession().getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/views/customer/login.jsp").forward(req, resp);
    }

    /** POST: xử lý form đăng nhập */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Validate không được để trống
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu.");
            req.getRequestDispatcher("/views/customer/login.jsp").forward(req, resp);
            return;
        }

        try {
            String hashedPw = PasswordUtil.hash(password);
            Account acc = accountDAO.login(email.trim(), hashedPw);

            if (acc != null) {
                HttpSession session = req.getSession();
                session.setAttribute("account", acc);
                session.setMaxInactiveInterval(60 * 60); // 1 giờ

                // Admin → trang quản trị, user → trang chủ
                String redirect = acc.isAdmin()
                    ? req.getContextPath() + "/admin/home"
                    : req.getContextPath() + "/home";
                resp.sendRedirect(redirect);
            } else {
                req.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                req.setAttribute("email", email); // giữ lại email đã nhập
                req.getRequestDispatcher("/views/customer/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại.");
            req.getRequestDispatcher("/views/customer/login.jsp").forward(req, resp);
        }
    }
}