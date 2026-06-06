<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Dashboard – Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            background: #0f0f0f;
            color: #e5e5e5;
            font-family: 'DM Sans', sans-serif;
            display: flex;
          }

          .sidebar {
            width: 220px;
            min-height: 100vh;
            background: #161616;
            border-right: 1px solid #222;
            padding: 1.5rem 1rem;
            position: fixed;
          }

          .sidebar .logo {
            color: #f97316;
            font-size: 1.1rem;
            font-weight: 800;
            margin-bottom: 2rem;
            padding-left: .5rem;
          }

          .sidebar a {
            display: flex;
            align-items: center;
            gap: .6rem;
            color: #888;
            text-decoration: none;
            padding: .6rem .75rem;
            border-radius: 8px;
            font-size: .9rem;
            margin-bottom: .2rem;
            transition: all .2s;
          }

          .sidebar a:hover,
          .sidebar a.active {
            background: #f97316;
            color: #fff;
          }

          .main {
            margin-left: 220px;
            flex: 1;
            padding: 2rem;
          }

          .welcome {
            margin-bottom: 2rem;
          }

          .welcome h1 {
            font-size: 1.6rem;
            font-weight: 700;
            color: #f0f0f0;
          }

          .welcome p {
            color: #666;
            margin-top: .3rem;
          }

          .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.2rem;
            margin-bottom: 2rem;
          }

          .stat-card {
            background: #1a1a1a;
            border: 1px solid #252525;
            border-radius: 14px;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: .5rem;
          }

          .stat-icon {
            font-size: 2rem;
          }

          .stat-label {
            color: #777;
            font-size: .85rem;
          }

          .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: #f97316;
          }

          .stat-note {
            font-size: .78rem;
            color: #555;
          }

          h2 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #f0f0f0;
            margin-bottom: 1rem;
          }

          table {
            width: 100%;
            border-collapse: collapse;
            background: #1a1a1a;
            border-radius: 12px;
            overflow: hidden;
          }

          th {
            background: #222;
            color: #888;
            font-size: .78rem;
            text-transform: uppercase;
            letter-spacing: .5px;
            padding: .65rem 1rem;
            text-align: left;
          }

          td {
            padding: .75rem 1rem;
            border-bottom: 1px solid #1f1f1f;
            font-size: .88rem;
          }

          tr:last-child td {
            border: none;
          }

          .price {
            color: #f97316;
            font-weight: 700;
          }

          .status {
            padding: .22rem .6rem;
            border-radius: 12px;
            font-size: .74rem;
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

          .status-labels {
            display: none;
          }
        </style>
      </head>

      <body>
        <div class="sidebar">
          <div class="logo">⚙️ Admin Panel</div>
          <a href="${pageContext.request.contextPath}/admin/home" class="active">📊 Dashboard</a>
          <a href="${pageContext.request.contextPath}/admin/products">🍖 Món ăn</a>
          <a href="${pageContext.request.contextPath}/admin/orders">📦 Đơn hàng</a>
          <a href="${pageContext.request.contextPath}/home" style="margin-top:2rem;">← Về trang chủ</a>
        </div>

        <div class="main">
          <div class="welcome">
            <h1>👋 Xin chào, ${sessionScope.account.fullName}!</h1>
            <p>Đây là tổng quan hoạt động cửa hàng hôm nay.</p>
          </div>

          <div class="stats">
            <div class="stat-card">
              <div class="stat-icon">🍖</div>
              <div class="stat-label">Tổng món ăn</div>
              <div class="stat-value">${totalProducts}</div>
              <div class="stat-note">trong thực đơn</div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">⏳</div>
              <div class="stat-label">Chờ xác nhận</div>
              <div class="stat-value" style="color:#fbbf24;">${pendingOrders}</div>
              <div class="stat-note"><a href="${pageContext.request.contextPath}/admin/orders?status=0"
                  style="color:#f97316;">Xem ngay →</a></div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">📦</div>
              <div class="stat-label">Tổng đơn hàng</div>
              <div class="stat-value">${recentOrders.size()}</div>
              <div class="stat-note">gần đây</div>
            </div>
            <div class="stat-card">
              <div class="stat-icon">💰</div>
              <div class="stat-label">Doanh thu</div>
              <div class="stat-value" style="color:#4ade80;font-size:1.4rem;">
                <fmt:formatNumber value="${totalRevenue}" pattern="#,###" />đ
              </div>
              <div class="stat-note">từ đơn hoàn thành</div>
            </div>
          </div>

          <!-- Đơn hàng mới nhất -->
          <h2>📋 Đơn hàng gần nhất</h2>
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>Khách hàng</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="o" items="${recentOrders}">
                <tr>
                  <td style="color:#555;">#${o.orderID}</td>
                  <td style="font-weight:600;">${o.customerName}</td>
                  <td style="color:#777;">
                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM HH:mm" />
                  </td>
                  <td class="price">
                    <fmt:formatNumber value="${o.finalAmount}" pattern="#,###" />đ
                  </td>
                  <td><span class="status s${o.status}">${o.statusLabel}</span></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </body>

      </html>