package controller.admin;

import dal.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/feedback")
public class AdminFeedbackServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        try {
            if ("delete".equals(action) && idParam != null) {
                int reviewID = Integer.parseInt(idParam);
                reviewDAO.delete(reviewID);
                resp.sendRedirect(req.getContextPath() + "/admin/feedback?msg=deleted");
                return;
            }

            req.setAttribute("feedbackList", reviewDAO.getAllForAdmin());
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải danh sách feedback.");
        }

        req.getRequestDispatcher("/views/admin/feedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        String reply = req.getParameter("reply");

        try {
            if ("reply".equals(action) && idParam != null) {
                int reviewID = Integer.parseInt(idParam);
                reviewDAO.updateAdminReply(reviewID, reply);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/feedback?msg=replied");
    }
}
