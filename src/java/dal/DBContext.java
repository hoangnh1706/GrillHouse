package dal;

import java.sql.*;

public class DBContext {
    private static final String URL      = "jdbc:sqlserver://localhost:1433;databaseName=FoodStoreDB;encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "sa";

    static {
        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    // Hàm main để test kết nối trực tiếp
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            
            if (conn != null && !conn.isClosed()) {
                System.out.println("\n=========================================");
                System.out.println("🎉 CHÚC MỪNG: KẾT NỐI DATABASE THÀNH CÔNG !!!");
                System.out.println("=========================================");
                conn.close();
            } else {
                System.out.println("\n❌ KẾT NỐI THẤT BẠI: Connection bị null!");
            }
        } catch (Exception e) {
            System.out.println("\n❌ LỖI KẾT NỐI ĐẾN DATABASE VÌ:");
            e.printStackTrace(); // In ra chi tiết nguyên nhân lỗi
        }
    }
}
