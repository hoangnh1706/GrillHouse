<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
  <!-- ======================== HEAD BLOCK ======================== -->
  <!-- Khai báo meta, title và các thư viện CSS/Font -->
        <meta charset="UTF-8">
        <title>Quản lý món ăn – Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-product-list.css">
      </head>

      <body>
  <!-- ======================== BODY BLOCK ======================== -->
  <!-- Khung giao diện chính trang quản lý món ăn -->
        <div class="sidebar">
          <!-- ======================== SIDEBAR BLOCK ======================== -->
          <!-- Menu điều hướng bên trái dành cho Admin -->
          <div class="logo">⚙️ Admin Panel</div>
          <a href="${pageContext.request.contextPath}/admin/home"> Dashboard</a>
          <a href="${pageContext.request.contextPath}/admin/products" class="active"> Món ăn</a>
          <a href="${pageContext.request.contextPath}/admin/orders"> Đơn hàng</a>
          <a href="${pageContext.request.contextPath}/admin/feedback"> Feedback</a>
          <a href="${pageContext.request.contextPath}/admin/chatbot"> Chatbot</a>
          <a href="${pageContext.request.contextPath}/logout" style="margin-top:2rem;">← Đăng xuất</a>
        </div>

        <div class="main">
          <!-- ======================== MAIN CONTENT BLOCK ======================== -->
          <!-- Bảng danh sách các món ăn và nút thêm mới -->
          <div class="toolbar">
            <h1>🍖 Quản lý món ăn</h1>
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-add">+ Thêm món</a>
          </div>

          <c:if test="${param.msg == 'saved'}">
            <div class="msg">✅ Lưu thành công!</div>
          </c:if>
          <c:if test="${param.msg == 'deleted'}">
            <div class="msg" style="background:#292300;border-color:#854d0e;color:#fbbf24;">🗑 Đã ẩn món ăn.</div>
          </c:if>

          <table>
            <thead>
              <tr>
                <th>Ảnh</th>
                <th>#</th>
                <th>Tên món</th>
                <th>Danh mục</th>
                <th>Giá</th>
                <th>Tồn kho</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${products}">
                <tr>
                  <td>
                    <c:choose>
                      <c:when test="${not empty p.imageURL}">
                        <img class="thumb" src="${p.imageURL}" alt="${p.productName}">
                      </c:when>
                      <c:otherwise><span style="font-size:1.8rem;">🍖</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="color:#555;">${p.productID}</td>
                  <td style="font-weight:600;">${p.productName}
                    <c:if test="${p.featured}"><span class="featured-badge">⭐ Nổi bật</span></c:if>
                  </td>
                  <td style="color:#888;">${p.categoryName}</td>
                  <td class="price">
                    <fmt:formatNumber value="${p.displayPrice}" pattern="#,###" />đ
                    <c:if test="${p.salePrice != null}">
                      <div style="font-size:.75rem;color:#555;font-weight:normal;text-decoration:line-through;">
                        <fmt:formatNumber value="${p.price}" pattern="#,###" />đ
                      </div>
                    </c:if>
                  </td>
                  <td>${p.stock}</td>
                  <td>
                    <c:choose>
                      <c:when test="${p.active}"><span class="active-badge">Hiển thị</span></c:when>
                      <c:otherwise><span class="inactive-badge">Đã ẩn</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td class="actions">
                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productID}">✏️ Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productID}"
                      class="del" onclick="return confirm('Ẩn món này?')">🗑 Ẩn</a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </body>

      </html>