package controller.admin;

import dal.OrderDAO;
import dal.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/home")
public class AdminDashboardServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO   orderDAO   = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Lấy tổng số sản phẩm, tất cả đơn hàng và số đơn đang chờ xử lý (status=0)
            req.setAttribute("totalProducts", productDAO.getAll_Admin().size());
            req.setAttribute("recentOrders",  orderDAO.getAll(-1));
            req.setAttribute("pendingOrders", orderDAO.getAll(0).size());
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Forward sang view dashboard admin
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}
