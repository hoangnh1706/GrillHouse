package dal;

import java.sql.*;
import java.util.Properties;

public class DBContext {

    // ---- Cấu hình kết nối ----
    private static final String SERVER   = "localhost";
    private static final int    PORT     = 1433;
    private static final String DATABASE = "FoodStoreDB";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "sa";

    // URL dùng cho sqljdbc42 (driver cũ) — KHÔNG thêm encrypt/trustServerCertificate vào URL
    private static final String URL =
        "jdbc:sqlserver://" + SERVER + ":" + PORT
        + ";databaseName=" + DATABASE
        + ";encrypt=false";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBContext] Khong tim thay JDBC Driver: " + e.getMessage());
        }
    }

    /**
     * Lấy một Connection mới từ DriverManager.
     * Gọi xong phải close() trong finally hoặc try-with-resources.
     */
    public Connection getConnection() throws SQLException {
        Properties props = new Properties();
        props.setProperty("user",     USERNAME);
        props.setProperty("password", PASSWORD);
        // Tắt SSL cho sqljdbc42 cũ — nếu dùng driver mới hơn thì đổi thành true
        props.setProperty("encrypt",                "false");
        props.setProperty("trustServerCertificate", "true");
        return DriverManager.getConnection(URL, props);
    }

    // ---- Test kết nối ----
    public static void main(String[] args) {
        System.out.println("Dang ket noi toi: " + URL);
        try (Connection conn = new DBContext().getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("=========================================");
                System.out.println("KET NOI DATABASE THANH CONG!");
                System.out.println("Catalog: " + conn.getCatalog());
                System.out.println("=========================================");
            }
        } catch (SQLException e) {
            System.err.println("LOI KET NOI: " + e.getMessage());
            System.err.println("SQLState : " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
        }
    }
}
