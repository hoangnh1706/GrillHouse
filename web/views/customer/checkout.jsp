<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <title>Thanh toán - BepNuong</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;500;600&display=swap"
          rel="stylesheet">
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            background: #111;
            color: #e5e5e5;
            font-family: 'DM Sans', sans-serif;
          }

          .container {
            max-width: 960px;
            margin: 2rem auto;
            padding: 0 1.5rem;
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
          }

          @media(max-width:768px) {
            .container {
              grid-template-columns: 1fr;
            }
          }

          .card {
            background: #1c1c1c;
            border: 1px solid #2a2a2a;
            border-radius: 14px;
            padding: 1.5rem;
          }

          .card h2 {
            font-size: 1rem;
            color: #aaa;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .5px;
            margin-bottom: 1.2rem;
          }

          label {
            display: block;
            font-size: .85rem;
            color: #999;
            margin-bottom: .35rem;
            font-weight: 500;
          }

          input,
          select,
          textarea {
            width: 100%;
            padding: .7rem 1rem;
            background: #252525;
            border: 1.5px solid #333;
            border-radius: 8px;
            color: #eee;
            font-size: .95rem;
            font-family: inherit;
            outline: none;
            transition: border .2s;
            margin-bottom: 1.1rem;
          }

          input:focus,
          select:focus,
          textarea:focus {
            border-color: #f97316;
          }

          textarea {
            resize: vertical;
            min-height: 80px;
          }

          select option {
            background: #252525;
          }

          .error {
            background: #3b1a1a;
            border: 1px solid #7f1d1d;
            color: #fca5a5;
            border-radius: 8px;
            padding: .75rem 1rem;
            font-size: .88rem;
            margin-bottom: 1.2rem;
          }

          .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: .6rem 0;
            border-bottom: 1px solid #222;
            font-size: .9rem;
          }

          .order-item:last-child {
            border: none;
          }

          .item-name {
            color: #ddd;
          }

          .item-qty {
            color: #777;
            font-size: .82rem;
          }

          .item-price {
            color: #f97316;
            font-weight: 600;
          }

          .summary-line {
            display: flex;
            justify-content: space-between;
            padding: .5rem 0;
            color: #aaa;
            font-size: .9rem;
          }

          .summary-total {
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #2a2a2a;
            padding-top: .75rem;
            margin-top: .5rem;
            font-size: 1.2rem;
            font-weight: 700;
            color: #f97316;
          }

          .discount-badge {
            background: #14532d;
            color: #86efac;
            font-size: .78rem;
            padding: .2rem .5rem;
            border-radius: 4px;
            margin-left: .4rem;
          }

          .btn-submit {
            width: 100%;
            padding: .9rem;
            background: #f97316;
            border: none;
            border-radius: 10px;
            color: #fff;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            transition: background .2s;
            margin-top: 1.2rem;
          }

          .btn-submit:hover {
            background: #ea6a05;
          }

          .pay-opts {
            display: flex;
            flex-direction: column;
            gap: .6rem;
            margin-bottom: 1.1rem;
          }

          .pay-opt {
            display: flex;
            align-items: center;
            gap: .75rem;
            background: #252525;
            border: 1.5px solid #333;
            border-radius: 8px;
            padding: .65rem 1rem;
            cursor: pointer;
            transition: border .2s;
          }

          .pay-opt.selected {
            border-color: #f97316;
            background: #2d1800;
          }

          .pay-opt input {
            width: auto;
            margin: 0;
            accent-color: #f97316;
          }

          .pay-opt span {
            font-size: .9rem;
          }
        </style>
      </head>

      <body>
        <%@ include file="/views/common/header.jsp" %>

          <div style="max-width:960px;margin:2rem auto;padding:0 1.5rem;">
            <h1 style="font-family:'Playfair Display',serif;color:#f97316;font-size:1.8rem;margin-bottom:1.5rem;">
              Thanh toan
            </h1>
            <c:if test="${not empty error}">
              <div class="error">&#9888; ${error}</div>
            </c:if>
          </div>

          <div class="container" style="margin-top:0;">

            <!-- Form thong tin giao hang -->
            <form action="${pageContext.request.contextPath}/checkout" method="post">
              <div class="card">
                <h2>Thong tin giao hang</h2>

                <label>Ho va ten nguoi nhan</label>
                <input type="text" name="receiverName" value="${sessionScope.account.fullName}" required>

                <label>So dien thoai *</label>
                <input type="tel" name="phone" value="${sessionScope.account.phone}" placeholder="0901234567" required>

                <label>Dia chi giao hang *</label>
                <input type="text" name="shipAddress" value="${sessionScope.account.address}"
                  placeholder="So nha, duong, phuong, quan..." required>

                <label>Ghi chu (tuy chon)</label>
                <textarea name="note" placeholder="Vi du: Goi truoc 10 phut, khong cay..."></textarea>

                <h2 style="margin-top:.5rem;">Phuong thuc thanh toan</h2>
                <div class="pay-opts">
                  <label class="pay-opt selected">
                    <input type="radio" name="paymentMethod" value="Tien mat" checked>
                    <span>Thanh toan khi nhan hang (COD)</span>
                  </label>
                  <label class="pay-opt">
                    <input type="radio" name="paymentMethod" value="VNPay">
                    <span>Chuyen khoan VNPay</span>
                  </label>
                  <label class="pay-opt">
                    <input type="radio" name="paymentMethod" value="Momo">
                    <span>Vi MoMo</span>
                  </label>
                </div>

                <button type="submit" class="btn-submit">Xac nhan dat hang</button>
              </div>
            </form>

            <!-- Tom tat don hang -->
            <div>
              <div class="card">
                <h2>Don hang cua ban</h2>
                <c:forEach var="item" items="${sessionScope.cart.items}">
                  <div class="order-item">
                    <div>
                      <div class="item-name">${item.productName}</div>
                      <div class="item-qty">x${item.quantity}</div>
                    </div>
                    <div class="item-price">
                      <fmt:formatNumber value="${item.subtotal}" pattern="#,###" />d
                    </div>
                  </div>
                </c:forEach>

                <div style="margin-top:.75rem;">
                  <div class="summary-line">
                    <span>Tam tinh</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.total}" pattern="#,###" />d
                    </span>
                  </div>
                  <c:if test="${sessionScope.cart.discount > 0}">
                    <div class="summary-line" style="color:#86efac;">
                      <span>Giam gia 10% <span class="discount-badge">-10%</span></span>
                      <span>-
                        <fmt:formatNumber value="${sessionScope.cart.discount}" pattern="#,###" />d
                      </span>
                    </div>
                  </c:if>
                  <div class="summary-line">
                    <span>Phi giao hang</span>
                    <span style="color:#86efac;">Mien Phi</span>
                  </div>
                  <div class="summary-total">
                    <span>Tong cong</span>
                    <span>
                      <fmt:formatNumber value="${sessionScope.cart.finalTotal}" pattern="#,###" />d
                    </span>
                  </div>
                </div>
              </div>

              <div style="margin-top:1rem;color:#555;font-size:.82rem;line-height:1.6;padding:0 .25rem;">
                Thong tin cua ban duoc bao mat an toan.<br>
                Hotline: <span style="color:#f97316;">1900 1234</span>
              </div>
            </div>

          </div>

          <script>
            // Highlight payment option khi chon
            var opts = document.querySelectorAll('.pay-opt');
            for (var i = 0; i < opts.length; i++) {
              opts[i].addEventListener('click', function () {
                for (var j = 0; j < opts.length; j++) {
                  opts[j].classList.remove('selected');
                }
                this.classList.add('selected');
              });
            }
          </script>
      </body>

      </html>