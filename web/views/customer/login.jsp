<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập – GrillHouse</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css">
    
    <script src="https://accounts.google.com/gsi/client" async defer></script>
</head>

<body>
    <div class="card">
        <a href="${pageContext.request.contextPath}/home" class="logo">🔥 GrillHouse</a>
        <div class="subtitle">Đăng nhập để đặt món yêu thích</div>

        <c:if test="${param.msg == 'registered'}">
            <div class="success">✅ Đăng ký thành công! Hãy đăng nhập.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">⚠ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <label>Email</label>
            <input type="email" name="email" value="${email}" placeholder="example@email.com" required autofocus>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="••••••••" required>

            <button type="submit" class="btn">Đăng nhập →</button>
        </form>

        <div style="margin: 1rem 0; text-align:center;">
            <div style="display:flex;align-items:center;gap:.75rem;margin:.5rem 0 1rem;">
                <div style="flex:1;height:1px;background:#ddd;"></div>
                <span style="color:#555;font-size:.82rem;">hoặc</span>
                <div style="flex:1;height:1px;background:#ddd;"></div>
            </div>

            <div id="g_id_onload"
                 data-client_id="274105902558-mgec9fp2152p1e8b7ceb1rg56geoahg3.apps.googleusercontent.com"
                 data-callback="handleGoogleLogin"
                 data-auto_prompt="false">
            </div>

            <div class="g_id_signin"
                 data-type="standard"
                 data-size="large"
                 data-theme="outline"
                 data-text="signin_with"
                 data-shape="rectangular"
                 data-logo_alignment="left"
                 data-width="340">
            </div>
        </div>

        <c:if test="${param.error == 'google_invalid'}">
            <div class="error">⚠ Token Google không hợp lệ. Vui lòng thử lại.</div>
        </c:if>
        <c:if test="${param.error == 'google_error'}">
            <div class="error">⚠ Lỗi đăng nhập Google. Vui lòng thử lại.</div>
        </c:if>

        <div class="links">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
    </div>

    <script>
        function handleGoogleLogin(response) {
            if (!response || !response.credential) {
                alert('Đăng nhập Google thất bại. Vui lòng thử lại.');
                return;
            }

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/auth/google';

            const input = document.createElement('input');
            input.type  = 'hidden';
            input.name  = 'credential';
            input.value = response.credential;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>