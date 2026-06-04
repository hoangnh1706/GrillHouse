<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>${product.productName} – BếpNướng</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            background: #111;
            color: #e5e5e5;
            font-family: 'DM Sans', sans-serif;
          }

          .container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 1.5rem;
          }

          .breadcrumb {
            color: #555;
            font-size: .85rem;
            margin-bottom: 1.5rem;
          }

          .breadcrumb a {
            color: #f97316;
          }

          .detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2.5rem;
            align-items: start;
          }

          @media(max-width:640px) {
            .detail {
              grid-template-columns: 1fr;
            }
          }

          .img-wrap {
            border-radius: 16px;
            overflow: hidden;
            background: #1c1c1c;
            aspect-ratio: 1;
          }

          .img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
          }

          .img-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 6rem;
          }

          .info {}

          .cat-tag {
            color: #f97316;
            font-size: .82rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .5px;
          }

          .prod-name {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            line-height: 1.2;
            margin: .4rem 0 .75rem;
            color: #f0f0f0;
          }

          .rating {
            display: flex;
            align-items: center;
            gap: .5rem;
            font-size: .9rem;
            color: #fbbf24;
            margin-bottom: 1rem;
          }

          .rating span {
            color: #777;
          }

          .price-block {
            display: flex;
            align-items: center;
            gap: .75rem;
            margin-bottom: 1.25rem;
          }

          .price-main {
            font-size: 2rem;
            font-weight: 800;
            color: #f97316;
          }

          .price-old {
            font-size: 1rem;
            color: #555;
            text-decoration: line-through;
          }

          .badge-sale {
            background: #ef4444;
            color: #fff;
            font-size: .75rem;
            padding: .2rem .5rem;
            border-radius: 5px;
            font-weight: 700;
          }

          .stock {
            font-size: .88rem;
            margin-bottom: 1.25rem;
          }

          .in-stock {
            color: #4ade80;
          }

          .no-stock {
            color: #ef4444;
          }

          .desc {
            color: #aaa;
            line-height: 1.7;
            font-size: .95rem;
            margin-bottom: 1.5rem;
            padding: 1rem;
            background: #1a1a1a;
            border-radius: 10px;
            border-left: 3px solid #f97316;
          }

          .qty-row {
            display: flex;
            align-items: center;
            gap: .75rem;
            margin-bottom: 1.25rem;
          }

          .qty-label {
            font-size: .88rem;
            color: #888;
          }

          .qty-ctrl {
            display: flex;
            align-items: center;
            gap: .4rem;
          }

          .qty-btn {
            width: 34px;
            height: 34px;
            background: #252525;
            border: 1.5px solid #333;
            color: #eee;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
          }

          #qty {
            width: 50px;
            text-align: center;
            background: #1c1c1c;
            border: 1.5px solid #333;
            color: #eee;
            border-radius: 8px;
            padding: .4rem;
            font-size: 1rem;
            font-family: inherit;
          }

          .btn-add {
            width: 100%;
            padding: .9rem;
            background: #f97316;
            border: none;
            border-radius: 10px;
            color: #fff;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            transition: background .2s;
          }

          .btn-add:hover {
            background: #ea6a05;
          }

          .btn-add:disabled {
            background: #333;
            color: #666;
            cursor: not-allowed;
          }

          .back {
            display: inline-block;
            color: #777;
            font-size: .88rem;
            margin-top: 1.5rem;
          }

          .back:hover {
            color: #f97316;
          }
        </style>
      </head>

      <body>
        <%@ include file="/views/common/header.jsp" %>

          <div class="container">
            <div class="breadcrumb">
              <a href="${pageContext.request.contextPath}/home">Trang chủ</a> /
              <a
                href="${pageContext.request.contextPath}/home?category=${product.categoryID}">${product.categoryName}</a>
              /
              ${product.productName}
            </div>

            <div class="detail">
              <!-- Ảnh -->
              <div class="img-wrap">
                <c:choose>
                  <c:when test="${not empty product.imageURL}">
                    <img src="${product.imageURL}" alt="${product.productName}">
                  </c:when>
                  <c:otherwise>
                    <div class="img-placeholder">🍖</div>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- Thông tin -->
              <div class="info">
                <div class="cat-tag">${product.categoryName}</div>
                <div class="prod-name">${product.productName}</div>

                <c:if test="${product.reviewCount > 0}">
                  <div class="rating">
                    ⭐
                    <fmt:formatNumber value="${product.avgRating}" maxFractionDigits="1" />
                    <span>(${product.reviewCount} đánh giá)</span>
                  </div>
                </c:if>

                <div class="price-block">
                  <span class="price-main">
                    <fmt:formatNumber value="${product.displayPrice}" pattern="#,###" />đ
                  </span>
                  <c:if test="${product.salePrice != null}">
                    <span class="price-old">
                      <fmt:formatNumber value="${product.price}" pattern="#,###" />đ
                    </span>
                    <span class="badge-sale">SALE</span>
                  </c:if>
                </div>

                <div class="stock">
                  <c:choose>
                    <c:when test="${product.inStock}">
                      <span class="in-stock">✅ Còn hàng (${product.stock} phần)</span>
                    </c:when>
                    <c:otherwise>
                      <span class="no-stock">❌ Tạm hết hàng</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <c:if test="${not empty product.description}">
                  <div class="desc">${product.description}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/cart" method="post">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="productID" value="${product.productID}">

                  <div class="qty-row">
                    <span class="qty-label">Số lượng:</span>
                    <div class="qty-ctrl">
                      <button type="button" class="qty-btn" onclick="adj(-1)">−</button>
                      <input type="number" id="qty" name="quantity" value="1" min="1" max="${product.stock}">
                      <button type="button" class="qty-btn" onclick="adj(1)">+</button>
                    </div>
                  </div>

                  <button type="submit" class="btn-add" <c:if test="${!product.inStock}">disabled</c:if>>
                    🛒 Thêm vào giỏ hàng
                  </button>
                </form>

                <a href="javascript:history.back()" class="back">← Quay lại</a>
              </div>
            </div>
          </div>

          <script>
            function adj(delta) {
              const inp = document.getElementById('qty');
              const max = parseInt(inp.max) || 99;
              inp.value = Math.min(max, Math.max(1, parseInt(inp.value) + delta));
            }
          </script>
      </body>

      </html>