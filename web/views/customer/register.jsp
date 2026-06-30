<!-- Khai báo thư viện JSTL và thiết lập tiếng Việt cho trang JSP -->
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <!-- ======================== HEAD BLOCK ======================== -->
  <!-- Khai báo các thẻ meta, tiêu đề trang, tích hợp font chữ Google và file CSS giao diện -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng ký – GrillHouse</title>
  <link
    href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
    rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register.css">
</head>

<body>
  <!-- ======================== BODY BLOCK ======================== -->
  <!-- Khung giao diện chính chứa thẻ đăng ký -->
  <div class="card">

    <!-- ======================== HEADER / LOGO BLOCK ======================== -->
    <!-- Logo kèm link trỏ về trang chủ và dòng mô tả ngắn -->
    <a href="${pageContext.request.contextPath}/home" class="logo">🔥 GrillHouse</a>
    <div class="subtitle">Tạo tài khoản để đặt món dễ dàng hơn</div>

    <!-- ======================== ERROR MESSAGE BLOCK ======================== -->
    <!-- Khối kiểm tra và hiển thị thông báo lỗi từ phía server (nếu có) -->
    <c:if test="${not empty error}">
      <div class="error">⚠️ ${error}</div>
    </c:if>

    <!-- ======================== REGISTER FORM BLOCK ======================== -->
    <!-- Form thu thập thông tin đăng ký, submit về URL "/register" qua phương thức POST -->
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

    <!-- ======================== FOOTER LINKS BLOCK ======================== -->
    <!-- Khối chứa các đường dẫn hỗ trợ (như chuyển hướng sang đăng nhập nếu đã có tài khoản) -->
    <div class="links">
      Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </div>

  </div>
</body>

</html>