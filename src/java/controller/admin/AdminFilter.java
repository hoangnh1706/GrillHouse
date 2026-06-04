package controller.admin;

import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        Account acc = (Account) request.getSession().getAttribute("account");

        if (acc == null) {
            // Chưa đăng nhập → về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!acc.isAdmin()) {
            // Đăng nhập rồi nhưng không phải admin → về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        chain.doFilter(req, res); // OK, cho qua
    }
}