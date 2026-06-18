<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <title>Thanh toán thất bại – GrillHouse</title>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/payment-failed.css">
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