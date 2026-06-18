package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy từ khóa tìm kiếm từ tham số q, mặc định là chuỗi rỗng
        String keyword = req.getParameter("q");
        if (keyword == null) keyword = "";

        try {
            // Load danh mục để hiển thị menu và tìm sản phẩm theo từ khóa
            req.setAttribute("categories", categoryDAO.getAll());
            req.setAttribute("products",   productDAO.search(keyword.trim()));
            req.setAttribute("keyword",    keyword);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Tái sử dụng view trang chủ để hiển thị kết quả tìm kiếm
        req.getRequestDispatcher("/views/customer/home.jsp").forward(req, resp);
    }
}
