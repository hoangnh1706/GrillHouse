<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý Chatbot – Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-dashboard.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/chatbot-manage.css">
</head>
<body>
  <div class="sidebar">
    <div class="logo">⚙️ Admin Panel</div>
    <a href="${pageContext.request.contextPath}/admin/home"> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products"> Món ăn</a>
    <a href="${pageContext.request.contextPath}/admin/orders"> Đơn hàng</a>
    <a href="${pageContext.request.contextPath}/admin/feedback"> Feedback</a>
    <a href="${pageContext.request.contextPath}/admin/chatbot" class="active"> Chatbot</a>
    <a href="${pageContext.request.contextPath}/logout" style="margin-top:2rem;">← Đăng xuất</a>
  </div>

  <div class="main">
    <div class="welcome" style="display:flex; justify-content: space-between; align-items: center;">
      <h1>Quản lý Chatbot AI</h1>
      <button class="btn btn-primary" onclick="openModal('add')">+ Thêm quy tắc</button>
    </div>

    <c:if test="${not empty sessionScope.msg}">
      <div style="background: #14532d; color: #86efac; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">${sessionScope.msg}</div>
      <c:remove var="msg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
      <div style="background: #7f1d1d; color: #fca5a5; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">${sessionScope.error}</div>
      <c:remove var="error" scope="session"/>
    </c:if>

    <table class="chatbot-table">
      <thead>
        <tr>
          <th width="5%">ID</th>
          <th width="30%">Từ khóa (cách nhau bởi dấu phẩy)</th>
          <th width="45%">Câu trả lời (hỗ trợ HTML)</th>
          <th width="20%">Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${rules}">
          <tr>
            <td>${r.ruleID}</td>
            <td>${r.keywords}</td>
            <td><pre>${r.reply}</pre></td>
            <td>
              <button class="btn btn-edit" data-id="${r.ruleID}" data-keywords="${fn:escapeXml(r.keywords)}" data-reply="${fn:escapeXml(r.reply)}" onclick="handleEdit(this)">Sửa</button>
              <a href="${pageContext.request.contextPath}/admin/chatbot?action=delete&id=${r.ruleID}" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa?')">Xóa</a>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty rules}">
          <tr><td colspan="4" style="text-align:center; padding: 2rem;">Chưa có dữ liệu.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>

  <!-- Modal -->
  <div class="modal" id="chatbotModal">
    <div class="modal-content">
      <h2 id="modalTitle" style="margin-bottom: 1.5rem;">Thêm/Sửa Quy Tắc</h2>
      <form action="${pageContext.request.contextPath}/admin/chatbot" method="post">
        <input type="hidden" name="action" id="formAction" value="add">
        <input type="hidden" name="ruleID" id="formRuleID" value="0">
        
        <div class="form-group">
          <label>Các từ khóa (ngăn cách bởi dấu phẩy)</label>
          <input type="text" name="keywords" id="formKeywords" required placeholder="VD: xin chào, hi, hello">
        </div>
        
        <div class="form-group">
          <label>Câu trả lời (hỗ trợ HTML cơ bản như &lt;b&gt;, &lt;br&gt;)</label>
          <textarea name="reply" id="formReply" rows="6" required placeholder="VD: Xin chào! Mình có thể giúp gì cho bạn?"></textarea>
        </div>
        
        <div style="display:flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem;">
          <button type="button" class="btn" style="background:#444; color:white;" onclick="closeModal()">Hủy</button>
          <button type="submit" class="btn btn-primary">Lưu lại</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function handleEdit(btn) {
      const id = btn.getAttribute('data-id');
      const keywords = btn.getAttribute('data-keywords');
      const reply = btn.getAttribute('data-reply');
      openModal('edit', id, keywords, reply);
    }

    function openModal(action, id = 0, keywords = '', reply = '') {
      document.getElementById('formAction').value = action;
      document.getElementById('formRuleID').value = id;
      document.getElementById('formKeywords').value = keywords;
      document.getElementById('formReply').value = reply;
      document.getElementById('modalTitle').innerText = action === 'add' ? 'Thêm Quy Tắc Mới' : 'Sửa Quy Tắc';
      document.getElementById('chatbotModal').classList.add('active');
    }
    function closeModal() {
      document.getElementById('chatbotModal').classList.remove('active');
    }
  </script>
</body>
</html>
