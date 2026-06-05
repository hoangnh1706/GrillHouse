package controller;

import dal.ProductDAO;
import model.Cart;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Hiển thị trang giỏ hàng
        req.getRequestDispatcher("/views/customer/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        // Chưa đăng nhập → không cho thêm/sửa/xóa giỏ hàng
        if (session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=cart");
            return;
        }

        // Lấy giỏ từ session, nếu chưa có thì tạo mới
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        try {
            switch (action == null ? "" : action) {

                case "add": {
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    if (qty < 1) qty = 1;
                    Product p = productDAO.getByID(pid);
                    if (p != null && p.isInStock()) {
                        cart.add(p, qty);
                        session.setAttribute("cart", cart);
                        // Thông báo thành công rồi quay lại trang trước
                        session.setAttribute("cartMsg", "Đã thêm \"" + p.getProductName() + "\" vào giỏ hàng!");
                    }
                    // Quay lại trang sản phẩm hoặc trang chủ
                    String referer = req.getHeader("Referer");
                    resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/home");
                    return;
                }

                case "update": {
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    cart.update(pid, qty);
                    session.setAttribute("cart", cart);
                    break;
                }

                case "remove": {
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    cart.remove(pid);
                    session.setAttribute("cart", cart);
                    break;
                }

                case "clear": {
                    cart.clear();
                    session.setAttribute("cart", cart);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}