package controller;

import dal.AccountDAO;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/auth/google")
public class GoogleAuthServlet extends HttpServlet {

    // ===== ĐỔI CLIENT_ID NÀY =====
    private static final String CLIENT_ID = "274105902558-mgec9fp2152p1e8b7ceb1rg56geoahg3.apps.googleusercontent.com";
    // ==============================

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String credential = req.getParameter("credential");

        if (credential == null || credential.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=google_empty");
            return;
        }

        try {
            // Verify token bằng cách gọi Google's tokeninfo endpoint
            String tokenInfoUrl = "https://oauth2.googleapis.com/tokeninfo?id_token=" + credential;
            URL url = new URL(tokenInfoUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                resp.sendRedirect(req.getContextPath() + "/login?error=google_invalid");
                return;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            String tokenInfo = response.toString();

            // Parse JSON response đơn giản
            String email = extractJsonField(tokenInfo, "email");
            String name = extractJsonField(tokenInfo, "name");
            String picture = extractJsonField(tokenInfo, "picture");
            String aud = extractJsonField(tokenInfo, "aud");

            // Verify audience
            if (!CLIENT_ID.equals(aud)) {
                resp.sendRedirect(req.getContextPath() + "/login?error=google_invalid");
                return;
            }

            System.out.println("[GoogleAuth] email=" + email + " name=" + name);

            // Kiểm tra email đã tồn tại trong DB chưa
            Account acc = accountDAO.findByEmail(email);

            if (acc == null) {
                // Lần đầu đăng nhập Google → tự động tạo tài khoản
                Account newAcc = new Account();
                newAcc.setFullName(name != null ? name : email);
                newAcc.setEmail(email);
                newAcc.setAvatar(picture);
                newAcc.setPassword("GOOGLE_AUTH"); // không cần mật khẩu thật
                newAcc.setActive(true);
                newAcc.setAdmin(false);

                boolean created = accountDAO.insertGoogleAccount(newAcc);
                if (!created) {
                    resp.sendRedirect(req.getContextPath() + "/login?error=google_db");
                    return;
                }

                // Load lại account vừa tạo để có AccountID
                acc = accountDAO.findByEmail(email);
            }

            // Lưu vào session như đăng nhập thường
            HttpSession session = req.getSession();
            session.setAttribute("account", acc);
            session.setMaxInactiveInterval(60 * 60); // 1 giờ

            // Phân quyền redirect
            if (acc.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/home");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login?error=google_error");
        }
    }

    // Helper method để parse JSON field đơn giản
    private String extractJsonField(String json, String fieldName) {
        Pattern pattern = Pattern.compile("\"" + fieldName + "\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
}
