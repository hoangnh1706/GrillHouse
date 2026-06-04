package controller.admin;

import dal.OrderDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    /** GET: danh sách đơn hàng, có thể lọc theo ?status=0,1,2,3,4 */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String statusParam = req.getParameter("status");
        int filterStatus = -1; // mặc định: tất cả
        if (statusParam != null && !statusParam.isEmpty()) {
            try { filterStatus = Integer.parseInt(statusParam); } catch (NumberFormatException ignored) {}
        }

        try {
            req.setAttribute("orders",       orderDAO.getAll(filterStatus));
            req.setAttribute("filterStatus", filterStatus);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải danh sách đơn hàng.");
        }

        req.getRequestDispatcher("/views/admin/order-list.jsp").forward(req, resp);
    }

    /** POST: cập nhật trạng thái đơn hàng */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderIDParam = req.getParameter("orderID");
        String newStatusParam = req.getParameter("newStatus");

        try {
            int orderID   = Integer.parseInt(orderIDParam);
            int newStatus = Integer.parseInt(newStatusParam);
            orderDAO.updateStatus(orderID, newStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Quay lại trang trước (giữ filter)
        String referer = req.getHeader("Referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/admin/orders");
    }
}
