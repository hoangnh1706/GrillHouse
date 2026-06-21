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

        // Đọc tất cả tham số filter từ request
        String catParam     = req.getParameter("category");
        String priceParam   = req.getParameter("price");
        String ratingParam  = req.getParameter("rating");
        String sortParam    = req.getParameter("sort");
        String featuredParam= req.getParameter("featured");
        String saleParam    = req.getParameter("sale");

        int    categoryID   = (catParam    != null && !catParam.isEmpty())    ? safeInt(catParam, 0)       : 0;
        int    priceRange   = (priceParam  != null && !priceParam.isEmpty())  ? safeInt(priceParam, 0)     : 0;
        double minRating    = (ratingParam != null && !ratingParam.isEmpty()) ? safeDouble(ratingParam, 0) : 0;
        boolean onlyFeatured= "1".equals(featuredParam);
        boolean onlySale    = "1".equals(saleParam);
        boolean hasFilter   = categoryID > 0 || priceRange > 0 || minRating > 0
                              || (sortParam != null && !sortParam.isEmpty())
                              || onlyFeatured || onlySale;

        try {
            // Luôn load danh mục để hiển thị dropdown
            req.setAttribute("categories",   categoryDAO.getAll());
            req.setAttribute("selectedCat",  categoryID);

            if (hasFilter) {
                // Có filter → dùng method filter tổng hợp
                req.setAttribute("products", productDAO.filter(
                    categoryID, priceRange, minRating,
                    sortParam, onlyFeatured, onlySale
                ));
            } else {
                // Không filter → trang chủ mặc định
                req.setAttribute("products", productDAO.getAllProducts());
                req.setAttribute("featured", productDAO.getFeatured(6));
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải dữ liệu, vui lòng thử lại.");
        }

        // Forward sang view trang chủ
        req.getRequestDispatcher("/views/customer/home.jsp").forward(req, resp);
    }

    private int safeInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private double safeDouble(String s, double def) {
        try { return Double.parseDouble(s); } catch (Exception e) { return def; }
    }
}
