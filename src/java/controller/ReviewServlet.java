package controller;

import dal.ReviewDAO;
import model.Account;
import model.Review;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pidStr  = req.getParameter("productID");
        String rateStr = req.getParameter("rating");
        String comment = req.getParameter("comment");

        if (pidStr == null || rateStr == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int productID = Integer.parseInt(pidStr);
            int rating    = Integer.parseInt(rateStr);

            // Clamp rating 1-5
            rating = Math.max(1, Math.min(5, rating));

            // Kiểm tra đã mua chưa
            if (!reviewDAO.hasPurchased(acc.getAccountID(), productID)) {
                resp.sendRedirect(req.getContextPath() + "/product?id=" + productID + "&reviewError=notPurchased");
                return;
            }

            Review rv = new Review();
            rv.setProductID(productID);
            rv.setAccountID(acc.getAccountID());
            rv.setRating(rating);
            rv.setComment(comment != null ? comment.trim() : "");

            // Đã review rồi → UPDATE, chưa review → INSERT
            if (reviewDAO.hasReviewed(acc.getAccountID(), productID)) {
                reviewDAO.update(rv);
            } else {
                reviewDAO.insert(rv);
            }

            resp.sendRedirect(req.getContextPath() + "/product?id=" + productID + "&reviewSuccess=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
