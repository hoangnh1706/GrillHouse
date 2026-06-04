package controller;

import dal.OrderDAO;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/my-orders")
public class OrderHistoryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("orders", orderDAO.getByAccount(acc.getAccountID()));

            // Thông báo đặt hàng thành công
            String successID = req.getParameter("success");
            if (successID != null) {
                req.setAttribute("successMsg", "Đặt hàng thành công! Mã đơn hàng: #" + successID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/views/customer/order-history.jsp").forward(req, resp);
    }
}