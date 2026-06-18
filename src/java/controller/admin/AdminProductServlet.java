package controller.admin;

import dal.CategoryDAO;
import dal.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    /** GET: danh sách hoặc form thêm/sửa */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            // Luôn load danh mục để dùng trong dropdown form
            req.setAttribute("categories", categoryDAO.getAll());

            if ("add".equals(action)) {
                // Không set product → form hiểu là thêm mới
                req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, resp);
                return;
            }

            if ("edit".equals(action)) {
                // Load sản phẩm theo id và forward sang form chỉnh sửa
                int pid = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("product", productDAO.getByID(pid));
                req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, resp);
                return;
            }

            if ("delete".equals(action)) {
                // Xóa sản phẩm theo id rồi redirect về danh sách
                int pid = Integer.parseInt(req.getParameter("id"));
                productDAO.delete(pid);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
                return;
            }

            // Mặc định: hiển thị toàn bộ danh sách sản phẩm (bao gồm cả đã ẩn)
            req.setAttribute("products", productDAO.getAll_Admin());
            req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=1");
        }
    }

    /** POST: lưu thêm mới hoặc cập nhật sản phẩm */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Xác định là thêm mới hay chỉnh sửa dựa vào sự hiện diện của productID
        String idParam = req.getParameter("productID");
        boolean isEdit = (idParam != null && !idParam.isEmpty());

        try {
            // Đọc toàn bộ thông tin sản phẩm từ form và gán vào object Product
            Product p = new Product();
            if (isEdit) p.setProductID(Integer.parseInt(idParam));
            p.setCategoryID(Integer.parseInt(req.getParameter("categoryID")));
            p.setProductName(req.getParameter("productName"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(new BigDecimal(req.getParameter("price")));
            p.setStock(Integer.parseInt(req.getParameter("stock")));
            p.setImageURL(req.getParameter("imageURL"));
            p.setFeatured("on".equals(req.getParameter("isFeatured")));
            p.setActive(true);

            // Giá khuyến mãi có thể bỏ trống → set null nếu không có
            String salePriceStr = req.getParameter("salePrice");
            p.setSalePrice((salePriceStr != null && !salePriceStr.isEmpty())
                ? new BigDecimal(salePriceStr) : null);

            // Cập nhật hoặc thêm mới tùy theo action
            if (isEdit) productDAO.update(p);
            else        productDAO.insert(p);

            resp.sendRedirect(req.getContextPath() + "/admin/products?msg=saved");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=1");
        }
    }
}
