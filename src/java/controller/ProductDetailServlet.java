package controller;

import dal.ProductDAO;
import dal.ReviewDAO;
import model.Account;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final ReviewDAO  reviewDAO  = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Bắt buộc phải có tham số id, không có thì về trang chủ
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int pid = Integer.parseInt(idParam);

            // Kiểm tra sản phẩm tồn tại trong DB
            Product p = productDAO.getByID(pid);
            if (p == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            req.setAttribute("product", p);

            // Kiểm tra quyền đánh giá trước (query OrderDetail/Order — luôn tồn tại)
            Account acc = (Account) req.getSession().getAttribute("account");
            if (acc != null) {
                try {
                    boolean hasPurchased = reviewDAO.hasPurchased(acc.getAccountID(), pid);
                    boolean hasReviewed  = reviewDAO.hasReviewed(acc.getAccountID(), pid);
                    req.setAttribute("canReview",    hasPurchased);  // đã mua → có thể review hoặc sửa
                    req.setAttribute("hasPurchased", hasPurchased);
                    req.setAttribute("hasReviewed",  hasReviewed);
                    // Nếu đã review rồi → load review cũ để điền sẵn vào form sửa
                    if (hasReviewed) {
                        req.setAttribute("myReview", reviewDAO.getByAccountAndProduct(acc.getAccountID(), pid));
                    }
                } catch (Exception ex) {
                    req.setAttribute("canReview", false);
                }
            }

            // Load danh sách đánh giá (bảng Review có thể chưa tồn tại)
            try {
                req.setAttribute("reviews", reviewDAO.getByProduct(pid));
            } catch (Exception reviewEx) {
                req.setAttribute("reviews", new java.util.ArrayList<>());
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        req.getRequestDispatcher("/views/customer/product-detail.jsp").forward(req, resp);
    }
}
