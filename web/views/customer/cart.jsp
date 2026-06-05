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

          h1 {
            font-family: 'Playfair Display', serif;
            color: #f97316;
            font-size: 2rem;
            margin-bottom: 1.5rem;
          }

          .empty {
            text-align: center;
            padding: 4rem;
            color: #555;
          }

          .empty a {
            color: #f97316;
          }

          table {
            width: 100%;
            border-collapse: collapse;
          }

          th {
            text-align: left;
            color: #777;
            font-size: .82rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .5px;
            padding: .6rem 1rem;
            border-bottom: 1px solid #2a2a2a;
          }

          td {
            padding: .9rem 1rem;
            border-bottom: 1px solid #1f1f1f;
            vertical-align: middle;
          }

          .prod-img {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 8px;
            background: #2a2a2a;
          }

          .prod-name {
            font-weight: 600;
            color: #eee;
          }

          .prod-cat {
            font-size: .78rem;
            color: #777;
            margin-top: .2rem;
          }

          .qty-form {
            display: flex;
            align-items: center;
            gap: .4rem;
          }

          .qty-btn {
            width: 28px;
            height: 28px;
            background: #252525;
            border: 1px solid #333;
            color: #eee;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
          }

          .qty-input {
            width: 44px;
            text-align: center;
            background: #1c1c1c;
            border: 1px solid #333;
            color: #eee;
            border-radius: 6px;
            padding: .3rem;
            font-family: inherit;
            font-size: .9rem;
          }

          .btn-remove {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            font-size: 1.1rem;
          }

          .price {
            color: #f97316;
            font-weight: 700;
            font-size: 1rem;
          }

          /* Summary */
          .summary {
            background: #1c1c1c;
            border: 1px solid #2a2a2a;
            border-radius: 14px;
            padding: 1.5rem;
            margin-top: 1.5rem;
          }

          .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: .75rem;
            color: #aaa;
          }

          .summary-row.discount {
            color: #86efac;
          }

          .summary-total {
            display: flex;
            justify-content: space-between;
            font-size: 1.3rem;
            font-weight: 700;
            color: #f97316;
            border-top: 1px solid #2a2a2a;
            padding-top: .75rem;
            margin-top: .25rem;
          }

          .discount-note {
            background: #14532d;
            color: #86efac;
            border-radius: 8px;
            padding: .5rem .9rem;
            font-size: .82rem;
            margin: -.25rem 0 .75rem;
          }

          .btn-checkout {
            display: block;
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
            text-align: center;
            text-decoration: none;
            margin-top: 1rem;
            transition: background .2s;
          }

          .btn-checkout:hover {
            background: #ea6a05;
          }

          .btn-continue {
            display: block;
            text-align: center;
            color: #777;
            font-size: .88rem;
            margin-top: .75rem;
          }

          .btn-continue a {
            color: #f97316;
          }
        </style>
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