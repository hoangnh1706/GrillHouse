<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Đăng nhập – GrillHouse</title>
      <link
        href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
        rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css">
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

        <div class="links">
          Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
      </div>
    </body>

    </html>