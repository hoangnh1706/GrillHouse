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
        // Hiển thị trang đăng ký
        req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Đọc dữ liệu từ form đăng ký
        String fullName  = req.getParameter("fullName");
        String email     = req.getParameter("email");
        String phone     = req.getParameter("phone");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");

        // Validate các trường bắt buộc không được để trống
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }
        // Mật khẩu xác nhận phải khớp
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }
        // Mật khẩu tối thiểu 6 ký tự
        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            keepFormData(req, fullName, email, phone);
            req.getRequestDispatcher("/views/customer/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Tạo object Account và hash mật khẩu trước khi lưu
            Account acc = new Account();
            acc.setFullName(fullName.trim());
            acc.setEmail(email.trim().toLowerCase());
            acc.setPhone(phone);
            acc.setPassword(PasswordUtil.hash(password));

            boolean success = accountDAO.register(acc);
            if (success) {
                // Đăng ký thành công → chuyển sang trang login với thông báo
                resp.sendRedirect(req.getContextPath() + "/login?msg=registered");
            } else {
                // Email đã tồn tại trong hệ thống
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

    // Giữ lại dữ liệu form để người dùng không phải nhập lại khi có lỗi
    private void keepFormData(HttpServletRequest req, String name, String email, String phone) {
        req.setAttribute("fullName", name);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
    }
}
