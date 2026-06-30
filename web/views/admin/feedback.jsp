<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Feedback – Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-dashboard.css">
</head>
<body>
    <div class="sidebar">
        <div class="logo">⚙️ Admin Panel</div>
        <a href="${pageContext.request.contextPath}/admin/home"> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products"> Món ăn</a>
        <a href="${pageContext.request.contextPath}/admin/orders"> Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/feedback" class="active"> Feedback</a>
        <a href="${pageContext.request.contextPath}/admin/chatbot"> Chatbot</a>
        <a href="${pageContext.request.contextPath}/logout" style="margin-top:2rem;">← Đăng xuất</a>
    </div>

    <div class="main">
        <div class="feedback-page">
            <div class="feedback-header">
                <div>
                    <h1>Quản lý Feedback</h1>
                    <p>Xem và xử lý phản hồi từ khách hàng theo bảng dữ liệu.</p>
                </div>
                <div class="feedback-summary">${feedbackList.size()} phản hồi</div>
            </div>

            <c:choose>
                <c:when test="${empty feedbackList}">
                    <div class="empty-state">Chưa có phản hồi nào.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-shell">
                        <table class="feedback-table">
                            <thead>
                                <tr>
                                    <th>Tên khách hàng</th>
                                    <th>Tên món ăn</th>
                                    <th>Nội dung phản hồi</th>
                                    <th>Thời gian</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="fb" items="${feedbackList}">
                                    <tr>
                                        <td>
                                            <strong>${fb.reviewerName}</strong><br>
                                            <span style="color:#888; font-size:.8rem;">${fb.reviewerEmail}</span>
                                        </td>
                                        <td>
                                            <strong>${fb.productName}</strong>
                                        </td>
                                        <td>
                                            <div class="feedback-content">${fb.comment}</div>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fn:contains(fb.comment, '[Phản hồi admin]:')}">
                                                    <span class="feedback-badge done">Đã xử lý</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="feedback-badge pending">Chưa xử lý</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="feedback-actions">
                                                <form class="reply-form" method="post" action="${pageContext.request.contextPath}/admin/feedback">
                                                    <input type="hidden" name="action" value="reply">
                                                    <input type="hidden" name="id" value="${fb.reviewID}">
                                                    <textarea name="reply" rows="3" placeholder="Nhập phản hồi cho khách hàng..."></textarea>
                                                    <button type="submit" class="btn btn-reply">Gửi phản hồi</button>
                                                </form>
                                                <a class="btn btn-delete" href="${pageContext.request.contextPath}/admin/feedback?action=delete&id=${fb.reviewID}" onclick="return confirm('Xóa phản hồi này?');">Xóa</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
