<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>BếpNướng – Đặt món ngon tận nơi</title>
          <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap"
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

            /* Hero */
            .hero {
              background: linear-gradient(135deg, #1a0800 0%, #2d1100 50%, #111 100%);
              padding: 4rem 2rem;
              text-align: center;
              border-bottom: 1px solid #2a2a2a;
            }

            .hero h1 {
              font-family: 'Playfair Display', serif;
              font-size: clamp(2rem, 5vw, 3.5rem);
              color: #fff;
              line-height: 1.15;
              margin-bottom: 1rem;
            }

            .hero h1 span {
              color: #f97316;
            }

            .hero p {
              color: #888;
              font-size: 1.1rem;
              max-width: 500px;
              margin: 0 auto 2rem;
            }

            .hero-btn {
              background: #f97316;
              color: #fff;
              padding: .8rem 2rem;
              border-radius: 50px;
              text-decoration: none;
              font-weight: 700;
              font-size: 1rem;
              transition: transform .2s, box-shadow .2s;
              display: inline-block;
            }

            .hero-btn:hover {
              transform: translateY(-2px);
              box-shadow: 0 8px 24px rgba(249, 115, 22, .4);
            }

            /* Categories */
            .section {
              max-width: 1200px;
              margin: 0 auto;
              padding: 2.5rem 1.5rem;
            }

            .section-title {
              font-family: 'Playfair Display', serif;
              font-size: 1.6rem;
              color: #f0f0f0;
              margin-bottom: 1.5rem;
              display: flex;
              align-items: center;
              gap: .5rem;
            }

            .cats {
              display: flex;
              gap: .75rem;
              flex-wrap: wrap;
              margin-bottom: 2.5rem;
            }

            .cat-btn {
              padding: .45rem 1.1rem;
              border-radius: 50px;
              text-decoration: none;
              font-size: .88rem;
              font-weight: 600;
              border: 1.5px solid #333;
              color: #aaa;
              transition: all .2s;
            }

            .cat-btn:hover,
            .cat-btn.active {
              background: #f97316;
              border-color: #f97316;
              color: #fff;
            }

            /* Product grid */
            .grid {
              display: grid;
              grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
              gap: 1.4rem;
            }

            .card {
              background: #1c1c1c;
              border: 1px solid #252525;
              border-radius: 16px;
              overflow: hidden;
              transition: transform .2s, box-shadow .2s;
              display: flex;
              flex-direction: column;
            }

            .card:hover {
              transform: translateY(-5px);
              box-shadow: 0 12px 32px rgba(0, 0, 0, .5);
            }

            .card-img {
              aspect-ratio: 4/3;
              overflow: hidden;
              background: #141414;
              position: relative;
            }

            .card-img img {
              width: 100%;
              height: 100%;
              object-fit: cover;
              transition: transform .3s;
            }

            .card:hover .card-img img {
              transform: scale(1.08);
            }

            .card-img .placeholder {
              width: 100%;
              height: 100%;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: 4rem;
            }

            .badge-sale {
              position: absolute;
              top: .5rem;
              left: .5rem;
              background: #ef4444;
              color: #fff;
              font-size: .7rem;
              padding: .2rem .5rem;
              border-radius: 5px;
              font-weight: 700;
            }

            .badge-featured {
              position: absolute;
              top: .5rem;
              right: .5rem;
              background: #f97316;
              color: #fff;
              font-size: .7rem;
              padding: .2rem .5rem;
              border-radius: 5px;
              font-weight: 700;
            }

            .card-body {
              padding: 1rem;
              flex: 1;
              display: flex;
              flex-direction: column;
              gap: .35rem;
            }

            .card-cat {
              color: #f97316;
              font-size: .75rem;
              font-weight: 700;
              text-transform: uppercase;
              letter-spacing: .4px;
            }

            .card-name {
              font-weight: 600;
              font-size: .97rem;
              color: #f0f0f0;
              line-height: 1.3;
            }

            .card-price {
              font-size: 1.1rem;
              font-weight: 800;
              color: #f97316;
              margin-top: auto;
            }

            .card-price-old {
              font-size: .8rem;
              color: #555;
              text-decoration: line-through;
              margin-left: .4rem;
            }

            .card-rating {
              font-size: .78rem;
              color: #fbbf24;
            }

            .card-stock-out {
              font-size: .78rem;
              color: #ef4444;
            }

            .card-actions {
              display: flex;
              gap: .5rem;
              padding: .75rem 1rem;
              border-top: 1px solid #222;
            }

            .btn-detail {
              flex: 1;
              text-align: center;
              padding: .5rem;
              border-radius: 8px;
              background: #252525;
              color: #ddd;
              text-decoration: none;
              font-size: .85rem;
              transition: background .2s;
            }

            .btn-detail:hover {
              background: #333;
            }

            .btn-add-sm {
              flex: 1;
              padding: .5rem;
              border-radius: 8px;
              background: #f97316;
              color: #fff;
              border: none;
              font-size: .85rem;
              cursor: pointer;
              font-family: inherit;
              font-weight: 600;
              transition: background .2s;
            }

            .btn-add-sm:hover {
              background: #ea6a05;
            }

            .btn-add-sm:disabled {
              background: #333;
              color: #666;
              cursor: not-allowed;
            }

            /* Cart flash msg */
            .flash {
              background: #14532d;
              border: 1px solid #166534;
              color: #86efac;
              border-radius: 10px;
              padding: .75rem 1.2rem;
              margin-bottom: 1.5rem;
              display: flex;
              justify-content: space-between;
              align-items: center;
            }

            .flash-close {
              cursor: pointer;
              color: #86efac;
              background: none;
              border: none;
              font-size: 1.1rem;
            }

            /* Empty */
            .empty {
              text-align: center;
              padding: 4rem;
              color: #555;
            }

            /* Search info */
            .search-info {
              background: #1a1a1a;
              border: 1px solid #252525;
              border-radius: 10px;
              padding: .75rem 1.2rem;
              margin-bottom: 1.5rem;
              font-size: .9rem;
              color: #aaa;
            }

            .search-info strong {
              color: #f97316;
            }
          </style>
        </head>

        <body>
          <%@ include file="/views/common/header.jsp" %>

            <%-- Cart flash message --%>
              <c:if test="${not empty sessionScope.cartMsg}">
                <div class="section" style="padding-bottom:0;">
                  <div class="flash">
                    <span>🎉 ${sessionScope.cartMsg}</span>
                    <button class="flash-close" onclick="this.parentElement.remove()">✕</button>
                  </div>
                </div>
                <% session.removeAttribute("cartMsg"); %>
              </c:if>

              <%-- Hero (chỉ hiện khi không tìm kiếm và không lọc danh mục) --%>
                <c:if test="${empty keyword and (selectedCat == 0 or empty selectedCat) and not empty featured}">
                  <div class="hero">
                    <h1>🔥 <span>BếpNướng</span><br>Thịt Nướng Chuẩn Vị</h1>
                    <p>Đặt món nhanh, giao hàng tận nơi, vị ngon không cần nấu.</p>
                    <a href="#products" class="hero-btn">Xem thực đơn →</a>
                  </div>
                </c:if>

                <div class="section" id="products">

                  <%-- Search info --%>
                    <c:if test="${not empty keyword}">
                      <div class="search-info">
                        Kết quả tìm kiếm: <strong>"${keyword}"</strong> – ${fn:length(products)} món tìm thấy
                      </div>
                    </c:if>

                    <%-- Category filter --%>
                      <div class="cats">
                        <a href="${pageContext.request.contextPath}/home"
                          class="cat-btn ${selectedCat == 0 ? 'active' : ''}">🍽 Tất cả</a>
                        <c:forEach var="cat" items="${categories}">
                          <a href="${pageContext.request.contextPath}/home?category=${cat.categoryID}"
                            class="cat-btn ${selectedCat == cat.categoryID ? 'active' : ''}">
                            ${cat.categoryName}
                          </a>
                        </c:forEach>
                      </div>

                      <%-- Product grid --%>
                        <c:choose>
                          <c:when test="${empty products}">
                            <div class="empty">
                              <div style="font-size:3.5rem;margin-bottom:1rem;">🍽</div>
                              <p style="margin-bottom:1rem;">Không tìm thấy món nào.</p>
                              <a href="${pageContext.request.contextPath}/home" style="color:#f97316;">← Xem tất cả</a>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <div class="grid">
                              <c:forEach var="p" items="${products}">
                                <div class="card">
                                  <div class="card-img">
                                    <c:choose>
                                      <c:when test="${not empty p.imageURL}">
                                        <img src="${p.imageURL}" alt="${p.productName}" loading="lazy">
                                      </c:when>
                                      <c:otherwise>
                                        <div class="placeholder">🍖</div>
                                      </c:otherwise>
                                    </c:choose>
                                    <c:if test="${p.salePrice != null}"><span class="badge-sale">SALE</span></c:if>
                                    <c:if test="${p.featured}"><span class="badge-featured">⭐ Nổi bật</span></c:if>
                                  </div>
                                  <div class="card-body">
                                    <div class="card-cat">${p.categoryName}</div>
                                    <div class="card-name">${p.productName}</div>
                                    <div>
                                      <span class="card-price">
                                        <fmt:formatNumber value="${p.displayPrice}" pattern="#,###" />đ
                                      </span>
                                      <c:if test="${p.salePrice != null}">
                                        <span class="card-price-old">
                                          <fmt:formatNumber value="${p.price}" pattern="#,###" />đ
                                        </span>
                                      </c:if>
                                    </div>
                                    <c:choose>
                                      <c:when test="${p.reviewCount > 0}">
                                        <div class="card-rating">⭐
                                          <fmt:formatNumber value="${p.avgRating}" maxFractionDigits="1" />
                                          (${p.reviewCount})
                                        </div>
                                      </c:when>
                                      <c:when test="${!p.inStock}">
                                        <div class="card-stock-out">❌ Hết hàng</div>
                                      </c:when>
                                    </c:choose>
                                  </div>
                                  <div class="card-actions">
                                    <a href="${pageContext.request.contextPath}/product?id=${p.productID}"
                                      class="btn-detail">Chi tiết</a>
                                    <form action="${pageContext.request.contextPath}/cart" method="post"
                                      style="flex:1;">
                                      <input type="hidden" name="action" value="add">
                                      <input type="hidden" name="productID" value="${p.productID}">
                                      <input type="hidden" name="quantity" value="1">
                                      <button type="submit" class="btn-add-sm" <c:if test="${!p.inStock}">disabled
                                        </c:if>>
                                        🛒 Thêm
                                      </button>
                                    </form>
                                  </div>
                                </div>
                              </c:forEach>
                            </div>
                          </c:otherwise>
                        </c:choose>
                </div>
        </body>

        </html>