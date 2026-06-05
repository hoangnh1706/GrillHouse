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

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int pid = Integer.parseInt(idParam);
            Product p = productDAO.getByID(pid);
            if (p == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            req.setAttribute("product", p);

            // Load reviews — nếu bảng Review chưa tạo thì set list rỗng, không crash
            try {
                req.setAttribute("reviews", reviewDAO.getByProduct(pid));
                Account acc = (Account) req.getSession().getAttribute("account");
                if (acc != null) {
                    req.setAttribute("canReview",
                        reviewDAO.hasPurchased(acc.getAccountID(), pid) &&
                        !reviewDAO.hasReviewed(acc.getAccountID(), pid));
                }
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
