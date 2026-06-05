package controller;

import dal.OrderDAO;
import model.*;
import util.VNPayConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/vnpay/return")
public class VNPayReturnServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy toàn bộ tham số VNPay gửi về
        Map<String, String> params = new TreeMap<>();
        for (Map.Entry<String, String[]> e : req.getParameterMap().entrySet()) {
            params.put(e.getKey(), e.getValue()[0]);
        }

        // Tách secure hash ra khỏi params để tính lại
        String receivedHash = params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType"); // bỏ nếu có

        // Tính lại hash từ params còn lại
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> e : params.entrySet()) {
            hashData.append(URLEncoder.encode(e.getKey(),   StandardCharsets.UTF_8))
                    .append("=")
                    .append(URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                    .append("&");
        }
        hashData.deleteCharAt(hashData.length() - 1);
        String computedHash = hmacSha512(VNPayConfig.HASH_SECRET, hashData.toString());

        HttpSession session = req.getSession();
        String responseCode = req.getParameter("vnp_ResponseCode");
        boolean signatureOk = computedHash.equalsIgnoreCase(receivedHash);
        boolean paymentOk   = signatureOk && "00".equals(responseCode);

        if (paymentOk) {
            // Lấy thông tin từ session để tạo đơn hàng
            Account acc         = (Account) session.getAttribute("account");
            Cart    cart        = (Cart)    session.getAttribute("cart");
            String  shipAddress = (String)  session.getAttribute("pendingShipAddress");
            String  phone       = (String)  session.getAttribute("pendingPhone");
            String  note        = (String)  session.getAttribute("pendingNote");

            if (acc != null && cart != null && !cart.isEmpty()) {
                try {
                    Order order = new Order();
                    order.setAccountID(acc.getAccountID());
                    order.setShipAddress(shipAddress);
                    order.setPhone(phone);
                    order.setNote(note);
                    order.setPaymentMethod("VNPay");
                    order.setPaid(true); // đã thanh toán

                    int newOrderID = orderDAO.createOrder(order, cart);

                    // Xóa giỏ hàng + dữ liệu tạm
                    session.removeAttribute("cart");
                    session.removeAttribute("pendingShipAddress");
                    session.removeAttribute("pendingPhone");
                    session.removeAttribute("pendingNote");
                    session.removeAttribute("pendingTxnRef");

                    resp.sendRedirect(req.getContextPath() + "/my-orders?success=" + newOrderID);
                    return;

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // Thanh toán thất bại
        String msg = "00".equals(responseCode) ? "Chữ ký không hợp lệ."
                   : vnpayErrorMessage(responseCode);
        req.setAttribute("vnpayError", msg);
        req.getRequestDispatcher("/views/customer/payment-failed.jsp").forward(req, resp);
    }

    private String vnpayErrorMessage(String code) {
        return switch (code) {
            case "07" -> "Giao dịch bị nghi ngờ gian lận.";
            case "09" -> "Thẻ/tài khoản chưa đăng ký dịch vụ.";
            case "10" -> "Xác thực thẻ sai quá 3 lần.";
            case "11" -> "Hết hạn chờ thanh toán.";
            case "12" -> "Thẻ/tài khoản bị khóa.";
            case "13" -> "Sai mật khẩu OTP.";
            case "24" -> "Khách hàng hủy giao dịch.";
            case "51" -> "Tài khoản không đủ số dư.";
            case "65" -> "Vượt hạn mức giao dịch ngày.";
            case "75" -> "Ngân hàng đang bảo trì.";
            default   -> "Thanh toán thất bại (mã " + code + ").";
        };
    }

    private String hmacSha512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("HMAC error", e);
        }
    }
}