<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!-- ========== CHATBOT WIDGET ========== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/chatbot.css">

        <!-- Nút toggle -->
        <button id="chat-toggle" onclick="toggleChat()" title="Chat với Chef AI">
            <svg viewBox="0 0 24 24">
                <path d="M20 2H4a2 2 0 00-2 2v18l4-4h14a2 2 0 002-2V4a2 2 0 00-2-2z" />
            </svg>
            <span class="chat-badge" id="chat-badge">1</span>
        </button>

        <!-- Cửa sổ chat -->
        <div id="chat-window">
            <div class="cw-head">
                <div class="cw-head-left">
                    <div class="cw-avatar">🧑‍🍳</div>
                    <div>
                        <div class="cw-title">Chef GrillHouse AI</div>
                        <div class="cw-sub">● Đang hoạt động</div>
                    </div>
                </div>
                <button class="cw-close" onclick="toggleChat()">✕</button>
            </div>
            <div class="cw-messages" id="cw-messages"></div>
            <div class="cw-quick" id="cw-quick">
                <button class="quick-btn" onclick="sendQuick('Tư vấn món không cay')">🥩 Món không cay</button>
                <button class="quick-btn" onclick="sendQuick('Combo 2-3 người hết bao nhiêu?')">👥 Combo nhóm</button>
                <button class="quick-btn" onclick="sendQuick('Món nướng mới nhất?')">✨ Món mới</button>
                <button class="quick-btn" onclick="sendQuick('Tra cứu đơn hàng')">📦 Tra đơn hàng</button>
            </div>
            <div class="cw-input-row">
                <input id="chat-input" type="text" placeholder="Nhập tin nhắn..."
                    onkeydown="if(event.key==='Enter') sendMessage()">
                <button id="chat-send" onclick="sendMessage()">
                    <svg viewBox="0 0 24 24">
                        <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
                    </svg>
                </button>
            </div>
        </div>

        <script>
            (function () {
                let isOpen = false, greeted = false;

                // Hàm mở/đóng cửa sổ chat
                window.toggleChat = function () {
                    isOpen = !isOpen;
                    document.getElementById('chat-window').classList.toggle('open', isOpen);
                    document.getElementById('chat-badge').style.display = 'none';
        
                    // Lời chào tự động khi mở chat lần đầu
                    if (isOpen && !greeted) {
                        greeted = true;
                        setTimeout(() => {
                            const name = '${not empty sessionScope.account ? sessionScope.account.fullName : "bạn"}';
                            addMsg('bot', '👋 Xin chào <b>' + name + '</b>! Mình là <b>Chef AI</b> của GrillHouse 🔥<br>Bạn cần tư vấn gì?');
                        }, 300);
                    }
                };

                // Hàm gửi tin nhắn từ các nút quick-reply
                window.sendQuick = function (text) { sendMsg(text); };
                 
                 // Hàm gửi tin nhắn từ ô input
                window.sendMessage = function () {
                    const input = document.getElementById('chat-input');
                    const text = input.value.trim();
                    if (!text) return;
                    input.value = '';
                    sendMsg(text);
                };

                // Hàm xử lý logic gửi tin nhắn
                function sendMsg(text) {
                    addMsg('user', text);
                    document.getElementById('cw-quick').style.display = 'none';
                    
                    // Gửi lên server xử lý
                    fetch('${pageContext.request.contextPath}/api/chatbot', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'message=' + encodeURIComponent(text)
                    })
                    .then(res => res.text())
                    .then(reply => {
                        addMsg('bot', reply);
                    })
                    .catch(err => {
                        console.error("Lỗi:", err);
                        addMsg('bot', 'Xin lỗi, hệ thống đang bận. Vui lòng thử lại sau!');
                    });
                }

                // Hàm thêm tin nhắn vào giao diện
                function addMsg(type, html) {
                    const c = document.getElementById('cw-messages');
                    const w = document.createElement('div');
                    w.className = 'msg ' + type;
                    w.innerHTML = type === 'bot'
                        ? '<div class="msg-avatar">🧑‍🍳</div><div class="msg-bubble">' + html.replace(/\n/g, '<br>') + '</div>'
                        : '<div class="msg-bubble">' + html.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</div>';
                    c.appendChild(w);
                    c.scrollTop = c.scrollHeight;
                }

                // Tự động hiển thị badge sau 3 giây nếu chưa mở
                setTimeout(() => {
                    if (!isOpen) document.getElementById('chat-badge').style.display = 'flex';
                }, 3000);
            })();
        </script>
       