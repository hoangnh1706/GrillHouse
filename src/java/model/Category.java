package model;

public class Category {
    private int    categoryID;
    private String categoryName;
    private String description;
    private String imageURL;
    private boolean isActive;
    private int    sortOrder;

    public Category() {}

    public Category(int categoryID, String categoryName, String description,
                    String imageURL, boolean isActive, int sortOrder) {
        this.categoryID   = categoryID;
        this.categoryName = categoryName;
        this.description  = description;
        this.imageURL     = imageURL;
        this.isActive     = isActive;
        this.sortOrder    = sortOrder;
    }

    public int     getCategoryID()             { return categoryID; }
    public void    setCategoryID(int v)        { this.categoryID = v; }
    public String  getCategoryName()           { return categoryName; }
    public void    setCategoryName(String v)   { this.categoryName = v; }
    public String  getDescription()            { return description; }
    public void    setDescription(String v)    { this.description = v; }
    public String  getImageURL()               { return imageURL; }
    public void    setImageURL(String v)       { this.imageURL = v; }
    public boolean isActive()                  { return isActive; }
    public void    setActive(boolean v)        { this.isActive = v; }
    public int     getSortOrder()              { return sortOrder; }
    public void    setSortOrder(int v)         { this.sortOrder = v; }
}