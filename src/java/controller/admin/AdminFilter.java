package controller.admin;

import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

// Filter bảo vệ toàn bộ URL /admin/*, chỉ cho admin đã đăng nhập đi qua
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Lấy thông tin tài khoản từ session
        Account acc = (Account) request.getSession().getAttribute("account");

        if (acc == null) {
            // Chưa đăng nhập → về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!acc.isAdmin()) {
            // Đã đăng nhập nhưng không phải admin → về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Tài khoản hợp lệ, cho request đi tiếp
        chain.doFilter(req, res);
    }
}
