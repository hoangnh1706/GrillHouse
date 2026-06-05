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
       ">🔥GrillHouse</a>

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
                        <a href="${pageContext.request.contextPath}/profile" style="
                           display:block;padding:.7rem 1rem;color:#ddd;
                           text-decoration:none;font-size:.9rem;
                           " onmouseover="this.style.background = '#f97316'" onmouseout="this.style.background = ''">👤 Thông tin cá
                            nhân</a>
                        <a href="${pageContext.request.contextPath}/my-orders" style="
                           display:block;padding:.7rem 1rem;color:#ddd;
                           text-decoration:none;font-size:.9rem;
                           " onmouseover="this.style.background = '#f97316'" onmouseout="this.style.background = ''">📋 Đơn hàng của
                            tôi</a>
                            <c:if test="${sessionScope.account.admin}">
                            <a href="${pageContext.request.contextPath}/admin/home" style="
                               display:block;padding:.7rem 1rem;color:#ddd;
                               text-decoration:none;font-size:.9rem;
                               " onmouseover="this.style.background = '#f97316'" onmouseout="this.style.background = ''">⚙️ Quản trị</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" style="
                           display:block;padding:.7rem 1rem;color:#f87171;
                           text-decoration:none;font-size:.9rem;border-top:1px solid #333;
                           " onmouseover="this.style.background = '#3a1a1a'" onmouseout="this.style.background = ''">🚪 Đăng xuất</a>
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

<!-- ========== CHATBOT WIDGET ========== -->
<style>
    /* Nút mở chatbot */
    #chat-toggle {
        position: fixed;
        bottom: 1.5rem;
        right: 1.5rem;
        z-index: 9999;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        background: #f97316;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 20px rgba(249, 115, 22, .5);
        display: flex;
        align-items: center;
        justify-content: center;
        transition: transform .2s, box-shadow .2s;
    }

    #chat-toggle:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 28px rgba(249, 115, 22, .6);
    }

    #chat-toggle svg {
        width: 26px;
        height: 26px;
        fill: #fff;
    }

    .chat-badge {
        position: absolute;
        top: -4px;
        right: -4px;
        background: #ef4444;
        color: #fff;
        border-radius: 50%;
        width: 18px;
        height: 18px;
        font-size: .68rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        display: none;
    }

    /* Cửa sổ chat */
    #chat-window {
        position: fixed;
        bottom: 5rem;
        right: 1.5rem;
        z-index: 9998;
        width: 340px;
        max-height: 520px;
        background: #1a1a1a;
        border: 1px solid #2a2a2a;
        border-radius: 18px;
        box-shadow: 0 16px 48px rgba(0, 0, 0, .6);
        display: flex;
        flex-direction: column;
        transform: scale(.85) translateY(20px);
        opacity: 0;
        pointer-events: none;
        transition: transform .25s ease, opacity .25s ease;
        font-family: 'DM Sans', sans-serif;
    }

    #chat-window.open {
        transform: scale(1) translateY(0);
        opacity: 1;
        pointer-events: all;
    }

    /* Header */
    .cw-head {
        background: linear-gradient(90deg, #f97316, #ea580c);
        border-radius: 18px 18px 0 0;
        padding: .85rem 1rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .cw-head-left {
        display: flex;
        align-items: center;
        gap: .6rem;
    }

    .cw-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: #fff2;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
    }

    .cw-title {
        color: #fff;
        font-weight: 700;
        font-size: .92rem;
    }

    .cw-sub {
        color: rgba(255, 255, 255, .75);
        font-size: .72rem;
        margin-top: .1rem;
    }

    .cw-close {
        background: none;
        border: none;
        color: #fff;
        cursor: pointer;
        font-size: 1.2rem;
        padding: .2rem .4rem;
        border-radius: 6px;
        transition: background .2s;
    }

    .cw-close:hover {
        background: rgba(255, 255, 255, .2);
    }

    /* Messages */
    .cw-messages {
        flex: 1;
        overflow-y: auto;
        padding: 1rem;
        display: flex;
        flex-direction: column;
        gap: .65rem;
        max-height: 300px;
        scrollbar-width: thin;
        scrollbar-color: #333 transparent;
    }

    .cw-messages::-webkit-scrollbar {
        width: 4px;
    }

    .cw-messages::-webkit-scrollbar-track {
        background: transparent;
    }

    .cw-messages::-webkit-scrollbar-thumb {
        background: #333;
        border-radius: 4px;
    }

    .msg {
        display: flex;
        gap: .5rem;
        align-items: flex-end;
        max-width: 85%;
    }

    .msg.bot {
        align-self: flex-start;
    }

    .msg.user {
        align-self: flex-end;
        flex-direction: row-reverse;
    }

    .msg-avatar {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: #f97316;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: .85rem;
        flex-shrink: 0;
    }

    .msg-bubble {
        padding: .55rem .85rem;
        border-radius: 14px;
        font-size: .87rem;
        line-height: 1.5;
    }

    .msg.bot .msg-bubble {
        background: #252525;
        color: #e5e5e5;
        border-bottom-left-radius: 4px;
    }

    .msg.user .msg-bubble {
        background: #f97316;
        color: #fff;
        border-bottom-right-radius: 4px;
    }

    /* Quick replies */
    .cw-quick {
        padding: .6rem 1rem .4rem;
        display: flex;
        flex-wrap: wrap;
        gap: .4rem;
    }

    .quick-btn {
        background: #252525;
        border: 1.5px solid #333;
        color: #f97316;
        border-radius: 20px;
        padding: .35rem .8rem;
        font-size: .8rem;
        cursor: pointer;
        font-family: inherit;
        font-weight: 600;
        transition: all .2s;
        white-space: nowrap;
    }

    .quick-btn:hover {
        background: #f97316;
        color: #fff;
        border-color: #f97316;
    }

    /* Input */
    .cw-input-row {
        display: flex;
        gap: .5rem;
        padding: .75rem 1rem;
        border-top: 1px solid #252525;
    }

    #chat-input {
        flex: 1;
        background: #252525;
        border: 1.5px solid #333;
        border-radius: 20px;
        color: #eee;
        padding: .5rem 1rem;
        font-size: .88rem;
        font-family: inherit;
        outline: none;
        transition: border .2s;
    }

    #chat-input:focus {
        border-color: #f97316;
    }

    #chat-send {
        background: #f97316;
        border: none;
        border-radius: 50%;
        width: 36px;
        height: 36px;
        cursor: pointer;
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: background .2s;
    }

    #chat-send:hover {
        background: #ea6a05;
    }

    #chat-send svg {
        width: 16px;
        height: 16px;
        fill: #fff;
    }
</style>

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
               onkeydown="if (event.key === 'Enter')
                      sendMessage()">
        <button id="chat-send" onclick="sendMessage()">
            <svg viewBox="0 0 24 24">
            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
            </svg>
        </button>
    </div>
</div>

<script>
    (function () {
        // ---- Dữ liệu tri thức chatbot ----
        const KB = [
            {
                keys: ['không cay', 'ít cay', 'nhẹ', 'mild'],
                reply: '🥩 Các món ít/không cay bạn có thể thử:\n• <b>Vịt nướng mắm gừng</b> – vị đậm đà, không cay\n• <b>Gà nướng muối ớt</b> – có thể yêu cầu bỏ ớt\n• <b>Bò nướng lá lốt</b> – thơm ngon, không cay\nBạn muốn xem chi tiết món nào?'
            },
            {
                keys: ['combo', 'nhóm', '2 người', '3 người', '4 người', 'gia đình'],
                reply: '👥 Gợi ý combo theo nhóm:\n• <b>Combo 2 người</b> ~250.000đ: 1 đĩa thịt + 1 đĩa hải sản + rau\n• <b>Combo 4 người</b> ~480.000đ: 2 đĩa thịt + hải sản + nem + rau\n• <b>Combo gia đình</b> ~750.000đ: full menu nướng\nĐơn ≥ 500.000đ được <b>giảm 10%</b> tự động! 🎉'
            },
            {
                keys: ['mới nhất', 'món mới', 'mới ra', 'mới có'],
                reply: '✨ Món mới nhất tại GrillHouse:\n• <b>Sườn heo nướng BBQ</b> – sốt BBQ kiểu Mỹ\n• <b>Gà nướng sa tế</b> – cay nồng đặc trưng\n• <b>Mực nướng bơ tỏi</b> – hải sản tươi ngon\nXem đầy đủ menu tại trang chủ nhé! 🍖'
            },
            {
                keys: ['tra cứu', 'đơn hàng', 'xem đơn', 'kiểm tra đơn', 'mã đơn'],
                reply: '📦 Để tra cứu đơn hàng, bạn vào:\n👉 <b>Tài khoản → Đơn hàng của tôi</b>\nhoặc click <a href="my-orders" style="color:#f97316">vào đây</a> nếu đã đăng nhập.\nCần hỗ trợ thêm? Gọi hotline <b style="color:#f97316">1900 1234</b>'
            },
            {
                keys: ['giờ', 'mở cửa', 'đóng cửa', 'hoạt động'],
                reply: '🕐 Giờ hoạt động:\n• Thứ 2 – Thứ 6: <b>10:00 – 22:00</b>\n• Thứ 7 – Chủ nhật: <b>09:00 – 23:00</b>\nGiao hàng trong vòng 30–45 phút kể từ khi xác nhận đơn. 🛵'
            },
            {
                keys: ['giao hàng', 'ship', 'phí ship', 'vận chuyển'],
                reply: '🛵 Chính sách giao hàng:\n• <b>Miễn phí giao hàng</b> cho tất cả đơn hàng\n• Thời gian giao: <b>30–45 phút</b>\n• Khu vực: nội thành và các quận lân cận\nĐặt hàng ngay tại trang chủ nhé! 🔥'
            },
            {
                keys: ['thanh toán', 'trả tiền', 'cod', 'vnpay', 'momo', 'tiền mặt'],
                reply: '💳 Phương thức thanh toán:\n• 💵 <b>Tiền mặt khi nhận hàng (COD)</b>\n• 🏦 <b>Chuyển khoản VNPay</b>\n• 💜 <b>Ví MoMo</b>\nTất cả đều an toàn và bảo mật! 🔒'
            },
            {
                keys: ['hải sản', 'tôm', 'mực', 'cá', 'bạch tuộc'],
                reply: '🦐 Các món hải sản nướng:\n• <b>Tôm hùm nướng bơ tỏi</b>\n• <b>Mực nướng muối ớt</b>\n• <b>Bạch tuộc nướng sa tế</b>\n• <b>Cá lóc nướng trui</b>\nTất cả đều dùng hải sản tươi ngày, nhập mỗi buổi sáng! 🌊'
            },
            {
                keys: ['thịt bò', 'bò', 'beef'],
                reply: '🥩 Các món thịt bò nướng:\n• <b>Bò nướng lá lốt</b> – thơm ngon chuẩn vị\n• <b>Bò nướng kiểu Hàn</b> – tẩm ướp đặc biệt\n• <b>Bít tết nướng than hoa</b>\nXem đầy đủ tại trang chủ, lọc danh mục "Thịt bò"!'
            },
            {
                keys: ['giảm giá', 'khuyến mãi', 'sale', 'discount', 'voucher', 'coupon'],
                reply: '🎉 Ưu đãi hiện tại:\n• <b>Giảm 10%</b> cho đơn hàng từ 500.000đ trở lên (tự động áp dụng)\n• Các món có nhãn <b>SALE</b> đang giảm giá đặc biệt\n• Follow fanpage để nhận mã voucher mới nhất! 📱'
            },
            {
                keys: ['xin chào', 'hello', 'hi', 'chào', 'hey'],
                reply: '👋 Xin chào! Mình là <b>Chef AI</b> của GrillHouse 🔥\nMình có thể giúp bạn:\n• Tư vấn món ăn phù hợp\n• Thông tin combo, giá cả\n• Chính sách giao hàng, thanh toán\n• Tra cứu đơn hàng\n\nBạn cần tư vấn gì nào? 😊'
            },
            {
                keys: ['cảm ơn', 'thanks', 'thank', 'tks'],
                reply: '😊 Không có gì! GrillHouse luôn sẵn sàng phục vụ bạn.\nChúc bạn có bữa ăn ngon miệng! 🔥🥩\nNếu cần thêm hỗ trợ, cứ nhắn tin nhé!'
            }
        ];

        const DEFAULT_REPLY = '🤔 Xin lỗi, mình chưa hiểu câu hỏi của bạn.\nBạn có thể hỏi về:\n• Tư vấn món ăn\n• Combo & giá cả\n• Giao hàng & thanh toán\n• Tra cứu đơn hàng\nHoặc gọi hotline <b style="color:#f97316">1900 1234</b> để được hỗ trợ trực tiếp!';

        let isOpen = false;
        let greeted = false;

        window.toggleChat = function () {
            isOpen = !isOpen;
            const win = document.getElementById('chat-window');
            const badge = document.getElementById('chat-badge');
            win.classList.toggle('open', isOpen);
            badge.style.display = 'none';
            if (isOpen && !greeted) {
                greeted = true;
                setTimeout(() => {
                    const name = '${not empty sessionScope.account ? sessionScope.account.fullName : "bạn"}';
                    addMsg('bot', '👋 Xin chào <b>' + name + '</b>! Mình là <b>Chef AI</b> của GrillHouse 🔥<br>Mình có thể tư vấn món ăn, combo, chính sách giao hàng và tra cứu đơn hàng cho bạn. Bạn cần hỗ trợ gì?');
                }, 300);
            }
        };

        window.sendQuick = function (text) {
            sendMsg(text);
        };

        window.sendMessage = function () {
            const input = document.getElementById('chat-input');
            const text = input.value.trim();
            if (!text)
                return;
            input.value = '';
            sendMsg(text);
        };

        function sendMsg(text) {
            addMsg('user', text);
            document.getElementById('cw-quick').style.display = 'none';
            setTimeout(() => {
                const reply = getReply(text.toLowerCase());
                addMsg('bot', reply);
            }, 600);
        }

        function getReply(text) {
            for (const item of KB) {
                if (item.keys.some(k => text.includes(k)))
                    return item.reply;
            }
            return DEFAULT_REPLY;
        }

        function addMsg(type, html) {
            const container = document.getElementById('cw-messages');
            const wrapper = document.createElement('div');
            wrapper.className = 'msg ' + type;

            if (type === 'bot') {
                wrapper.innerHTML =
                        '<div class="msg-avatar">🧑‍🍳</div>' +
                        '<div class="msg-bubble">' + html.replace(/\n/g, '<br>') + '</div>';
            } else {
                wrapper.innerHTML =
                        '<div class="msg-bubble">' + escHtml(html) + '</div>';
            }

            container.appendChild(wrapper);
            container.scrollTop = container.scrollHeight;
        }

        function escHtml(str) {
            return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }

        // Hiện badge sau 3s nếu chưa mở
        setTimeout(() => {
            if (!isOpen) {
                const badge = document.getElementById('chat-badge');
                badge.style.display = 'flex';
            }
        }, 3000);
    })();
</script>
<!-- ========== END CHATBOT ========== -->