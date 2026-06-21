package controller;

import dal.AccountDAO;
import util.PasswordUtil;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    /** GET: hiển thị trang thông tin cá nhân */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập, chưa login thì redirect
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
    }

    /** POST: xử lý cập nhật thông tin hoặc đổi mật khẩu */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("updateProfile".equals(action)) {
                // Đọc thông tin cập nhật từ form
                String fullName = req.getParameter("fullName");
                String phone    = req.getParameter("phone");
                String address  = req.getParameter("address");

                // Họ tên bắt buộc không được để trống
                if (fullName == null || fullName.trim().isEmpty()) {
                    req.setAttribute("profileError", "Họ và tên không được để trống.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }

                // Cập nhật thông tin vào object account
                acc.setFullName(fullName.trim());
                acc.setPhone(phone != null ? phone.trim() : "");
                acc.setAddress(address != null ? address.trim() : "");

                boolean ok = accountDAO.updateProfile(acc);
                if (ok) {
                    // Cập nhật thành công: làm mới account trong session từ DB
                    Account fresh = accountDAO.getByID(acc.getAccountID());
                    req.getSession().setAttribute("account", fresh);
                    resp.sendRedirect(req.getContextPath() + "/profile?msg=updated");
                } else {
                    req.setAttribute("profileError", "Cập nhật thất bại, vui lòng thử lại.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                }

            } else if ("changePassword".equals(action)) {
                // Đọc mật khẩu cũ, mới và xác nhận từ form
                String oldPw  = req.getParameter("oldPassword");
                String newPw  = req.getParameter("newPassword");
                String cfmPw  = req.getParameter("confirmPassword");

                // Validate các trường không được để trống
                if (oldPw == null || oldPw.isEmpty() || newPw == null || newPw.isEmpty()) {
                    req.setAttribute("pwError", "Vui lòng nhập đầy đủ thông tin.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }
                // Mật khẩu mới tối thiểu 6 ký tự
                if (newPw.length() < 6) {
                    req.setAttribute("pwError", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }
                // Xác nhận mật khẩu mới phải trùng khớp
                if (!newPw.equals(cfmPw)) {
                    req.setAttribute("pwError", "Mật khẩu xác nhận không khớp.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }

                // Gọi DAO đổi mật khẩu với cả hai giá trị đã hash
                boolean ok = accountDAO.changePassword(
                    acc.getAccountID(),
                    PasswordUtil.hash(oldPw),
                    PasswordUtil.hash(newPw)
                );

                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/profile?msg=pwchanged");
                } else {
                    // Mật khẩu cũ không khớp
                    req.setAttribute("pwError", "Mật khẩu hiện tại không đúng.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("profileError", "Lỗi hệ thống, vui lòng thử lại.");
            req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
        }
    }
}
