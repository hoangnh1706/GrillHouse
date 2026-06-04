<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Quản lý món ăn – Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            background: #0f0f0f;
            color: #e5e5e5;
            font-family: 'DM Sans', sans-serif;
            display: flex;
          }

          .sidebar {
            width: 220px;
            min-height: 100vh;
            background: #161616;
            border-right: 1px solid #222;
            padding: 1.5rem 1rem;
            position: fixed;
          }

          .sidebar .logo {
            color: #f97316;
            font-size: 1.1rem;
            font-weight: 800;
            margin-bottom: 2rem;
            padding-left: .5rem;
          }

          .sidebar a {
            display: flex;
            align-items: center;
            gap: .6rem;
            color: #888;
            text-decoration: none;
            padding: .6rem .75rem;
            border-radius: 8px;
            font-size: .9rem;
            margin-bottom: .2rem;
            transition: all .2s;
          }

          .sidebar a:hover,
          .sidebar a.active {
            background: #f97316;
            color: #fff;
          }

          .main {
            margin-left: 220px;
            flex: 1;
            padding: 2rem;
          }

          h1 {
            font-size: 1.4rem;
            font-weight: 700;
            color: #f0f0f0;
            margin-bottom: 1.5rem;
          }

          .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.2rem;
          }

          .btn-add {
            background: #f97316;
            color: #fff;
            padding: .55rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: .9rem;
          }

          .msg {
            background: #14532d;
            border: 1px solid #166534;
            color: #86efac;
            border-radius: 8px;
            padding: .65rem 1rem;
            margin-bottom: 1rem;
            font-size: .88rem;
          }

          table {
            width: 100%;
            border-collapse: collapse;
            background: #1a1a1a;
            border-radius: 12px;
            overflow: hidden;
          }

          th {
            background: #222;
            color: #777;
            font-size: .75rem;
            text-transform: uppercase;
            letter-spacing: .5px;
            padding: .65rem 1rem;
            text-align: left;
          }

          td {
            padding: .75rem 1rem;
            border-bottom: 1px solid #1f1f1f;
            font-size: .87rem;
          }

          tr:last-child td {
            border: none;
          }

          .price {
            color: #f97316;
            font-weight: 700;
          }

          .active-badge {
            background: #14532d;
            color: #86efac;
            padding: .18rem .5rem;
            border-radius: 12px;
            font-size: .72rem;
          }

          .inactive-badge {
            background: #3b1a1a;
            color: #f87171;
            padding: .18rem .5rem;
            border-radius: 12px;
            font-size: .72rem;
          }

          .featured-badge {
            background: #2d1800;
            color: #fb923c;
            padding: .18rem .5rem;
            border-radius: 12px;
            font-size: .72rem;
          }

          .actions a {
            color: #60a5fa;
            font-size: .83rem;
            text-decoration: none;
            margin-right: .6rem;
          }

          .actions a.del {
            color: #f87171;
          }

          .actions a:hover {
            text-decoration: underline;
          }

          img.thumb {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            object-fit: cover;
            background: #141414;
          }
        </style>
      </head>

      <body>
        <div class="sidebar">
          <div class="logo">⚙️ Admin Panel</div>
          <a href="${pageContext.request.contextPath}/admin/home">📊 Dashboard</a>
          <a href="${pageContext.request.contextPath}/admin/products" class="active">🍖 Món ăn</a>
          <a href="${pageContext.request.contextPath}/admin/orders">📦 Đơn hàng</a>
          <a href="${pageContext.request.contextPath}/home" style="margin-top:2rem;">← Về trang chủ</a>
        </div>

        <div class="main">
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