<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý đơn hàng – Admin</title>
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

                    /* Sidebar */
                    .sidebar {
                        width: 220px;
                        min-height: 100vh;
                        background: #161616;
                        border-right: 1px solid #222;
                        padding: 1.5rem 1rem;
                        position: fixed;
                        top: 0;
                        left: 0;
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

                    /* Filter tabs */
                    .filter-bar {
                        display: flex;
                        gap: .5rem;
                        flex-wrap: wrap;
                        margin-bottom: 1.5rem;
                    }

                    .filter-btn {
                        padding: .4rem 1rem;
                        border-radius: 20px;
                        text-decoration: none;
                        font-size: .85rem;
                        font-weight: 600;
                        border: 1.5px solid #333;
                        color: #aaa;
                        transition: all .2s;
                        white-space: nowrap;
                    }

                    .filter-btn:hover {
                        border-color: #f97316;
                        color: #f97316;
                    }

                    .filter-btn.active {
                        background: #f97316;
                        border-color: #f97316;
                        color: #fff;
                    }

                    /* Error */
                    .error-msg {
                        background: #3b1a1a;
                        border: 1px solid #7f1d1d;
                        color: #fca5a5;
                        border-radius: 8px;
                        padding: .75rem 1rem;
                        margin-bottom: 1.2rem;
                    }

                    /* Table */
                    .table-wrap {
                        background: #1a1a1a;
                        border-radius: 14px;
                        overflow: hidden;
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    th {
                        background: #222;
                        color: #777;
                        font-size: .75rem;
                        text-transform: uppercase;
                        letter-spacing: .5px;
                        padding: .7rem 1rem;
                        text-align: left;
                        white-space: nowrap;
                    }

                    td {
                        padding: .8rem 1rem;
                        border-bottom: 1px solid #1f1f1f;
                        font-size: .88rem;
                        vertical-align: middle;
                    }

                    tr:last-child td {
                        border: none;
                    }

                    tr:hover td {
                        background: #1e1e1e;
                    }

                    .order-id {
                        color: #f97316;
                        font-weight: 700;
                    }

                    .customer {
                        font-weight: 600;
                        color: #f0f0f0;
                    }

                    .price {
                        color: #f97316;
                        font-weight: 700;
                    }

                    .date-col {
                        color: #666;
                        font-size: .82rem;
                    }

                    .method-badge {
                        background: #252525;
                        color: #aaa;
                        font-size: .75rem;
                        padding: .18rem .5rem;
                        border-radius: 10px;
                    }

                    .empty {
                        text-align: center;
                        padding: 4rem;
                        color: #555;
                    }

                    /* Status badge */
                    .status {
                        padding: .28rem .75rem;
                        border-radius: 20px;
                        font-size: .75rem;
                        font-weight: 700;
                        white-space: nowrap;
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

                    /* Status form */
                    .status-form {
                        display: flex;
                        align-items: center;
                        gap: .5rem;
                    }

                    .status-select {
                        background: #252525;
                        border: 1.5px solid #333;
                        color: #eee;
                        border-radius: 8px;
                        padding: .35rem .6rem;
                        font-size: .82rem;
                        font-family: inherit;
                        cursor: pointer;
                    }

                    .status-select:focus {
                        outline: none;
                        border-color: #f97316;
                    }

                    .btn-update {
                        background: #f97316;
                        border: none;
                        color: #fff;
                        border-radius: 7px;
                        padding: .35rem .75rem;
                        font-size: .8rem;
                        font-weight: 700;
                        cursor: pointer;
                        font-family: inherit;
                        transition: background .2s;
                        white-space: nowrap;
                    }

                    .btn-update:hover {
                        background: #ea6a05;
                    }

                    /* Header */
                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 1.5rem;
                    }

                    h1 {
                        font-size: 1.4rem;
                        font-weight: 700;
                        color: #f0f0f0;
                    }

                    .total-badge {
                        background: #252525;
                        color: #aaa;
                        font-size: .82rem;
                        padding: .3rem .8rem;
                        border-radius: 20px;
                    }
                </style>
            </head>

            <body>

                <div class="sidebar">
                    <div class="logo">⚙️ Admin Panel</div>
                    <a href="${pageContext.request.contextPath}/admin/home">📊 Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/products">🍖 Món ăn</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="active">📦 Đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/home" style="margin-top:2rem;">← Về trang chủ</a>
                </div>

                <div class="main">
                    <div class="page-header">
                        <h1>📦 Quản lý đơn hàng</h1>
                        <span class="total-badge">${orders.size()} đơn</span>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">⚠️ ${error}</div>
                    </c:if>

                    <!-- Filter tabs -->
                    <div class="filter-bar">
                        <a href="${pageContext.request.contextPath}/admin/orders"
                            class="filter-btn ${filterStatus == -1 ? 'active' : ''}">🗂 Tất cả</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?status=0"
                            class="filter-btn ${filterStatus == 0 ? 'active' : ''}">⏳ Chờ xác nhận</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?status=1"
                            class="filter-btn ${filterStatus == 1 ? 'active' : ''}">✅ Đã xác nhận</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?status=2"
                            class="filter-btn ${filterStatus == 2 ? 'active' : ''}">🚚 Đang giao</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?status=3"
                            class="filter-btn ${filterStatus == 3 ? 'active' : ''}">🎉 Hoàn thành</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?status=4"
                            class="filter-btn ${filterStatus == 4 ? 'active' : ''}">❌ Đã hủy</a>
                    </div>

                    <div class="table-wrap">
                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="empty">
                                    <div style="font-size:3rem;margin-bottom:1rem;">📭</div>
                                    <p>Không có đơn hàng nào.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Khách hàng</th>
                                            <th>SĐT</th>
                                            <th>Địa chỉ</th>
                                            <th>Ngày đặt</th>
                                            <th>Tổng tiền</th>
                                            <th>Thanh toán</th>
                                            <th>Trạng thái</th>
                                            <th>Cập nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${orders}">
                                            <tr>
                                                <td class="order-id">#${o.orderID}</td>
                                                <td class="customer">${o.customerName}</td>
                                                <td style="color:#888;">${o.phone}</td>
                                                <td style="color:#888;max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                                                    title="${o.shipAddress}">${o.shipAddress}</td>
                                                <td class="date-col">
                                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" /><br>
                                                    <fmt:formatDate value="${o.orderDate}" pattern="HH:mm" />
                                                </td>
                                                <td class="price">
                                                    <fmt:formatNumber value="${o.finalAmount}" pattern="#,###" />đ
                                                </td>
                                                <td><span class="method-badge">${o.paymentMethod}</span>
                                                    <c:if test="${o.paid}">
                                                        <span
                                                            style="display:block;margin-top:.3rem;font-size:.72rem;color:#4ade80;font-weight:700;">✔
                                                            Đã thu</span>
                                                    </c:if>
                                                    <c:if test="${!o.paid}">
                                                        <span
                                                            style="display:block;margin-top:.3rem;font-size:.72rem;color:#fbbf24;font-weight:700;">⏳
                                                            Chưa thu</span>
                                                    </c:if>
                                                </td>
                                                <td><span class="status s${o.status}">${o.statusLabel}</span></td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/admin/orders"
                                                        method="post" class="status-form">
                                                        <input type="hidden" name="orderID" value="${o.orderID}">
                                                        <select name="newStatus" class="status-select">
                                                            <option value="0" ${o.status==0 ? 'selected' : '' }>⏳ Chờ
                                                                xác nhận</option>
                                                            <option value="1" ${o.status==1 ? 'selected' : '' }>✅ Xác
                                                                nhận</option>
                                                            <option value="2" ${o.status==2 ? 'selected' : '' }>🚚 Đang
                                                                giao</option>
                                                            <option value="3" ${o.status==3 ? 'selected' : '' }>🎉 Hoàn
                                                                thành</option>
                                                            <option value="4" ${o.status==4 ? 'selected' : '' }>❌ Hủy
                                                            </option>
                                                        </select>
                                                        <button type="submit" class="btn-update">Lưu</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </body>

            </html>