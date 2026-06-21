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
            // Stat tổng quan
            req.setAttribute("totalProducts", productDAO.getAll_Admin().size());
            req.setAttribute("recentOrders",  orderDAO.getAll(-1));
            req.setAttribute("pendingOrders", orderDAO.getAll(0).size());
            req.setAttribute("totalRevenue",  orderDAO.getTotalRevenue());

            // Breakdown theo status
            req.setAttribute("statusCounts", orderDAO.getCountByStatus());

            // Doanh thu theo 7 ngày gần nhất (status=3, theo OrderDate)
            req.setAttribute("revenueLast7Days", orderDAO.getRevenueLast7Days());

            // Top sản phẩm bán chạy
            req.setAttribute("topProducts", orderDAO.getTopProducts(5));

            // Doanh thu theo tháng & xu hướng
            req.setAttribute("revenueTrend12Months", orderDAO.getRevenueTrend12Months());
        } catch (Exception e) {

            e.printStackTrace();
        }
        // Forward sang view dashboard admin
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}

