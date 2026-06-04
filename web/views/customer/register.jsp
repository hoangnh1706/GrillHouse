<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng ký – BếpNướng</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{background:#111;color:#e5e5e5;font-family:'DM Sans',sans-serif;
      min-height:100vh;display:flex;align-items:center;justify-content:center;padding:2rem 1rem;
      background-image:radial-gradient(ellipse at 70% 50%,rgba(249,115,22,.06) 0%,transparent 60%);}
    .card{background:#1c1c1c;border:1px solid #2a2a2a;border-radius:20px;
      padding:2.5rem 2rem;width:100%;max-width:440px;box-shadow:0 24px 60px rgba(0,0,0,.5);}
    .logo{text-align:center;font-family:'Playfair Display',serif;font-size:1.8rem;
      color:#f97316;margin-bottom:.4rem;text-decoration:none;display:block;}
    .subtitle{text-align:center;color:#666;font-size:.9rem;margin-bottom:2rem;}

    .error{background:#3b1a1a;border:1px solid #7f1d1d;color:#fca5a5;
      border-radius:8px;padding:.75rem 1rem;font-size:.88rem;margin-bottom:1.2rem;}

    label{display:block;font-size:.85rem;color:#888;margin-bottom:.35rem;font-weight:500;}
    input{width:100%;padding:.75rem 1rem;background:#252525;border:1.5px solid #333;
      border-radius:10px;color:#eee;font-size:.95rem;font-family:inherit;outline:none;
      transition:border .2s;margin-bottom:1.1rem;}
    input:focus{border-color:#f97316;}
    .btn{width:100%;padding:.85rem;background:#f97316;border:none;border-radius:10px;
      color:#fff;font-size:1rem;font-weight:700;cursor:pointer;font-family:inherit;
      transition:background .2s;margin-top:.3rem;}
    .btn:hover{background:#ea6a05;}
    .links{text-align:center;margin-top:1.2rem;color:#666;font-size:.88rem;}
    .links a{color:#f97316;text-decoration:none;}
    .hint{font-size:.78rem;color:#555;margin-top:-.8rem;margin-bottom:.8rem;}
  </style>
</head>
<body>
<div class="card">
  <a href="${pageContext.request.contextPath}/home" class="logo">🔥 BếpNướng</a>
  <div class="subtitle">Tạo tài khoản để đặt món dễ dàng hơn</div>

  <c:if test="${not empty error}">
    <div class="error">⚠️ ${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/register" method="post">
    <label>Họ và tên *</label>
    <input type="text" name="fullName" value="${fullName}" placeholder="Nguyễn Văn A" required autofocus>

    <label>Email *</label>
    <input type="email" name="email" value="${email}" placeholder="example@email.com" required>

    <label>Số điện thoại</label>
    <input type="tel" name="phone" value="${phone}" placeholder="0901234567">

    <label>Mật khẩu *</label>
    <input type="password" name="password" placeholder="Ít nhất 6 ký tự" required>
    <div class="hint">Mật khẩu phải có ít nhất 6 ký tự.</div>

    <label>Xác nhận mật khẩu *</label>
    <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>

    <button type="submit" class="btn">Đăng ký →</button>
  </form>

  <div class="links">
    Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
  </div>
</div>
</body>
</html>
