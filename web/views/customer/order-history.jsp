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

            <%-- Filter tabs theo trạng thái --%>
              <div class="filter-bar">
                <a href="${pageContext.request.contextPath}/my-orders"
                  class="filter-btn ${empty param.status ? 'active' : ''}">🗂 Tất cả</a>
                <a href="${pageContext.request.contextPath}/my-orders?status=0"
                  class="filter-btn ${param.status == '0' ? 'active' : ''}">⏳ Chờ xác nhận</a>
                <a href="${pageContext.request.contextPath}/my-orders?status=1"
                  class="filter-btn ${param.status == '1' ? 'active' : ''}">✅ Đã xác nhận</a>
                <a href="${pageContext.request.contextPath}/my-orders?status=2"
                  class="filter-btn ${param.status == '2' ? 'active' : ''}">🚚 Đang giao</a>
                <a href="${pageContext.request.contextPath}/my-orders?status=3"
                  class="filter-btn ${param.status == '3' ? 'active' : ''}">🎉 Hoàn thành</a>
                <a href="${pageContext.request.contextPath}/my-orders?status=4"
                  class="filter-btn ${param.status == '4' ? 'active' : ''}">❌ Đã hủy</a>
              </div>

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
                          <c:if test="${o.paid}">
                            <span class="pay-badge" style="background:#14532d;color:#86efac;">✔ Đã thanh toán</span>
                          </c:if>
                        </span>
                        <div style="display:flex;align-items:center;gap:.75rem;">
                          <c:if test="${o.status == 3 or o.status == 4}">
                            <a href="${pageContext.request.contextPath}/home"
                              style="background:#f97316;color:#fff;text-decoration:none;padding:.4rem .9rem;border-radius:8px;font-size:.82rem;font-weight:700;white-space:nowrap;">
                              🔄 Đặt lại ngay
                            </a>
                          </c:if>

                          <c:if test="${o.status == 3}">
                            <c:forEach var="detail" items="${o.details}" begin="0" end="0">
                              <a href="${pageContext.request.contextPath}/product?id=${detail.productID}"
                                style="background:#1c1c1c;border:1.5px solid #f97316;color:#f97316;text-decoration:none;padding:.4rem .9rem;border-radius:8px;font-size:.82rem;font-weight:700;white-space:nowrap;transition:all .2s;"
                                onmouseover="this.style.background='#f97316';this.style.color='#fff'"
                                onmouseout="this.style.background='#1c1c1c';this.style.color='#f97316'">
                                ✍️ Feedback now
                              </a>
                            </c:forEach>
                          </c:if>
                          <span class="total-price">
                            <fmt:formatNumber value="${o.finalAmount}" pattern="#,###" />đ
                          </span>

                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
          </div>
      </body>

      </html>