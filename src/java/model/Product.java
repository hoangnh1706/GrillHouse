package model;

import java.math.BigDecimal;
import java.util.Date;

public class Product {
    private int        productID;
    private int        categoryID;
    private String     categoryName;   // join từ bảng Category (tiện dùng ở View)
    private String     productName;
    private String     description;
    private BigDecimal price;
    private BigDecimal salePrice;      // null = không khuyến mãi
    private String     imageURL;
    private int        stock;
    private boolean    isFeatured;
    private boolean    isActive;
    private Date       createdAt;
    private double     avgRating;      // tính từ bảng Review
    private int        reviewCount;

    public Product() {}

    // Getters & Setters
    public int        getProductID()              { return productID; }
    public void       setProductID(int v)         { this.productID = v; }
    public int        getCategoryID()             { return categoryID; }
    public void       setCategoryID(int v)        { this.categoryID = v; }
    public String     getCategoryName()           { return categoryName; }
    public void       setCategoryName(String v)   { this.categoryName = v; }
    public String     getProductName()            { return productName; }
    public void       setProductName(String v)    { this.productName = v; }
    public String     getDescription()            { return description; }
    public void       setDescription(String v)    { this.description = v; }
    public BigDecimal getPrice()                  { return price; }
    public void       setPrice(BigDecimal v)      { this.price = v; }
    public BigDecimal getSalePrice()              { return salePrice; }
    public void       setSalePrice(BigDecimal v)  { this.salePrice = v; }
    public String     getImageURL()               { return imageURL; }
    public void       setImageURL(String v)       { this.imageURL = v; }
    public int        getStock()                  { return stock; }
    public void       setStock(int v)             { this.stock = v; }
    public boolean    isFeatured()                { return isFeatured; }
    public void       setFeatured(boolean v)      { this.isFeatured = v; }
    public boolean    isActive()                  { return isActive; }
    public void       setActive(boolean v)        { this.isActive = v; }
    public Date       getCreatedAt()              { return createdAt; }
    public void       setCreatedAt(Date v)        { this.createdAt = v; }
    public double     getAvgRating()              { return avgRating; }
    public void       setAvgRating(double v)      { this.avgRating = v; }
    public int        getReviewCount()            { return reviewCount; }
    public void       setReviewCount(int v)       { this.reviewCount = v; }

    /** Trả về giá hiển thị: salePrice nếu có KM, không thì price */
    public BigDecimal getDisplayPrice() {
        return (salePrice != null) ? salePrice : price;
    }

    /** Kiểm tra còn hàng không */
    public boolean isInStock() {
        return stock > 0;
    }
}