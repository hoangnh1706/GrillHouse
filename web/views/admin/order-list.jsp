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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-order-list.css">
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