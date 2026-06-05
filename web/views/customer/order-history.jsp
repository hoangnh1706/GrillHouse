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
            max-width: 860px;
            margin: 2rem auto;
            padding: 0 1.5rem;
          }

          h1 {
            font-family: 'Playfair Display', serif;
            color: #f97316;
            font-size: 2rem;
            margin-bottom: 1.5rem;
          }

          .success {
            background: #14532d;
            border: 1px solid #166534;
            color: #86efac;
            border-radius: 10px;
            padding: .9rem 1.2rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
          }

          .empty {
            text-align: center;
            padding: 4rem;
            color: #555;
          }

          .order-card {
            background: #1c1c1c;
            border: 1px solid #2a2a2a;
            border-radius: 14px;
            margin-bottom: 1.2rem;
            overflow: hidden;
          }

          .order-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.25rem;
            border-bottom: 1px solid #252525;
            flex-wrap: wrap;
            gap: .5rem;
          }

          .order-id {
            font-weight: 700;
            color: #f97316;
            font-size: 1rem;
          }

          .order-date {
            color: #666;
            font-size: .85rem;
          }

          .status {
            padding: .3rem .8rem;
            border-radius: 20px;
            font-size: .78rem;
            font-weight: 700;
          }

          .s0 {
            background: #292300;
            color: #fbbf24;
          }

          .s1 {
            background: #1a2e1a;
            color: #4ade80;
          }

          .s2 {
            background: #1a2040;
            color: #60a5fa;
          }

          .s3 {
            background: #14532d;
            color: #86efac;
          }

          .s4 {
            background: #3b1a1a;
            color: #f87171;
          }

          .order-body {
            padding: 1rem 1.25rem;
          }

          .order-row {
            display: flex;
            justify-content: space-between;
            padding: .35rem 0;
            font-size: .9rem;
            color: #aaa;
          }

          .order-row span:last-child {
            color: #eee;
            font-weight: 500;
          }

          .order-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #252525;
            padding: .9rem 1.25rem;
          }

          .total-label {
            color: #aaa;
            font-size: .9rem;
          }

          .total-price {
            color: #f97316;
            font-size: 1.2rem;
            font-weight: 700;
          }

          .pay-badge {
            font-size: .78rem;
            padding: .2rem .6rem;
            border-radius: 12px;
            background: #2a2a2a;
            color: #aaa;
            margin-left: .5rem;
          }
        </style>
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