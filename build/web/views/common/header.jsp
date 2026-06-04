<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav style="
  background: #1a1a1a;
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
  position: sticky;
  top: 0;
  z-index: 999;
  box-shadow: 0 2px 12px rgba(0,0,0,.4);
">
  <!-- Logo -->
<a href="${pageContext.request.contextPath}/home" style="
   color:#f97316; font-size:1.4rem; font-weight:800;
   text-decoration:none; 
   font-family: 'Playfair Display', serif;
">🔥 Bếp Nướng</a>

  <!-- Search -->
  <form action="${pageContext.request.contextPath}/search" method="get" style="display:flex;gap:.5rem;">
    <input name="q" value="${keyword}" placeholder="Tìm món ăn..." style="
      padding:.45rem 1rem; border-radius:20px;
      border:1.5px solid #333; background:#2a2a2a;
      color:#eee; width:240px; font-size:.9rem;
      outline:none;
    ">
    <button type="submit" style="
      background:#f97316; border:none; border-radius:20px;
      color:#fff; padding:.45rem 1rem; cursor:pointer; font-weight:600;
    ">Tìm</button>
  </form>

  <!-- Right menu -->
  <div style="display:flex;align-items:center;gap:1.2rem;">
    <!-- Giỏ hàng -->
    <a href="${pageContext.request.contextPath}/cart" style="
      color:#eee; text-decoration:none; font-size:.95rem;
      display:flex; align-items:center; gap:.35rem;
    ">
      🛒
      <c:if test="${not empty sessionScope.cart and sessionScope.cart.totalItems > 0}">
        <span style="
          background:#f97316; color:#fff;
          border-radius:50%; width:20px; height:20px;
          font-size:.72rem; display:flex; align-items:center;
          justify-content:center; font-weight:700;
        ">${sessionScope.cart.totalItems}</span>
      </c:if>
      Giỏ hàng
    </a>

    <!-- Account -->
    <c:choose>
      <c:when test="${not empty sessionScope.account}">
        <div style="position:relative;" onmouseenter="this.querySelector('.dd').style.display='block'"
                                        onmouseleave="this.querySelector('.dd').style.display='none'">
          <span style="color:#f97316;cursor:pointer;font-weight:600;">
            👤 ${sessionScope.account.fullName}
          </span>
          <div class="dd" style="
            display:none; position:absolute; right:0; top:100%;
            background:#2a2a2a; border-radius:8px; min-width:160px;
            box-shadow:0 8px 24px rgba(0,0,0,.4); overflow:hidden;
          ">
            <a href="${pageContext.request.contextPath}/my-orders" style="
              display:block;padding:.7rem 1rem;color:#ddd;
              text-decoration:none;font-size:.9rem;
            " onmouseover="this.style.background='#f97316'" onmouseout="this.style.background=''"
            >📋 Đơn hàng của tôi</a>
            <c:if test="${sessionScope.account.admin}">
              <a href="${pageContext.request.contextPath}/admin/home" style="
                display:block;padding:.7rem 1rem;color:#ddd;
                text-decoration:none;font-size:.9rem;
              " onmouseover="this.style.background='#f97316'" onmouseout="this.style.background=''"
              >⚙️ Quản trị</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/logout" style="
              display:block;padding:.7rem 1rem;color:#f87171;
              text-decoration:none;font-size:.9rem;border-top:1px solid #333;
            " onmouseover="this.style.background='#3a1a1a'" onmouseout="this.style.background=''"
            >🚪 Đăng xuất</a>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login" style="
          color:#eee;text-decoration:none;font-size:.95rem;
        ">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" style="
          background:#f97316;color:#fff;text-decoration:none;
          padding:.45rem 1rem;border-radius:20px;font-size:.9rem;font-weight:600;
        ">Đăng ký</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>
