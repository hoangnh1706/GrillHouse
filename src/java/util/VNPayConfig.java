package util;

public class VNPayConfig {

    // ===== ĐỔI 2 GIÁ TRỊ NÀY SAU KHI ĐĂNG KÝ SANDBOX =====
    public static final String TMN_CODE   = "YOUR_TMN_CODE";      // VD: "DEMOV201"
    public static final String HASH_SECRET= "YOUR_HASH_SECRET";   // VD: "RAOEXHYVSDDIIENYWSLDIIZTANXUXZFJ"
    // =========================================================

    public static final String PAY_URL    = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String RETURN_URL = "http://localhost:8080/FoodStore/vnpay/return";
    public static final String API_VERSION= "2.1.0";
    public static final String COMMAND    = "pay";
    public static final String CURR_CODE  = "VND";
    public static final String LOCALE     = "vn";
    public static final String ORDER_TYPE = "other";
}