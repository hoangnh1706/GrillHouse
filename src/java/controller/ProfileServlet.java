package controller;

import dal.AccountDAO;
import dal.PasswordUtil;
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

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("updateProfile".equals(action)) {
                String fullName = req.getParameter("fullName");
                String phone    = req.getParameter("phone");
                String address  = req.getParameter("address");

                if (fullName == null || fullName.trim().isEmpty()) {
                    req.setAttribute("profileError", "Họ và tên không được để trống.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }

                acc.setFullName(fullName.trim());
                acc.setPhone(phone != null ? phone.trim() : "");
                acc.setAddress(address != null ? address.trim() : "");

                boolean ok = accountDAO.updateProfile(acc);
                if (ok) {
                    // Refresh account trong session
                    Account fresh = accountDAO.getByID(acc.getAccountID());
                    req.getSession().setAttribute("account", fresh);
                    resp.sendRedirect(req.getContextPath() + "/profile?msg=updated");
                } else {
                    req.setAttribute("profileError", "Cập nhật thất bại, vui lòng thử lại.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                }

            } else if ("changePassword".equals(action)) {
                String oldPw  = req.getParameter("oldPassword");
                String newPw  = req.getParameter("newPassword");
                String cfmPw  = req.getParameter("confirmPassword");

                if (oldPw == null || oldPw.isEmpty() || newPw == null || newPw.isEmpty()) {
                    req.setAttribute("pwError", "Vui lòng nhập đầy đủ thông tin.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }
                if (newPw.length() < 6) {
                    req.setAttribute("pwError", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }
                if (!newPw.equals(cfmPw)) {
                    req.setAttribute("pwError", "Mật khẩu xác nhận không khớp.");
                    req.getRequestDispatcher("/views/customer/profile.jsp").forward(req, resp);
                    return;
                }

                boolean ok = accountDAO.changePassword(
                    acc.getAccountID(),
                    PasswordUtil.hash(oldPw),
                    PasswordUtil.hash(newPw)
                );

                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/profile?msg=pwchanged");
                } else {
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
