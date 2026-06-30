package util;

public class VNPayConfig {

    // ===== ĐỔI 2 GIÁ TRỊ NÀY SAU KHI ĐĂNG KÝ SANDBOX =====
    public static final String TMN_CODE   = "ZLQASVM8";      // VD: "DEMOV201"
    public static final String HASH_SECRET= "J1QY9SU5DFURAQEH1GFM2ZW1L7G971WC";   // VD: "RAOEXHYVSDDIIENYWSLDIIZTANXUXZFJ"
    // =========================================================

    public static final String PAY_URL    = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String RETURN_URL = "http://localhost:8888/GrillHouse/vnpay/return";   
    public static final String API_VERSION= "2.1.0";
    public static final String COMMAND    = "pay";
    public static final String CURR_CODE  = "VND";
    public static final String LOCALE     = "vn";
    public static final String ORDER_TYPE = "other";
}