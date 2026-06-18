<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Đơn hàng của tôi – GrillHouse</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/order-history.css">
      </head>

      <body>
        <%@ include file="/views/common/header.jsp" %>

          <div class="container">
            <h1>📋 Đơn hàng của tôi</h1>

            <c:if test="${not empty successMsg}">
              <div class="success">🎉 ${successMsg}</div>
            </c:if>

            <c:choose>
              <c:when test="${empty orders}">
                <div class="empty">
                  <div style="font-size:3.5rem;margin-bottom:1rem;">📭</div>
                  <p style="margin-bottom:1rem;">Bạn chưa có đơn hàng nào.</p>
                  <a href="${pageContext.request.contextPath}/home" style="color:#f97316;">→ Đặt món ngay</a>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="o" items="${orders}">
                  <div class="order-card">
                    <div class="order-head">
                      <div>
                        <div class="order-id">#${o.orderID}</div>
                        <div class="order-date">
                          <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                      </div>
                      <span class="status s${o.status}">${o.statusLabel}</span>
                    </div>
                    <div class="order-body">
                      <div class="order-row"><span>Địa chỉ giao</span><span>${o.shipAddress}</span></div>
                      <div class="order-row"><span>SĐT</span><span>${o.phone}</span></div>
                      <c:if test="${not empty o.note}">
                        <div class="order-row"><span>Ghi chú</span><span>${o.note}</span></div>
                      </c:if>
                    </div>
                    <div class="order-total">
                      <span class="total-label">
                        Tổng thanh toán
                        <span class="pay-badge">${o.paymentMethod}</span>
                        <c:if test="${o.paid}"><span class="pay-badge" style="background:#14532d;color:#86efac;">Đã
                            thanh toán</span></c:if>
                      </span>
                      <span class="total-price">
                        <fmt:formatNumber value="${o.finalAmount}" pattern="#,###" />đ
                      </span>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
      </body>

      </html>