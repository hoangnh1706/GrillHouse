package controller;

import dal.OrderDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Phải đăng nhập mới vào được checkout
        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=checkout");
            return;
        }

        Cart cart = (Cart) req.getSession().getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.getRequestDispatcher("/views/customer/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Cart cart = (Cart) req.getSession().getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String shipAddress    = req.getParameter("shipAddress");
        String phone          = req.getParameter("phone");
        String note           = req.getParameter("note");
        String paymentMethod  = req.getParameter("paymentMethod");

        // Validate
        if (shipAddress == null || shipAddress.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ giao hàng và số điện thoại.");
            req.getRequestDispatcher("/views/customer/checkout.jsp").forward(req, resp);
            return;
        }

        try {
            Order order = new Order();
            order.setAccountID(acc.getAccountID());
            order.setShipAddress(shipAddress.trim());
            order.setPhone(phone.trim());
            order.setNote(note);
            order.setPaymentMethod(paymentMethod != null ? paymentMethod : "Tiền mặt");

            int newOrderID = orderDAO.createOrder(order, cart);

            if (newOrderID > 0) {
                // Xóa giỏ hàng sau khi đặt thành công
                req.getSession().removeAttribute("cart");
                resp.sendRedirect(req.getContextPath() + "/my-orders?success=" + newOrderID);
            } else {
                req.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại.");
                req.getRequestDispatcher("/views/customer/checkout.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/customer/checkout.jsp").forward(req, resp);
        }
    }
}