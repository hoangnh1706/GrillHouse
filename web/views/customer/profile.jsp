<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thông tin cá nhân – GrillHouse</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
                    rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/profile.css">
            </head>

            <body>
                <%@ include file="/views/common/header.jsp" %>

                    <div class="container">
                        <h1>👤 Thông tin cá nhân</h1>

                        <%-- Thông báo --%>
                            <c:if test="${param.msg == 'updated'}">
                                <div class="alert-success">✅ Cập nhật thông tin thành công!</div>
                            </c:if>
                            <c:if test="${param.msg == 'pwchanged'}">
                                <div class="alert-success">🔒 Đổi mật khẩu thành công!</div>
                            </c:if>
                            <c:if test="${not empty profileError}">
                                <div class="alert-error">⚠️ ${profileError}</div>
                            </c:if>
                            <c:if test="${not empty pwError}">
                                <div class="alert-error">⚠️ ${pwError}</div>
                            </c:if>

                            <%-- Avatar + tên --%>
                                <div class="card" style="margin-bottom:1.5rem;">
                                    <div class="avatar-section">
                                        <div class="avatar-circle">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.account.avatar}">
                                                    <img src="${sessionScope.account.avatar}" alt="avatar">
                                                </c:when>
                                                <c:otherwise>👤</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="avatar-info">
                                            <h3>${sessionScope.account.fullName}</h3>
                                            <p>${sessionScope.account.email}</p>
                                            <div class="member-since">
                                                Thành viên từ:
                                                <fmt:formatDate value="${sessionScope.account.createdAt}"
                                                    pattern="dd/MM/yyyy" />
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Tabs --%>
                                        <div class="tabs">
                                            <button class="tab-btn active" onclick="switchTab('info', this)">📋 Thông
                                                tin</button>
                                            <button class="tab-btn" onclick="switchTab('password', this)">🔒 Đổi mật
                                                khẩu</button>
                                        </div>

                                        <%-- Tab: Thông tin --%>
                                            <div id="tab-info" class="tab-panel active">
                                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                                    <input type="hidden" name="action" value="updateProfile">

                                                    <div class="info-grid">
                                                        <div class="form-group">
                                                            <label>Họ và tên *</label>
                                                            <input type="text" name="fullName"
                                                                value="${sessionScope.account.fullName}" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Email (không thể đổi)</label>
                                                            <input type="email" value="${sessionScope.account.email}"
                                                                readonly>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Số điện thoại</label>
                                                            <input type="tel" name="phone"
                                                                value="${sessionScope.account.phone}"
                                                                placeholder="0901234567">
                                                        </div>
                                                        <div class="form-group" style="grid-column:1/-1;">
                                                            <label>Địa chỉ</label>
                                                            <input type="text" name="address"
                                                                value="${sessionScope.account.address}"
                                                                placeholder="Số nhà, đường, phường, quận, tỉnh...">
                                                        </div>
                                                    </div>

                                                    <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
                                                </form>
                                            </div>

                                            <%-- Tab: Đổi mật khẩu --%>
                                                <div id="tab-password" class="tab-panel">
                                                    <form action="${pageContext.request.contextPath}/profile"
                                                        method="post">
                                                        <input type="hidden" name="action" value="changePassword">

                                                        <div class="form-group">
                                                            <label>Mật khẩu hiện tại *</label>
                                                            <input type="password" name="oldPassword"
                                                                placeholder="••••••••" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Mật khẩu mới *</label>
                                                            <input type="password" name="newPassword"
                                                                placeholder="Ít nhất 6 ký tự" required>
                                                            <div class="hint">Mật khẩu phải có ít nhất 6 ký tự.</div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Xác nhận mật khẩu mới *</label>
                                                            <input type="password" name="confirmPassword"
                                                                placeholder="Nhập lại mật khẩu mới" required>
                                                        </div>

                                                        <button type="submit" class="btn-save">🔒 Đổi mật khẩu</button>
                                                    </form>
                                                </div>
                                </div>

                                <%-- Shortcut đơn hàng --%>
                                    <div style="text-align:center;padding:1rem 0;">
                                        <a href="${pageContext.request.contextPath}/my-orders"
                                            style="color:#f97316;font-weight:600;text-decoration:none;font-size:.95rem;">
                                            📋 Xem lịch sử đơn hàng →
                                        </a>
                                    </div>
                    </div>

                    <script>
                        function switchTab(name, btn) {
                            // Ẩn tất cả panels
                            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                            // Hiện panel được chọn
                            document.getElementById('tab-' + name).classList.add('active');
                            btn.classList.add('active');
                        }

                        // Tự động mở tab đổi mật khẩu nếu có lỗi mật khẩu
                        <c:if test="${not empty pwError}">
                            window.onload = function() {
                                switchTab('password', document.querySelectorAll('.tab-btn')[1]);
    };
                        </c:if>
                    </script>
            </body>

            </html>