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
            // Lấy danh sách đơn hàng của tài khoản hiện tại
            req.setAttribute("orders", orderDAO.getByAccount(acc.getAccountID()));

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
