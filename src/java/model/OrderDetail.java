package model;

import java.math.BigDecimal;

public class OrderDetail {
    private int        orderDetailID;
    private int        orderID;
    private int        productID;
    private String     productName;  // join từ Product
    private String     imageURL;     // join từ Product
    private int        quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;     // computed: quantity * unitPrice

    public OrderDetail() {}

    public OrderDetail(int productID, String productName,
                       int quantity, BigDecimal unitPrice) {
        this.productID   = productID;
        this.productName = productName;
        this.quantity    = quantity;
        this.unitPrice   = unitPrice;
        this.subtotal    = unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public int        getOrderDetailID()             { return orderDetailID; }
    public void       setOrderDetailID(int v)        { this.orderDetailID = v; }
    public int        getOrderID()                   { return orderID; }
    public void       setOrderID(int v)              { this.orderID = v; }
    public int        getProductID()                 { return productID; }
    public void       setProductID(int v)            { this.productID = v; }
    public String     getProductName()               { return productName; }
    public void       setProductName(String v)       { this.productName = v; }
    public String     getImageURL()                  { return imageURL; }
    public void       setImageURL(String v)          { this.imageURL = v; }
    public int        getQuantity()                  { return quantity; }
    public void       setQuantity(int v)             { this.quantity = v; }
    public BigDecimal getUnitPrice()                 { return unitPrice; }
    public void       setUnitPrice(BigDecimal v)     { this.unitPrice = v; }
    public BigDecimal getSubtotal()                  { return subtotal; }
    public void       setSubtotal(BigDecimal v)      { this.subtotal = v; }
}