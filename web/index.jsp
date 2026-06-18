<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>GrillHouse &ndash; Nướng Chuẩn Vị, Giao Tận Nơi</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,900;1,700&family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/index.css">
    </head>

    <body>

        <nav>
            <div class="nav-logo">&#128293; GrillHouse</div>
            <div class="nav-links">
                <a href="#features">Tính năng</a>
                <a href="#menu">Thực đơn</a>
                <a href="#how">Cách đặt</a>
                <a href="home" class="nav-btn">Đặt món ngay</a>
            </div>
        </nav>

        <section class="hero">
            <div class="hero-bg"></div>
            <div class="hero-inner">
                <div>
                    <div class="hero-tag"><span class="tag-dot"></span> Đặt món trực tuyến &middot; Giao tận nơi</div>
                    <h1 class="hero-title">
                        Thịt Nướng
                        <span class="fire-word">Chuẩn Vị</span>
                        <span class="italic-word">GrillHouse</span>
                    </h1>
                    <p class="hero-desc">Vịt nướng, sườn BBQ, hải sản tươi &mdash; đặt online trong 30 giây, giao tận
                        tay trong 45 phút. Hương vị đích thực từ bếp lửa than hoa.</p>
                    <div class="hero-cta">
                        <a href="home" class="btn-primary">&#128293; Xem thực đơn</a>
                        <a href="#how" class="btn-outline">&#9654; Cách đặt món</a>
                    </div>
                    <div class="hero-stats">
                        <div class="stat-box">
                            <div class="stat-num">50+</div>
                            <div class="stat-lbl">Món ăn</div>
                        </div>
                        <div class="stat-box">
                            <div class="stat-num">45'</div>
                            <div class="stat-lbl">Giao hàng</div>
                        </div>
                        <div class="stat-box">
                            <div class="stat-num">4.9 &#11088;</div>
                            <div class="stat-lbl">Đánh giá</div>
                        </div>
                        <div class="stat-box">
                            <div class="stat-num">24/7</div>
                            <div class="stat-lbl">Phục vụ</div>
                        </div>
                    </div>
                </div>
                <div class="hero-visual">
                    <div class="fire-ring">
                        <div class="fire-emoji">&#127859;</div>
                    </div>
                </div>
            </div>
        </section>

        <div class="divider"></div>

        <section id="features">
            <div class="section-inner">
                <div class="section-tag">Tại sao chọn chúng tôi</div>
                <h2 class="section-title">Trải nghiệm đặt món <em>hoàn toàn mới</em></h2>
                <p class="section-sub">Hệ thống đặt hàng thông minh, thanh toán an toàn, theo dõi đơn hàng real-time.
                </p>
                <div class="features-grid">
                    <div class="feat-card">
                        <div class="feat-icon">&#128722;</div>
                        <div class="feat-title">Giỏ hàng thông minh</div>
                        <div class="feat-desc">Thêm món, điều chỉnh số lượng, tự động giảm 10% cho đơn từ 500.000đ.
                        </div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">&#128179;</div>
                        <div class="feat-title">Thanh toán VNPay</div>
                        <div class="feat-desc">Tích hợp VNPay bảo mật &mdash; thẻ ATM, Visa, MasterCard, QR Code.</div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">&#128230;</div>
                        <div class="feat-title">Theo dõi đơn hàng</div>
                        <div class="feat-desc">Xem trạng thái real-time: chờ xác nhận &rarr; đang giao &rarr; hoàn
                            thành.</div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">&#9881;</div>
                        <div class="feat-title">Trang quản trị Admin</div>
                        <div class="feat-desc">Dashboard đầy đủ: quản lý thực đơn, xử lý đơn hàng, thống kê.</div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">&#128274;</div>
                        <div class="feat-title">Bảo mật tài khoản</div>
                        <div class="feat-desc">Mật khẩu mã hóa SHA-256, phân quyền rõ ràng Admin &amp; Khách hàng.</div>
                    </div>
                    <div class="feat-card">
                        <div class="feat-icon">&#128241;</div>
                        <div class="feat-title">Giao diện responsive</div>
                        <div class="feat-desc">Tối ưu trên mọi thiết bị &mdash; máy tính, tablet và điện thoại.</div>
                    </div>
                </div>
            </div>
        </section>

        <div class="divider"></div>

        <section class="menu-section" id="menu">
            <div class="section-inner">
                <div class="menu-header">
                    <div>
                        <div class="section-tag">Thực đơn nổi bật</div>
                        <h2 class="section-title">Món <em>đặc sản</em></h2>
                    </div>
                    <a href="home" class="btn-outline" style="font-size:.85rem;padding:.6rem 1.3rem;">Xem tất cả
                        &rarr;</a>
                </div>
                <div class="menu-grid">
                    <div class="menu-card">
                        <div class="menu-thumb"><img src="images/vitnuong.jpg" alt="Vịt nướng mắm gừng"
                                style="width:100%;height:150px;object-fit:cover;display:block;"></div>
                        <div class="menu-body">
                            <div class="menu-cat">Vịt nướng</div>
                            <div class="menu-name">Vịt nướng mắm gừng (&#189; con)</div>
                            <div class="menu-footer"><span class="menu-price">185.000đ</span><span
                                    class="badge badge-hot">HOT</span></div>
                        </div>
                    </div>
                    <div class="menu-card">
                        <div class="menu-thumb"><img src="images/suonnuong.jpeg" alt="Sườn heo nướng BBQ"
                                style="width:100%;height:150px;object-fit:cover;display:block;"></div>
                        <div class="menu-body">
                            <div class="menu-cat">Thịt nướng</div>
                            <div class="menu-name">Sườn heo nướng BBQ</div>
                            <div class="menu-footer"><span class="menu-price">145.000đ</span><span
                                    class="badge badge-hot">HOT</span></div>
                        </div>
                    </div>
                    <div class="menu-card">
                        <div class="menu-thumb"><img src="images/tom-nuong-muoi-ot.jpg" alt="Tôm sú nướng muối ớt"
                                style="width:100%;height:150px;object-fit:cover;display:block;"></div>
                        <div class="menu-body">
                            <div class="menu-cat">Hải sản</div>
                            <div class="menu-name">Tôm sú nướng muối ớt</div>
                            <div class="menu-footer"><span class="menu-price">220.000đ</span><span
                                    class="badge badge-new">MỚI</span></div>
                        </div>
                    </div>
                    <div class="menu-card">
                        <div class="menu-thumb"><img src="images/combo4nguoi.png" alt="Combo Gia Đình"
                                style="width:100%;height:150px;object-fit:cover;display:block;"></div>
                        <div class="menu-body">
                            <div class="menu-cat">Combo</div>
                            <div class="menu-name">Combo Gia Đình (4 người)</div>
                            <div class="menu-footer"><span class="menu-price"
                                    style="color:var(--gold)">620.000đ</span><span class="badge badge-sale">-10%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="divider"></div>

        <section id="how">
            <div class="section-inner">
                <div style="text-align:center">
                    <div class="section-tag">Quy trình</div>
                </div>
                <h2 class="section-title" style="text-align:center">Đặt món chỉ <em>3 bước đơn giản</em></h2>
                <div class="how-grid">
                    <div class="step">
                        <div class="step-num">01</div>
                        <div class="step-title">Chọn món yêu thích</div>
                        <div class="step-desc">Duyệt thực đơn theo danh mục, tìm kiếm theo tên, thêm vào giỏ hàng.</div>
                    </div>
                    <div class="step">
                        <div class="step-num">02</div>
                        <div class="step-title">Nhập địa chỉ &amp; thanh toán</div>
                        <div class="step-desc">Điền địa chỉ giao hàng, chọn COD hoặc thanh toán VNPay an toàn.</div>
                    </div>
                    <div class="step">
                        <div class="step-num">03</div>
                        <div class="step-title">Nhận món tại nhà</div>
                        <div class="step-desc">Theo dõi đơn real-time. Shipper giao tận nơi trong vòng 45 phút.</div>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-section">
            <div class="cta-glow"></div>
            <h2 class="cta-title">Sẵn sàng<br><span>đặt món?</span></h2>
            <p class="cta-sub">Hàng trăm món nướng ngon đang chờ bạn. Đặt ngay hôm nay.</p>
            <div class="cta-btns">
                <a href="home" class="btn-primary" style="font-size:1rem;padding:.9rem 2.2rem;">&#128293; Đặt món
                    ngay</a>
                <a href="home" class="btn-outline" style="font-size:1rem;padding:.9rem 1.8rem;">Xem thực đơn &rarr;</a>
            </div>
        </section>

        <footer class="site-footer">
            <div class="footer-grid">
                <!-- Cột 1: Branding -->
                <div class="footer-brand">
                    <div class="footer-brand-logo">
                        <span>&#128293;</span>
                        <span>GrillHouse</span>
                    </div>
                    <p>Hương vị đích thực từ bếp lửa than hoa. Giao tận tay món ngon chuẩn vị trong 45 phút.</p>
                </div>
                <!-- Cột 2: Khám phá -->
                <div class="footer-col">
                    <h3>KHÁM PHÁ</h3>
                    <ul>
                        <li><a href="home">Thực đơn đặc biệt</a></li>
                        <li><a href="home#menu">Combo nhóm</a></li>
                        <li><a href="home">Ưu đãi thành viên</a></li>
                    </ul>
                </div>
                <!-- Cột 3: Hỗ trợ -->
                <div class="footer-col">
                    <h3>HỖ TRỢ</h3>
                    <ul>
                        <li><a href="home">Hướng dẫn đặt hàng</a></li>
                        <li><a href="#">Chính sách vận chuyển</a></li>
                        <li><a href="#">Khiếu nại &amp; Góp ý</a></li>
                    </ul>
                </div>
                <!-- Cột 4: Liên hệ -->
                <div class="footer-col">
                    <h3>LIÊN HỆ</h3>
                    <p>Hotline: <span class="hotline"> 0867463611 </span></p>
                    <p>Email: cookwithHoang@grillhouse.vn</p>
                </div>
            </div>
            <div class="footer-bottom">
                &copy; 2026 GrillHouse. Tất cả các quyền được bảo lưu. &middot; Đồ án Java Web &middot; MVC2 &middot;
                SQL Server
            </div>
        </footer>

    </body>

    </html>