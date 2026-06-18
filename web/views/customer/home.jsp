<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>GrillHouse – Đặt món ngon tận nơi</title>
          <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/home.css">
        </head>
        
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
                    <h1>🔥 <span>GrillHouse</span><br>Thịt Nướng Chuẩn Vị</h1>
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
                                    <c:choose>
                                      <c:when test="${not empty sessionScope.account}">
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
                                      </c:when>
                                      <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login?redirect=home"
                                          class="btn-add-sm"
                                          style="text-align:center;text-decoration:none;display:flex;align-items:center;justify-content:center;">
                                          🔑 Đăng nhập
                                        </a>
                                      </c:otherwise>
                                    </c:choose>
                                  </div>
                                </div>
                              </c:forEach>
                            </div>
                          </c:otherwise>
                        </c:choose>
                </div>
        </body>

        </html>