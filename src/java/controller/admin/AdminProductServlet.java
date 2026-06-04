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
            req.setAttribute("categories", categoryDAO.getAll());

            if ("edit".equals(action)) {
                int pid = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("product", productDAO.getByID(pid));
                req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, resp);
                return;
            }

            if ("delete".equals(action)) {
                int pid = Integer.parseInt(req.getParameter("id"));
                productDAO.delete(pid);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
                return;
            }

            // Mặc định: danh sách
            req.setAttribute("products", productDAO.getAll_Admin());
            req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=1");
        }
    }

    /** POST: lưu thêm mới hoặc cập nhật */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("productID");
        boolean isEdit = (idParam != null && !idParam.isEmpty());

        try {
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

            String salePriceStr = req.getParameter("salePrice");
            p.setSalePrice((salePriceStr != null && !salePriceStr.isEmpty())
                ? new BigDecimal(salePriceStr) : null);

            if (isEdit) productDAO.update(p);
            else        productDAO.insert(p);

            resp.sendRedirect(req.getContextPath() + "/admin/products?msg=saved");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=1");
        }
    }
}