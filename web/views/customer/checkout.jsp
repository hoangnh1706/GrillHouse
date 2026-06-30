<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Thanh toán - GrillHouse</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/checkout.css">
      </head>

      <body>
        <%@ include file="/views/common/header.jsp" %>

          <div style="max-width:960px;margin:2rem auto;padding:0 1.5rem;">
            <h1 style="font-family:'Playfair Display',serif;color:#f97316;font-size:1.8rem;margin-bottom:1.5rem;">
              Thanh toán
            </h1>
            <c:if test="${not empty error}">
              <div class="error">&#9888; ${error}</div>
            </c:if>
          </div>

          <div class="container" style="margin-top:0;">

            <!-- Form thong tin giao hang -->
            <form id="orderForm" action="${pageContext.request.contextPath}/checkout" method="post">
              <div class="card">
                <h2>Thông tin giao hafng</h2>

                <label>Họ và tên người nhận</label>
                <input type="text" name="receiverName" value="${sessionScope.account.fullName}" required>

                <label>Số điện thoại *</label>
                <input type="tel" name="phone" value="${sessionScope.account.phone}" placeholder="0901234567" required>

                <label>Địa chỉ giao hàng *</label>
                <input type="text" name="shipAddress" value="${sessionScope.account.address}"
                  placeholder="Số nhà, đường, phường, quận..." required>

                <label>Ghi chu (tuy chon)</label>
                <textarea name="note" placeholder="Ví dụ: Goi truoc 10 phut, khong cay..."></textarea>

                <h2 style="margin-top:.5rem;">Phương thức thanh toán</h2>
                <div class="pay-opts">
                  <label class="pay-opt selected">
                    <input type="radio" name="paymentMethod" value="Tien mat" checked>
                    <span>Thanh toán khi nhận hàng (COD)</span>
                  </label>
                  <label class="pay-opt">
                    <input type="radio" name="paymentMethod" value="VNPay">
                    <span>Chuyển khoản VNPay</span>
                  </label>
                </div>

                <button type="button" class="btn-submit" onclick="submitOrder()">Xác nhận đặt hàng</button>
              </div>
            </form>

            <!-- Tom tat don hang -->
            <div>
              <div class="card">
                <h2>Đơn hàng của bạn</h2>
                <c:forEach var="item" items="${sessionScope.cart.items}">
                  <div class="order-item">
                    <div>
                      <div class="item-name">${item.productName}</div>
                      <div class="item-qty">x${item.quantity}</div>
                    </div>
                    <div class="item-price">
                      <fmt:formatNumber value="${item.subtotal}" pattern="#,###" />d
                    </div>
                  </div>
                </c:forEach>

                <div style="margin-top:.75rem;">
                  <div class="summary-line">
                    <span>Tạm tính</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.total}" pattern="#,###" />d
                    </span>
                  </div>
                  <c:if test="${sessionScope.cart.discount > 0}">
                    <div class="summary-line" style="color:#86efac;">
                      <span>Giảm giá 10% <span class="discount-badge">-10%</span></span>
                      <span>-
                        <fmt:formatNumber value="${sessionScope.cart.discount}" pattern="#,###" />d
                      </span>
                    </div>
                  </c:if>
                  <div class="summary-line">
                    <span>Phí giao hàng</span>
                    <span style="color:#86efac;">Free</span>
                  </div>
                  <div class="summary-total">
                    <span>Tổng cộng</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.finalTotal}" pattern="#,###" />d
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <script>
            // Highlight payment option khi chon
            var opts = document.querySelectorAll('.pay-opt');
            for (var i = 0; i < opts.length; i++) {
              opts[i].addEventListener('click', function () {
                for (var j = 0; j < opts.length; j++) {
                  opts[j].classList.remove('selected');
                }
                this.classList.add('selected');
              });
            }
          </script>

          <script>
            function submitOrder() {
              var form = document.getElementById("orderForm");
              if (!form.reportValidity()) return;
              // Luôn POST về /checkout — CheckoutServlet tự redirect VNPay nếu cần
              form.action = "${pageContext.request.contextPath}/checkout";
              form.method = "post";
              form.submit();
            }
          </script>
      </body>

      </html>