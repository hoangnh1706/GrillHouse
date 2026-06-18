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
                    // Lấy productID và số lượng từ request, tối thiểu là 1
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    if (qty < 1) qty = 1;

                    // Kiểm tra sản phẩm tồn tại và còn hàng mới thêm vào giỏ
                    Product p = productDAO.getByID(pid);
                    if (p != null && p.isInStock()) {
                        cart.add(p, qty);
                        session.setAttribute("cart", cart);
                        // Lưu thông báo thành công vào session để hiển thị sau redirect
                        session.setAttribute("cartMsg", "Đã thêm \"" + p.getProductName() + "\" vào giỏ hàng!");
                    }
                    // Quay lại trang trước (sản phẩm) hoặc trang chủ nếu không có referer
                    String referer = req.getHeader("Referer");
                    resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/home");
                    return;
                }

                case "update": {
                    // Cập nhật số lượng sản phẩm trong giỏ; nếu qty <= 0 sẽ tự xóa
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    cart.update(pid, qty);
                    session.setAttribute("cart", cart);
                    break;
                }

                case "remove": {
                    // Xóa một sản phẩm khỏi giỏ hàng theo productID
                    int pid = Integer.parseInt(req.getParameter("productID"));
                    cart.remove(pid);
                    session.setAttribute("cart", cart);
                    break;
                }

                case "clear": {
                    // Xóa toàn bộ giỏ hàng
                    cart.clear();
                    session.setAttribute("cart", cart);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sau khi update/remove/clear thì redirect về trang giỏ hàng
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
