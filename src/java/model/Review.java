package model;
import java.util.Date;

public class Review {
    private int    reviewID;
    private int    productID;
    private int    accountID;
    private String reviewerName;  // join từ Account
    private int    rating;        // 1-5
    private String comment;
    private Date   createdAt;

    public Review() {}

    public int    getReviewID()              { return reviewID; }
    public void   setReviewID(int v)         { this.reviewID = v; }
    public int    getProductID()             { return productID; }
    public void   setProductID(int v)        { this.productID = v; }
    public int    getAccountID()             { return accountID; }
    public void   setAccountID(int v)        { this.accountID = v; }
    public String getReviewerName()          { return reviewerName; }
    public void   setReviewerName(String v)  { this.reviewerName = v; }
    public int    getRating()                { return rating; }
    public void   setRating(int v)           { this.rating = v; }
    public String getComment()               { return comment; }
    public void   setComment(String v)       { this.comment = v; }
    public Date   getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(Date v)       { this.createdAt = v; }
}
