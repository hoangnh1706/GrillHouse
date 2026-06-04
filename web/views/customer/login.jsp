<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng nhập – BếpNướng</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{background:#111;color:#e5e5e5;font-family:'DM Sans',sans-serif;
      min-height:100vh;display:flex;align-items:center;justify-content:center;
      background-image:radial-gradient(ellipse at 30% 50%,rgba(249,115,22,.06) 0%,transparent 60%);}
    .card{background:#1c1c1c;border:1px solid #2a2a2a;border-radius:20px;
      padding:2.5rem 2rem;width:100%;max-width:420px;box-shadow:0 24px 60px rgba(0,0,0,.5);}
    .logo{text-align:center;font-family:'Playfair Display',serif;font-size:1.8rem;
      color:#f97316;margin-bottom:.4rem;text-decoration:none;display:block;}
    .subtitle{text-align:center;color:#666;font-size:.9rem;margin-bottom:2rem;}

    .success{background:#14532d;border:1px solid #166534;color:#86efac;
      border-radius:8px;padding:.75rem 1rem;font-size:.88rem;margin-bottom:1.2rem;}
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
  </style>
</head>
<body>
<div class="card">
  <a href="${pageContext.request.contextPath}/home" class="logo">🔥 BếpNướng</a>
  <div class="subtitle">Đăng nhập để đặt món yêu thích</div>

  <c:if test="${param.msg == 'registered'}">
    <div class="success">✅ Đăng ký thành công! Hãy đăng nhập.</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="error">⚠️ ${error}</div>
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
