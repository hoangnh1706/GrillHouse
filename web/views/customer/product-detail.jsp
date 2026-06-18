<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>${product.productName} – GrillHouse</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-detail.css">
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

                  <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                      <button type="submit" class="btn-add" <c:if test="${!product.inStock}">disabled</c:if>>
                        🛒 Thêm vào giỏ hàng
                      </button>
                    </c:when>
                    <c:otherwise>
                      <a href="${pageContext.request.contextPath}/login?redirect=product%3Fid%3D${product.productID}"
                        class="btn-add" style="display:block;text-align:center;text-decoration:none;">
                        🔑 Đăng nhập để thêm vào giỏ hàng
                      </a>
                    </c:otherwise>
                  </c:choose>
                </form>

                <a href="javascript:history.back()" class="back">← Quay lại</a>
              </div>
            </div>

            <!-- REVIEW SECTION -->
            <div class="review-section">
              <h2>⭐ Đánh giá sản phẩm</h2>

              <!-- Thông báo -->
              <c:if test="${param.reviewSuccess == '1'}">
                <div class="alert-success">✅ Cảm ơn bạn đã đánh giá!</div>
              </c:if>
              <c:if test="${param.reviewError == 'alreadyReviewed'}">
                <div class="alert-error">⚠️ Bạn đã đánh giá sản phẩm này rồi.</div>
              </c:if>
              <c:if test="${param.reviewError == 'notPurchased'}">
                <div class="alert-error">⚠️ Bạn cần mua và nhận hàng thành công mới được đánh giá.</div>
              </c:if>

              <!-- Form đánh giá (chỉ hiện nếu canReview = true) -->
              <c:if test="${canReview == true}">
                <div class="review-form">
                  <h3>✍️ Viết đánh giá của bạn</h3>
                  <form action="${pageContext.request.contextPath}/review" method="post">
                    <input type="hidden" name="productID" value="${product.productID}">
                    <div class="star-row">
                      <input type="radio" id="s5" name="rating" value="5"><label for="s5" title="5 sao">★</label>
                      <input type="radio" id="s4" name="rating" value="4"><label for="s4" title="4 sao">★</label>
                      <input type="radio" id="s3" name="rating" value="3" checked><label for="s3"
                        title="3 sao">★</label>
                      <input type="radio" id="s2" name="rating" value="2"><label for="s2" title="2 sao">★</label>
                      <input type="radio" id="s1" name="rating" value="1"><label for="s1" title="1 sao">★</label>
                    </div>
                    <textarea name="comment" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                    <button type="submit" class="btn-review">Gửi đánh giá</button>
                  </form>
                </div>
              </c:if>

              <!-- Danh sách đánh giá -->
              <c:choose>
                <c:when test="${empty reviews}">
                  <div class="no-reviews">Chưa có đánh giá nào. Hãy là người đầu tiên!</div>
                </c:when>
                <c:otherwise>
                  <div class="review-list">
                    <c:forEach var="rv" items="${reviews}">
                      <div class="review-item">
                        <div class="review-header">
                          <span class="reviewer-name">👤 ${rv.reviewerName}</span>
                          <span class="review-date">
                            <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                          </span>
                        </div>
                        <div class="review-stars">
                          <c:forEach begin="1" end="${rv.rating}" var="i">★</c:forEach>
                          <c:forEach begin="${rv.rating + 1}" end="5" var="i">☆</c:forEach>
                        </div>
                        <c:if test="${not empty rv.comment}">
                          <div class="review-comment">${rv.comment}</div>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div>
                </c:otherwise>
              </c:choose>
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