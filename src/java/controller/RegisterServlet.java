package controller;

import dal.AccountDAO;
import dal.PasswordUtil;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName  = req.getParameter("fullName");
        String email     = req.getParameter("email");
        String phone     = req.getParameter("phone");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");

        // Validate
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }

        try {
            Account acc = new Account();
            acc.setFullName(fullName.trim());
            acc.setEmail(email.trim().toLowerCase());
            acc.setPhone(phone);
            acc.setPassword(PasswordUtil.hash(password));

            boolean success = accountDAO.register(acc);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/login?msg=registered");
            } else {
                req.setAttribute("error", "Email này đã được đăng ký. Vui lòng dùng email khác.");
                keepFormData(req, fullName, email, phone);
                req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại.");
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
        }
    }

    private void keepFormData(HttpServletRequest req, String name, String email, String phone) {
        req.setAttribute("fullName", name);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
    }
}