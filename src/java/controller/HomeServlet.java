package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Đọc tham số lọc theo danh mục (nếu có)
        String catParam = req.getParameter("category");

        try {
            // Luôn load danh mục để hiển thị menu điều hướng
            req.setAttribute("categories", categoryDAO.getAll());

            if (catParam != null && !catParam.isEmpty()) {
                // Lọc sản phẩm theo danh mục được chọn
                int cid = Integer.parseInt(catParam);
                req.setAttribute("products",     productDAO.getByCategory(cid));
                req.setAttribute("selectedCat",  cid);
            } else {
                // Trang chủ: lấy tất cả sản phẩm và danh sách nổi bật
                req.setAttribute("products",     productDAO.getAllProducts());
                req.setAttribute("featured",     productDAO.getFeatured(6));
                req.setAttribute("selectedCat",  0);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải dữ liệu, vui lòng thử lại.");
        }

        // Forward sang view trang chủ
        req.getRequestDispatcher("/views/customer/home.jsp").forward(req, resp);
    }
}
