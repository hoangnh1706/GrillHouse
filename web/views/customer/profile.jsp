<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thông tin cá nhân – BếpNướng</title>
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
                        max-width: 800px;
                        margin: 2rem auto;
                        padding: 0 1.5rem;
                    }

                    h1 {
                        font-family: 'Playfair Display', serif;
                        color: #f97316;
                        font-size: 2rem;
                        margin-bottom: 1.8rem;
                    }

                    /* Alert boxes */
                    .alert-success {
                        background: #14532d;
                        border: 1px solid #166534;
                        color: #86efac;
                        border-radius: 10px;
                        padding: .85rem 1.2rem;
                        margin-bottom: 1.5rem;
                        font-weight: 500;
                    }

                    .alert-error {
                        background: #3b1a1a;
                        border: 1px solid #7f1d1d;
                        color: #fca5a5;
                        border-radius: 10px;
                        padding: .85rem 1.2rem;
                        margin-bottom: 1.5rem;
                    }

                    /* Tab nav */
                    .tabs {
                        display: flex;
                        gap: .5rem;
                        margin-bottom: 1.5rem;
                        border-bottom: 1px solid #252525;
                        padding-bottom: 0;
                    }

                    .tab-btn {
                        padding: .6rem 1.2rem;
                        background: none;
                        border: none;
                        color: #777;
                        font-size: .92rem;
                        font-weight: 600;
                        cursor: pointer;
                        font-family: inherit;
                        border-bottom: 2px solid transparent;
                        margin-bottom: -1px;
                        transition: all .2s;
                    }

                    .tab-btn.active {
                        color: #f97316;
                        border-bottom-color: #f97316;
                    }

                    .tab-btn:hover {
                        color: #f97316;
                    }

                    /* Tab panels */
                    .tab-panel {
                        display: none;
                    }

                    .tab-panel.active {
                        display: block;
                    }

                    /* Cards */
                    .card {
                        background: #1c1c1c;
                        border: 1px solid #2a2a2a;
                        border-radius: 14px;
                        padding: 1.8rem;
                    }

                    /* Avatar area */
                    .avatar-section {
                        display: flex;
                        align-items: center;
                        gap: 1.5rem;
                        margin-bottom: 1.8rem;
                        padding-bottom: 1.5rem;
                        border-bottom: 1px solid #252525;
                    }

                    .avatar-circle {
                        width: 72px;
                        height: 72px;
                        border-radius: 50%;
                        background: #2a2a2a;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2rem;
                        border: 2px solid #f97316;
                        overflow: hidden;
                        flex-shrink: 0;
                    }

                    .avatar-circle img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .avatar-info h3 {
                        font-size: 1.1rem;
                        color: #f0f0f0;
                        font-weight: 700;
                    }

                    .avatar-info p {
                        color: #666;
                        font-size: .85rem;
                        margin-top: .25rem;
                    }

                    .member-since {
                        color: #555;
                        font-size: .78rem;
                        margin-top: .3rem;
                    }

                    /* Form */
                    .form-group {
                        margin-bottom: 1.2rem;
                    }

                    label {
                        display: block;
                        font-size: .85rem;
                        color: #888;
                        margin-bottom: .4rem;
                        font-weight: 500;
                    }

                    input[type=text],
                    input[type=tel],
                    input[type=password],
                    input[type=email] {
                        width: 100%;
                        padding: .75rem 1rem;
                        background: #252525;
                        border: 1.5px solid #333;
                        border-radius: 10px;
                        color: #eee;
                        font-size: .95rem;
                        font-family: inherit;
                        outline: none;
                        transition: border .2s;
                    }

                    input:focus {
                        border-color: #f97316;
                    }

                    input[readonly] {
                        background: #1a1a1a;
                        color: #555;
                        cursor: not-allowed;
                        border-color: #252525;
                    }

                    .hint {
                        font-size: .78rem;
                        color: #555;
                        margin-top: .3rem;
                    }

                    .btn-save {
                        background: #f97316;
                        color: #fff;
                        padding: .75rem 2rem;
                        border: none;
                        border-radius: 10px;
                        font-size: .95rem;
                        font-weight: 700;
                        cursor: pointer;
                        font-family: inherit;
                        transition: background .2s;
                    }

                    .btn-save:hover {
                        background: #ea6a05;
                    }

                    /* Info grid */
                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1rem;
                    }

                    @media(max-width:560px) {
                        .info-grid {
                            grid-template-columns: 1fr;
                        }
                    }

                    /* Stats bar */
                    .stats-bar {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 1rem;
                        margin-bottom: 1.5rem;
                    }

                    .stat {
                        background: #1c1c1c;
                        border: 1px solid #2a2a2a;
                        border-radius: 12px;
                        padding: 1rem;
                        text-align: center;
                    }

                    .stat-val {
                        font-size: 1.5rem;
                        font-weight: 800;
                        color: #f97316;
                    }

                    .stat-lbl {
                        font-size: .78rem;
                        color: #666;
                        margin-top: .25rem;
                    }
                </style>
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