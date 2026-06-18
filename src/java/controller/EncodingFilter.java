package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

// Filter áp dụng cho toàn bộ ứng dụng, đảm bảo mọi request/response đều dùng UTF-8
@WebFilter("/*")
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        // Thiết lập encoding UTF-8 cho request và response trước khi xử lý
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        chain.doFilter(req, res);
    }
}
