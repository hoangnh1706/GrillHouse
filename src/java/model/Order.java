package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    // Trạng thái đơn hàng
    public static final int STATUS_PENDING   = 0; // Chờ xác nhận
    public static final int STATUS_CONFIRMED = 1; // Đã xác nhận
    public static final int STATUS_SHIPPING  = 2; // Đang giao
    public static final int STATUS_DONE      = 3; // Hoàn thành
    public static final int STATUS_CANCELLED = 4; // Đã hủy

    private int        orderID;
    private int        accountID;
    private String     customerName;   // join từ Account
    private String     productName;
    private Date       orderDate;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;    // computed: totalAmount - discountAmount
    private String     shipAddress;
    private String     phone;
    private String     note;
    private int        status;
    private String     paymentMethod;
    private boolean    isPaid;
    private List<OrderDetail> details; // danh sách chi tiết

    public Order() {
        this.discountAmount = BigDecimal.ZERO;
        this.totalAmount    = BigDecimal.ZERO;
    }

    /** Tên trạng thái tiếng Việt để hiển thị trên JSP */
    public String getStatusLabel() {
        switch (status) {
            case STATUS_PENDING:   return "Chờ xác nhận";
            case STATUS_CONFIRMED: return "Đã xác nhận";
            case STATUS_SHIPPING:  return "Đang giao";
            case STATUS_DONE:      return "Hoàn thành";
            case STATUS_CANCELLED: return "Đã hủy";
            default:               return "Không xác định";
        }
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    
    public int        getOrderID()                  { return orderID; }
    public void       setOrderID(int v)             { this.orderID = v; }
    public int        getAccountID()                { return accountID; }
    public void       setAccountID(int v)           { this.accountID = v; }
    public String     getCustomerName()             { return customerName; }
    public void       setCustomerName(String v)     { this.customerName = v; }
    public Date       getOrderDate()                { return orderDate; }
    public void       setOrderDate(Date v)          { this.orderDate = v; }
    public BigDecimal getTotalAmount()              { return totalAmount; }
    public void       setTotalAmount(BigDecimal v)  { this.totalAmount = v; }
    public BigDecimal getDiscountAmount()           { return discountAmount; }
    public void       setDiscountAmount(BigDecimal v){ this.discountAmount = v; }
    public BigDecimal getFinalAmount()              { return finalAmount; }
    public void       setFinalAmount(BigDecimal v)  { this.finalAmount = v; }
    public String     getShipAddress()              { return shipAddress; }
    public void       setShipAddress(String v)      { this.shipAddress = v; }
    public String     getPhone()                    { return phone; }
    public void       setPhone(String v)            { this.phone = v; }
    public String     getNote()                     { return note; }
    public void       setNote(String v)             { this.note = v; }
    public int        getStatus()                   { return status; }
    public void       setStatus(int v)              { this.status = v; }
    public String     getPaymentMethod()            { return paymentMethod; }
    public void       setPaymentMethod(String v)    { this.paymentMethod = v; }
    public boolean    isPaid()                      { return isPaid; }
    public void       setPaid(boolean v)            { this.isPaid = v; }
    public List<OrderDetail> getDetails()           { return details; }
    public void       setDetails(List<OrderDetail> v){ this.details = v; }
}