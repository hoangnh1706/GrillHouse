<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${empty product ? 'Thêm món' : 'Sửa món'} – Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{background:#0f0f0f;color:#e5e5e5;font-family:'DM Sans',sans-serif;display:flex;}
    .sidebar{width:220px;min-height:100vh;background:#161616;
      border-right:1px solid #222;padding:1.5rem 1rem;position:fixed;}
    .sidebar .logo{color:#f97316;font-size:1.1rem;font-weight:800;margin-bottom:2rem;padding-left:.5rem;}
    .sidebar a{display:flex;align-items:center;gap:.6rem;color:#888;text-decoration:none;
      padding:.6rem .75rem;border-radius:8px;font-size:.9rem;margin-bottom:.2rem;transition:all .2s;}
    .sidebar a:hover,.sidebar a.active{background:#f97316;color:#fff;}
    .main{margin-left:220px;flex:1;padding:2rem;}
    .card{background:#1c1c1c;border:1px solid #2a2a2a;border-radius:14px;padding:2rem;max-width:600px;}
    h1{font-size:1.3rem;font-weight:700;color:#f0f0f0;margin-bottom:1.5rem;}
    label{display:block;font-size:.85rem;color:#888;margin-bottom:.35rem;font-weight:500;}
    input,select,textarea{width:100%;padding:.7rem 1rem;background:#252525;border:1.5px solid #333;
      border-radius:8px;color:#eee;font-size:.9rem;font-family:inherit;outline:none;
      transition:border .2s;margin-bottom:1.1rem;}
    input:focus,select:focus,textarea:focus{border-color:#f97316;}
    select option{background:#252525;}
    textarea{resize:vertical;min-height:90px;}
    .row2{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}
    .check-wrap{display:flex;align-items:center;gap:.6rem;margin-bottom:1.1rem;}
    .check-wrap input{width:auto;margin:0;}
    .btn-save{background:#f97316;color:#fff;padding:.75rem 2rem;border:none;
      border-radius:8px;font-size:.95rem;font-weight:700;cursor:pointer;font-family:inherit;
      transition:background .2s;}
    .btn-save:hover{background:#ea6a05;}
    .btn-back{color:#aaa;font-size:.88rem;text-decoration:none;display:inline-block;margin-bottom:1.2rem;}
    .btn-back:hover{color:#f97316;}
  </style>
</head>
<body>
<div class="sidebar">
  <div class="logo">⚙️ Admin Panel</div>
  <a href="${pageContext.request.contextPath}/admin/home">📊 Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/products" class="active">🍖 Món ăn</a>
  <a href="${pageContext.request.contextPath}/home" style="margin-top:2rem;">← Về trang chủ</a>
</div>

<div class="main">
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
          <option value="${cat.categoryID}"
            ${product.categoryID == cat.categoryID ? 'selected' : ''}>
            ${cat.categoryName}
          </option>
        </c:forEach>
      </select>

      <label>Tên món *</label>
      <input type="text" name="productName" value="${product.productName}" required>

      <label>Mô tả</label>
      <textarea name="description">${product.description}</textarea>

      <div class="row2">
        <div>
          <label>Giá gốc (VNĐ) *</label>
          <input type="number" name="price" value="${product.price}" min="0" step="1000" required>
        </div>
        <div>
          <label>Giá khuyến mãi (để trống nếu không)</label>
          <input type="number" name="salePrice" value="${product.salePrice}" min="0" step="1000">
        </div>
      </div>

      <div class="row2">
        <div>
          <label>Tồn kho *</label>
          <input type="number" name="stock" value="${empty product ? '0' : product.stock}" min="0" required>
        </div>
        <div>
          <label>URL ảnh</label>
          <input type="text" name="imageURL" value="${product.imageURL}" placeholder="https://...">
        </div>
      </div>

      <div class="check-wrap">
        <input type="checkbox" name="isFeatured" id="featured"
               ${product.featured ? 'checked' : ''}>
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
