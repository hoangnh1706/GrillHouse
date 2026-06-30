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

        // Kiểm tra đăng nhập, chưa login thì redirect sang trang login
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy danh sách đơn hàng của tài khoản, filter theo status nếu có
            String statusParam = req.getParameter("status");
            java.util.List<model.Order> orders;
            if (statusParam != null && !statusParam.isEmpty()) {
                // Lọc theo status: lấy tất cả rồi filter
                orders = new java.util.ArrayList<>();
                for (model.Order o : orderDAO.getByAccount(acc.getAccountID())) {
                    if (o.getStatus() == Integer.parseInt(statusParam))
                        orders.add(o);
                }
            } else {
                orders = orderDAO.getByAccount(acc.getAccountID());
            }
            // Load thêm details (danh sách món) cho từng đơn để hiện nút Feedback
            for (model.Order o : orders) {
                model.Order full = orderDAO.getByID(o.getOrderID());
                if (full != null)
                    o.setDetails(full.getDetails());
            }
            req.setAttribute("orders", orders);

            // Nếu vừa đặt hàng xong, hiển thị thông báo thành công kèm mã đơn
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
