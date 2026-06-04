package model;

import java.math.BigDecimal;
import java.util.*;

/**
 * CartItem - 1 dòng trong giỏ hàng
 */
class CartItem {
    private int        productID;
    private String     productName;
    private String     imageURL;
    private BigDecimal unitPrice;
    private int        quantity;

    public CartItem(int productID, String productName,
                    String imageURL, BigDecimal unitPrice, int quantity) {
        this.productID   = productID;
        this.productName = productName;
        this.imageURL    = imageURL;
        this.unitPrice   = unitPrice;
        this.quantity    = quantity;
    }

    public BigDecimal getSubtotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public int        getProductID()              { return productID; }
    public String     getProductName()            { return productName; }
    public String     getImageURL()               { return imageURL; }
    public BigDecimal getUnitPrice()              { return unitPrice; }
    public int        getQuantity()               { return quantity; }
    public void       setQuantity(int v)          { this.quantity = v; }
}

