<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8">
          <title>${product.productName} – GrillHouse</title>
          <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/product-detail.css">
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

                <!-- Tổng quan điểm -->
                <c:if test="${not empty reviews}">
                  <div class="review-overview">
                    <div class="overview-score">
                      <div class="score-big">
                        <fmt:formatNumber value="${product.avgRating}" maxFractionDigits="1" />
                      </div>
                      <div class="score-stars">
                        <c:forEach begin="1" end="5" var="i">
                          <span class="${i <= product.avgRating ? 'star-filled' : 'star-empty'}">★</span>
                        </c:forEach>
                      </div>
                      <div class="score-count">Dựa trên ${product.reviewCount} đánh giá</div>
                    </div>
                    <div class="overview-bars">
                      <c:forEach begin="1" end="5" var="star" varStatus="loop">
                        <c:set var="starVal" value="${6 - star}" />
                        <div class="bar-row">
                          <span class="bar-star">${starVal} ★</span>
                          <div class="bar-track">
                            <div class="bar-fill" style="width: ${product.reviewCount > 0 ? (starVal * 15) : 0}%;">
                            </div>
                          </div>
                        </div>
                      </c:forEach>
                    </div>
                  </div>
                </c:if>

                <!-- Form đánh giá -->
                <c:if test="${canReview == true}">
                  <div class="review-form">
                    <h3>
                      <c:choose>
                        <c:when test="${hasReviewed}">✏️ Sửa đánh giá của bạn</c:when>
                        <c:otherwise>✍️ Viết đánh giá của bạn</c:otherwise>
                      </c:choose>
                    </h3>
                    <form action="${pageContext.request.contextPath}/review" method="post">
                      <input type="hidden" name="productID" value="${product.productID}">
                      <div class="star-row">
                        <input type="radio" id="s5" name="rating" value="5" <c:if test="${myReview.rating == 5}">checked
                </c:if>><label for="s5" title="5 sao">★</label>
                <input type="radio" id="s4" name="rating" value="4" <c:if test="${myReview.rating == 4}">checked</c:if>
                ><label for="s4" title="4 sao">★</label>
                <input type="radio" id="s3" name="rating" value="3" <c:if
                  test="${empty myReview or myReview.rating == 3}">checked</c:if>><label for="s3"
                  title="3 sao">★</label>
                <input type="radio" id="s2" name="rating" value="2" <c:if test="${myReview.rating == 2}">checked</c:if>
                ><label for="s2" title="2 sao">★</label>
                <input type="radio" id="s1" name="rating" value="1" <c:if test="${myReview.rating == 1}">checked</c:if>
                ><label for="s1" title="1 sao">★</label>
              </div>
              <textarea name="comment"
                placeholder="Chia sẻ cảm nhận của bạn về sản phẩm...">${myReview.comment}</textarea>
              <button type="submit" class="btn-review">
                <c:choose>
                  <c:when test="${hasReviewed}">💾 Cập nhật đánh giá</c:when>
                  <c:otherwise>Gửi đánh giá</c:otherwise>
                </c:choose>
              </button>
              </form>
            </div>
            </c:if>

            <!-- Danh sách đánh giá -->
            <c:choose>
              <c:when test="${empty reviews}">
                <div class="no-reviews">Chưa có đánh giá nào. Hãy là người đầu tiên!</div>
              </c:when>
              <c:otherwise>
                <c:set var="showLimit" value="3" />
                <div class="review-list" id="reviewList">
                  <c:forEach var="rv" items="${reviews}" varStatus="loop">
                    <div class="review-item ${loop.index >= showLimit ? 'review-hidden' : ''}">
                      <div class="review-header">
                        <div style="display:flex;align-items:center;gap:.75rem;">
                          <div class="reviewer-avatar">${fn:substring(rv.reviewerName,0,1)}</div>
                          <div>
                            <div class="reviewer-name">${rv.reviewerName}</div>
                            <div class="review-stars">
                              <c:forEach begin="1" end="${rv.rating}" var="i">★</c:forEach>
                              <c:forEach begin="${rv.rating + 1}" end="5" var="i">☆</c:forEach>
                            </div>
                          </div>
                        </div>
                        <span class="review-date">
                          <fmt:formatDate value="${rv.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                        </span>
                      </div>
                      <c:if test="${not empty rv.comment}">
                        <div class="review-comment">${rv.comment}</div>
                      </c:if>
                    </div>
                  </c:forEach>
                </div>
                <c:if test="${fn:length(reviews) > 3}">
                  <div style="text-align:center;margin-top:1.25rem;">
                    <button onclick="toggleReviews(this)" class="btn-show-more">Xem thêm đánh giá</button>
                  </div>
                </c:if>
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
              function toggleReviews(btn) {
                const hidden = document.querySelectorAll('.review-hidden');
                if (hidden.length > 0) {
                  hidden.forEach(el => el.classList.remove('review-hidden'));
                  btn.textContent = 'Thu gọn';
                } else {
                  const items = document.querySelectorAll('.review-item');
                  items.forEach((el, i) => { if (i >= 3) el.classList.add('review-hidden'); });
                  btn.textContent = 'Xem thêm đánh giá';
                }
              }
            </script>
        </body>

        </html>