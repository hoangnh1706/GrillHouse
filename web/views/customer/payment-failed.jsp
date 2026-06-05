<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Thanh toán thất bại – BếpNướng</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{background:#111;color:#e5e5e5;font-family:'DM Sans',sans-serif;
      min-height:100vh;display:flex;align-items:center;justify-content:center;}
    .box{text-align:center;padding:3rem 2rem;max-width:440px;}
    .icon{font-size:4rem;margin-bottom:1.5rem;}
    h1{font-size:1.6rem;font-weight:700;color:#f87171;margin-bottom:.75rem;}
    p{color:#888;line-height:1.6;margin-bottom:1.5rem;}
    .err-detail{background:#3b1a1a;border:1px solid #7f1d1d;color:#fca5a5;
      border-radius:10px;padding:.9rem 1.2rem;font-size:.9rem;margin-bottom:1.5rem;}
    .btn{display:inline-block;background:#f97316;color:#fff;text-decoration:none;
      padding:.75rem 1.5rem;border-radius:10px;font-weight:700;margin:.3rem;}
    .btn-sec{background:transparent;border:1.5px solid #333;color:#888;}
  </style>
</head>
<body>
<div class="box">
  <div class="icon">❌</div>
  <h1>Thanh toán thất bại</h1>
  <c:if test="${not empty vnpayError}">
    <div class="err-detail">⚠️ ${vnpayError}</div>
  </c:if>
  <p>Đơn hàng chưa được tạo. Giỏ hàng của bạn vẫn còn nguyên, hãy thử lại.</p>
  <a href="${pageContext.request.contextPath}/checkout" class="btn">🔄 Thử lại</a>
  <a href="${pageContext.request.contextPath}/cart" class="btn btn-sec">🛒 Xem giỏ hàng</a>
</div>
</body>
</html>
