package model;

import java.util.Date;

public class Account {
    private int accountID;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String address;
    private String avatar;
    private boolean isAdmin;
    private boolean isActive;
    private Date createdAt;

    public Account() {}
    
    // (duplicate getCreatedAt/setCreatedAt removed)



    public Account(int accountID, String fullName, String email, String phone,
                   String password, String address, String avatar,
                   boolean isAdmin, boolean isActive) {
        this.accountID = accountID;
        this.fullName  = fullName;
        this.email     = email;
        this.phone     = phone;
        this.password  = password;
        this.address   = address;
        this.avatar    = avatar;
        this.isAdmin   = isAdmin;
        this.isActive  = isActive;
    }

    public int     getAccountID()            { return accountID; }
    public void    setAccountID(int v)       { this.accountID = v; }
    public String  getFullName()             { return fullName; }
    public void    setFullName(String v)     { this.fullName = v; }
    public String  getEmail()                { return email; }
    public void    setEmail(String v)        { this.email = v; }
    public String  getPhone()                { return phone; }
    public void    setPhone(String v)        { this.phone = v; }
    public String  getPassword()             { return password; }
    public void    setPassword(String v)     { this.password = v; }
    public String  getAddress()              { return address; }
    public void    setAddress(String v)      { this.address = v; }
    public String  getAvatar()               { return avatar; }
    public void    setAvatar(String v)       { this.avatar = v; }
    public boolean isAdmin()                 { return isAdmin; }
    public void    setAdmin(boolean v)       { this.isAdmin = v; }
    public boolean isActive()                { return isActive; }
    public void    setActive(boolean v)      { this.isActive = v; }
    public Date    getCreatedAt()            { return createdAt; }
    public void    setCreatedAt(Date v)      { this.createdAt = v; }
}