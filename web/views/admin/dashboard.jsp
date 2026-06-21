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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-dashboard.css">
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

          <!-- Breakdown trạng thái -->
          <div class="section">
            <h2>🧾 Tình trạng đơn hàng</h2>
            <div class="status-grid">
              <a class="status-item" href="${pageContext.request.contextPath}/admin/orders?status=0">
                <div class="status-item-left">
                  <span class="status-dot s0"></span>
                  <div>⏳ Chờ xác nhận</div>
                </div>
                <div class="status-item-right">${statusCounts[0]}</div>
              </a>
              <a class="status-item" href="${pageContext.request.contextPath}/admin/orders?status=1">
                <div class="status-item-left">
                  <span class="status-dot s1"></span>
                  <div>✅ Đã xác nhận</div>
                </div>
                <div class="status-item-right">${statusCounts[1]}</div>
              </a>
              <a class="status-item" href="${pageContext.request.contextPath}/admin/orders?status=2">
                <div class="status-item-left">
                  <span class="status-dot s2"></span>
                  <div>🚚 Đang giao</div>
                </div>
                <div class="status-item-right">${statusCounts[2]}</div>
              </a>
              <a class="status-item" href="${pageContext.request.contextPath}/admin/orders?status=3">
                <div class="status-item-left">
                  <span class="status-dot s3"></span>
                  <div>🎉 Hoàn thành</div>
                </div>
                <div class="status-item-right">${statusCounts[3]}</div>
              </a>
              <a class="status-item" href="${pageContext.request.contextPath}/admin/orders?status=4">
                <div class="status-item-left">
                  <span class="status-dot s4"></span>
                  <div>❌ Đã hủy</div>
                </div>
                <div class="status-item-right">${statusCounts[4]}</div>
              </a>
            </div>
          </div>

          <div class="two-cols">
            <div class="section">
              <h2>📈 Doanh thu 7 ngày</h2>
              <div class="mini-table-wrap">
                <table class="mini-table">
                  <thead>
                    <tr>
                      <th>Ngày</th>
                      <th>Doanh thu</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="r" items="${revenueLast7Days}">
                      <tr>
                        <td><fmt:formatDate value="${r[0]}" pattern="dd/MM" /></td>
                        <td class="price"><fmt:formatNumber value="${r[1]}" pattern="#,#00" />đ</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>

              </div>
            </div>

            <div class="section">
              <h2>🔥 Top món bán chạy</h2>
              <div class="top-list">
                <c:forEach var="p" items="${topProducts}">
                  <div class="top-item">
                    <div class="top-item-name">${p[1]}</div>
                    <div class="top-item-meta">
                      <span class="top-pill">${p[2]} SL</span>
                      <span class="top-pill green"><fmt:formatNumber value="${p[3]}" pattern="#,#00" />đ</span>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>
          </div>

          <!-- Doanh thu theo tháng & xu hướng -->
          <div class="section">
            <h2>📅 Doanh thu theo tháng (12 tháng) + xu hướng</h2>
            <div class="trend-table">
              <table class="mini-table">
                <thead>
                  <tr>
                    <th>Tháng</th>
                    <th>Doanh thu</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="m" items="${revenueTrend12Months}">
                    <tr>
                      <td>${m[0]}/${m[1]}</td>
                      <td class="price"><fmt:formatNumber value="${m[2]}" pattern="#,#00" />đ</td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Đơn hàng mới nhất -->
          <h2>📋 Đơn hàng gần nhất</h2>
          <table class="orders-table">
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
