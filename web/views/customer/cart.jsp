<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng – GrillHouse</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/cart.css">
      </head>

      <body>
        <%@ include file="/views/common/header.jsp" %>

          <div class="container">
            <h1>🛒 Giỏ hàng</h1>

            <c:choose>
              <c:when test="${empty sessionScope.cart or sessionScope.cart.totalItems == 0}">
                <div class="empty">
                  <div style="font-size:4rem;margin-bottom:1rem;">🍽️</div>
                  <p style="font-size:1.1rem;margin-bottom:1rem;">Giỏ hàng của bạn đang trống</p>
                  <a href="${pageContext.request.contextPath}/home" style="color:#f97316;">← Quay lại thực đơn</a>
                </div>
              </c:when>
              <c:otherwise>
                <table>
                  <thead>
                    <tr>
                      <th>Món ăn</th>
                      <th>Đơn giá</th>
                      <th>Số lượng</th>
                      <th>Thành tiền</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="item" items="${sessionScope.cart.items}">
                      <tr>
                        <td>
                          <div style="display:flex;align-items:center;gap:.9rem;">
                            <c:choose>
                              <c:when test="${not empty item.imageURL}">
                                <img class="prod-img" src="${item.imageURL}" alt="${item.productName}">
                              </c:when>
                              <c:otherwise>
                                <div class="prod-img"
                                  style="display:flex;align-items:center;justify-content:center;font-size:1.5rem;">🍖
                                </div>
                              </c:otherwise>
                            </c:choose>
                            <div>
                              <div class="prod-name">${item.productName}</div>
                            </div>
                          </div>
                        </td>
                        <td class="price">
                          <fmt:formatNumber value="${item.unitPrice}" pattern="#,###" />đ
                        </td>
                        <td>
                          <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-form">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="productID" value="${item.productID}">
                            <button type="submit" class="qty-btn"
                              onclick="this.previousElementSibling.previousElementSibling.value=Math.max(1,parseInt(this.form.quantity.value)-1)"
                              name="_">−</button>
                            <input type="number" name="quantity" value="${item.quantity}" min="1" max="99"
                              class="qty-input" onchange="this.form.submit()">
                            <button type="submit" class="qty-btn"
                              onclick="this.previousElementSibling.value=parseInt(this.previousElementSibling.value)+1"
                              name="_">+</button>
                          </form>
                        </td>
                        <td class="price">
                          <fmt:formatNumber value="${item.subtotal}" pattern="#,###" />đ
                        </td>
                        <td>
                          <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productID" value="${item.productID}">
                            <button type="submit" class="btn-remove" title="Xóa">🗑️</button>
                          </form>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>

                <!-- Summary -->
                <div class="summary">
                  <c:if test="${sessionScope.cart.totalDouble >= 500000}">
                    <div class="discount-note">🎉 Đơn hàng trên 500.000đ được giảm 10%!</div>
                  </c:if>
                  <div class="summary-row">
                    <span>Tạm tính</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.total}" pattern="#,###" />đ
                    </span>
                  </div>
                  <c:if test="${sessionScope.cart.totalDouble >= 500000}">
                    <div class="summary-row discount">
                      <span>Giảm giá (10%)</span>
                      <span>−
                        <fmt:formatNumber value="${sessionScope.cart.discount}" pattern="#,###" />đ
                      </span>
                    </div>
                  </c:if>
                  <div class="summary-total">
                    <span>Tổng thanh toán</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.finalTotal}" pattern="#,###" />đ
                    </span>
                  </div>

                  <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">
                    Tiến hành thanh toán →
                  </a>
                  <div class="btn-continue">hoặc <a href="${pageContext.request.contextPath}/home">tiếp tục mua sắm</a>
                  </div>
                </div>

              </c:otherwise>
            </c:choose>
          </div>
      </body>

      </html>