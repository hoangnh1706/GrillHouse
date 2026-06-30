<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
  <!-- ======================== HEAD BLOCK ======================== -->
  <!-- Khai báo meta, title và các thư viện CSS/Font -->
      <meta charset="UTF-8">
      <title>${empty product ? 'Thêm món' : 'Sửa món'} – Admin</title>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-product-form.css">
    </head>

    <body>
  <!-- ======================== BODY BLOCK ======================== -->
  <!-- Khung giao diện chính form thêm/sửa món ăn -->
      <div class="sidebar">
        <!-- ======================== SIDEBAR BLOCK ======================== -->
        <!-- Menu điều hướng bên trái dành cho Admin -->
        <div class="logo"> Admin Panel</div>
        <a href="${pageContext.request.contextPath}/admin/home"> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products" class="active"> Món ăn</a>
        <a href="${pageContext.request.contextPath}/admin/orders"> Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/feedback" > Feedback</a>
        <a href="${pageContext.request.contextPath}/admin/chatbot"> Chatbot</a>
        <a href="${pageContext.request.contextPath}/logout" style="margin-top:2rem;">← Đăng xuất</a>
      </div>

      <div class="main">
        <!-- ======================== MAIN CONTENT BLOCK ======================== -->
        <!-- Form nhập thông tin chi tiết của món ăn -->
        <a href="${pageContext.request.contextPath}/admin/products" class="btn-back">← Quay lại danh sách</a>
        <div class="card">
          <h1>${empty product ? '➕ Thêm món ăn' : '✏️ Sửa món ăn'}</h1>

          <form action="${pageContext.request.contextPath}/admin/products" method="post">
            <c:if test="${not empty product}">
              <input type="hidden" name="productID" value="${product.productID}">
            </c:if>

            <label>Danh mục *</label>
            <select name="categoryID" required>
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryID}" ${product.categoryID==cat.categoryID ? 'selected' : '' }>
                  ${cat.categoryName}
                </option>
              </c:forEach>
            </select>

            <label>Tên món </label>
            <input type="text" name="productName" value="${product.productName}" required>

            <label>Mô tả</label>
            <textarea name="description">${product.description}</textarea>

            <div class="row2">
              <div>
                <label>Giá gốc (VND) </label>
                <input type="number" name="price" value="${product.price}" min="0" step="1000" required>
              </div>
              <div>
                <label>Giá khuyến mãi </label>
                <input type="number" name="salePrice" value="${product.salePrice}" min="0" step="1000">
              </div>
            </div>

            <div class="row2">
              <div>
                <label>Tồn kho </label>
                <input type="number" name="stock" value="${empty product ? '0' : product.stock}" min="0" required>
              </div>
              <div>
                <label>URL ảnh</label>
                <input type="text" name="imageURL" value="${product.imageURL}" placeholder="https://...">
              </div>
            </div>

            <div class="check-wrap">
              <input type="checkbox" name="isFeatured" id="featured" ${product.featured ? 'checked' : '' }>
              <label for="featured" style="margin:0;">⭐ Đánh dấu nổi bật</label>
            </div>

            <button type="submit" class="btn-save">
              ${empty product ? '➕ Thêm món' : '💾 Lưu thay đổi'}
            </button>
          </form>
        </div>
      </div>
    </body>

    </html>