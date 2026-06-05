package controller;

import model.Cart;
import util.VNPayConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/vnpay/pay")
public class VNPayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Thông tin giao hàng đã được CheckoutServlet lưu vào session
        // (pendingShipAddress, pendingPhone, pendingNote)

        // Số tiền (VNPay yêu cầu nhân 100, đơn vị VND)
        long amount = cart.getFinalTotal().longValue() * 100L;

        // Tạo mã đơn hàng tạm (txnRef) — dùng timestamp
        String txnRef = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                + "_" + session.getId().substring(0, 6);
        session.setAttribute("pendingTxnRef", txnRef);

        // Build tham số VNPay (phải sort theo alphabet)
        Map<String, String> params = new TreeMap<>();
        params.put("vnp_Version", VNPayConfig.API_VERSION);
        params.put("vnp_Command", VNPayConfig.COMMAND);
        params.put("vnp_TmnCode", VNPayConfig.TMN_CODE);
        params.put("vnp_Amount", String.valueOf(amount));
        params.put("vnp_CurrCode", VNPayConfig.CURR_CODE);
        params.put("vnp_TxnRef", txnRef);
        params.put("vnp_OrderInfo", "Thanh toan don hang " + txnRef);
        params.put("vnp_OrderType", VNPayConfig.ORDER_TYPE);
        params.put("vnp_Locale", VNPayConfig.LOCALE);
        params.put("vnp_ReturnUrl", VNPayConfig.RETURN_URL);
        params.put("vnp_IpAddr", getClientIp(req));
        params.put("vnp_CreateDate", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));

        // Tạo chuỗi hash data
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> e : params.entrySet()) {
            String encodedKey = URLEncoder.encode(e.getKey(), StandardCharsets.UTF_8);
            String encodedVal = URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8);
            // hashData dùng RAW value theo đúng chuẩn VNPay
            hashData.append(e.getKey()).append("=").append(e.getValue()).append("&");
            // query dùng encoded value để build URL
            query.append(encodedKey).append("=").append(encodedVal).append("&");
        }
        // Bỏ dấu & cuối
        hashData.deleteCharAt(hashData.length() - 1);
        query.deleteCharAt(query.length() - 1);

        // Ký HMAC-SHA512
        String secureHash = hmacSha512(VNPayConfig.HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);

        // Redirect sang VNPay
        resp.sendRedirect(VNPayConfig.PAY_URL + "?" + query);
    }

    // ---- helpers ----

    private String hmacSha512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes)
                sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("HMAC-SHA512 error", e);
        }
    }

    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty())
            ip = req.getRemoteAddr();
        return ip.contains(",") ? ip.split(",")[0].trim() : ip;
    }
}
