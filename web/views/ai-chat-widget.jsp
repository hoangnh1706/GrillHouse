<%-- 
  Include vào JSP: <%@ include file="/views/common/ai-chat-widget.jsp" %>
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Nút toggle -->
<button id="chat-toggle" onclick="toggleChat()" title="Chat với Chef AI">
    <svg viewBox="0 0 24 24">
        <path d="M20 2H4a2 2 0 00-2 2v18l4-4h14a2 2 0 002-2V4a2 2 0 00-2-2z"/>
    </svg>
    <span class="chat-badge" id="chat-badge">1</span>
</button>

<!-- Cửa sổ chat -->
<div id="chat-window">
    <div class="cw-head">
        <div class="cw-head-left">
            <div class="cw-avatar">&#129473;&#8205;&#127859;</div>
            <div>
                <div class="cw-title">Chef GrillHouse AI</div>
                <div class="cw-sub" id="ai-status">&#9679; Đang hoạt động</div>
            </div>
        </div>
        <button class="cw-close" onclick="toggleChat()">&#10005;</button>
    </div>

    <div class="cw-messages" id="cw-messages"></div>

    <div class="cw-quick" id="cw-quick">
        <button class="quick-btn" onclick="sendQuick('Tư vấn món không cay')">&#129385; Món không cay</button>
        <button class="quick-btn" onclick="sendQuick('Combo cho 2-3 người hết bao nhiêu?')">&#128101; Combo nhóm</button>
        <button class="quick-btn" onclick="sendQuick('Có món mới nào không?')">&#10024; Món mới</button>
        <button class="quick-btn" onclick="sendQuick('Chính sách giao hàng như thế nào?')">&#128230; Giao hàng</button>
    </div>

    <div class="cw-input-row">
        <input id="chat-input" type="text" placeholder="Nhập tin nhắn..."
               onkeydown="if(event.key==='Enter') sendMessage()">
        <button id="chat-send" onclick="sendMessage()">
            <svg viewBox="0 0 24 24">
                <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/>
            </svg>
        </button>
    </div>
</div>

<script>
(function () {
    // ── Config ──
    const AI_URL  = '${pageContext.request.contextPath}/ai/chat';
    const USER_NAME = '${not empty sessionScope.account ? sessionScope.account.fullName : "bạn"}';

    let isOpen   = false;
    let greeted  = false;
    let isLoading = false;

    // ── Toggle chat window ──
    window.toggleChat = function () {
        isOpen = !isOpen;
        const win   = document.getElementById('chat-window');
        const badge = document.getElementById('chat-badge');
        win.classList.toggle('open', isOpen);
        badge.style.display = 'none';

        if (isOpen && !greeted) {
            greeted = true;
            setTimeout(() => {
                addMsg('bot',
                    '&#128075; Xin chào <b>' + USER_NAME + '</b>! Mình là <b>Chef AI</b> của GrillHouse &#128293;<br>' +
                    'Mình có thể tư vấn món ăn, combo, chính sách giao hàng và tra cứu đơn hàng cho bạn. Bạn cần hỗ trợ gì?'
                );
            }, 300);
        }
        if (isOpen) scrollToBottom();
    };

    window.sendQuick = function (text) {
        document.getElementById('cw-quick').style.display = 'none';
        sendMsg(text);
    };

    window.sendMessage = function () {
        const input = document.getElementById('chat-input');
        const text  = input.value.trim();
        if (!text || isLoading) return;
        input.value = '';
        document.getElementById('cw-quick').style.display = 'none';
        sendMsg(text);
    };

    // ── Gửi tin nhắn → gọi Gemini API qua GeminiServlet ──
    async function sendMsg(text) {
        addMsg('user', escHtml(text));

        isLoading = true;
        document.getElementById('chat-send').disabled = true;
        document.getElementById('ai-status').textContent = '&#9679; Đang trả lời...';

        // Hiện typing indicator
        const typingId = showTyping();

        try {
            const res = await fetch(AI_URL, {
                method : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body   : JSON.stringify({ message: text })
            });

            const data = await res.json();
            removeTyping(typingId);

            if (data.reply) {
                // Format markdown đơn giản: **bold**, xuống dòng
                const formatted = data.reply
                    .replace(/\*\*(.*?)\*\*/g, '<b>$1</b>')
                    .replace(/\n/g, '<br>');
                addMsg('bot', formatted);
            } else {
                addMsg('bot', '&#128533; Xin lỗi, có lỗi xảy ra: ' + (data.error || 'Không xác định'));
            }

        } catch (err) {
            removeTyping(typingId);
            addMsg('bot', '&#128533; Không thể kết nối AI. Vui lòng thử lại!');
            console.error('[GrillHouse AI]', err);
        } finally {
            isLoading = false;
            document.getElementById('chat-send').disabled = false;
            document.getElementById('ai-status').textContent = '&#9679; Đang hoạt động';
        }
    }

    // ── Typing indicator ──
    function showTyping() {
        const id = 'typing-' + Date.now();
        const container = document.getElementById('cw-messages');
        const wrapper   = document.createElement('div');
        wrapper.className = 'msg bot'; wrapper.id = id;
        wrapper.innerHTML =
            '<div class="msg-avatar">&#129473;&#8205;&#127859;</div>' +
            '<div class="msg-bubble typing-bubble">' +
            '<span></span><span></span><span></span>' +
            '</div>';
        container.appendChild(wrapper);
        scrollToBottom();
        return id;
    }

    function removeTyping(id) {
        const el = document.getElementById(id);
        if (el) el.remove();
    }

    // ── Append message ──
    function addMsg(type, html) {
        const container = document.getElementById('cw-messages');
        const wrapper   = document.createElement('div');
        wrapper.className = 'msg ' + type;

        if (type === 'bot') {
            wrapper.innerHTML =
                '<div class="msg-avatar">&#129473;&#8205;&#127859;</div>' +
                '<div class="msg-bubble">' + html + '</div>';
        } else {
            wrapper.innerHTML = '<div class="msg-bubble">' + html + '</div>';
        }

        container.appendChild(wrapper);
        scrollToBottom();
    }

    function scrollToBottom() {
        const c = document.getElementById('cw-messages');
        c.scrollTop = c.scrollHeight;
    }

    function escHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    // Hiện badge sau 3s
    setTimeout(() => {
        if (!isOpen) document.getElementById('chat-badge').style.display = 'flex';
    }, 3000);

})();
</script>

<style>
/* Typing animation */
.typing-bubble {
    display: flex !important;
    gap: 4px;
    align-items: center;
    padding: .6rem .9rem !important;
}
.typing-bubble span {
    width: 7px; height: 7px; border-radius: 50%;
    background: #f97316;
    animation: typingDot .9s ease infinite;
    display: inline-block;
}
.typing-bubble span:nth-child(2) { animation-delay: .2s; }
.typing-bubble span:nth-child(3) { animation-delay: .4s; }
@keyframes typingDot {
    0%,100% { opacity:.3; transform: scale(1); }
    50%      { opacity:1;  transform: scale(1.3); }
}
</style>
