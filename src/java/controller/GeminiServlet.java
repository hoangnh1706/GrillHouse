package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.URI;
import java.net.http.*;
import java.nio.charset.StandardCharsets;

@WebServlet("/ai/chat")
public class GeminiServlet extends HttpServlet {

    // ===== ĐỔI KEY NÀY =====
    private static final String GEMINI_API_KEY = "AIzaSyALaSfiEpvcGL8HjTP58cxIbJufM81cPtE";
    // =======================

    private static final String GEMINI_URL =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

    private static final String SYSTEM_PROMPT =
        "Bạn là trợ lý AI của nhà hàng GrillHouse - chuyên các món nướng Việt Nam như vịt nướng, " +
        "thịt nướng, hải sản nướng. Hãy tư vấn món ăn, giải thích nguyên liệu, gợi ý combo, " +
        "và trả lời các câu hỏi về thực đơn một cách thân thiện, ngắn gọn bằng tiếng Việt. " +
        "Nếu hỏi ngoài chủ đề ẩm thực, hãy khéo léo hướng về món ăn của nhà hàng.";

    private final HttpClient httpClient = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        // Đọc message từ request body
        String body = new String(req.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

        // Parse message từ JSON đơn giản: {"message":"..."}
        String userMessage = extractJson(body, "message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            resp.getWriter().write("{\"error\":\"Tin nhắn trống\"}");
            return;
        }

        // Build Gemini request body
        String geminiBody = """
            {
              "system_instruction": {
                "parts": [{"text": "%s"}]
              },
              "contents": [
                {"role": "user", "parts": [{"text": "%s"}]}
              ],
              "generationConfig": {
                "temperature": 0.8,
                "maxOutputTokens": 512
              }
            }
            """.formatted(
                SYSTEM_PROMPT.replace("\"", "\\\""),
                userMessage.replace("\"", "\\\"").replace("\n", "\\n")
            );

        try {
            HttpRequest geminiReq = HttpRequest.newBuilder()
                .uri(URI.create(GEMINI_URL + GEMINI_API_KEY))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(geminiBody))
                .build();

            HttpResponse<String> geminiResp = httpClient.send(
                geminiReq, HttpResponse.BodyHandlers.ofString());

            String geminiJson = geminiResp.body();

            // Extract text từ response
            String aiText = extractGeminiText(geminiJson);
            if (aiText == null) aiText = "Xin lỗi, tôi không thể trả lời lúc này.";

            // Escape JSON
            aiText = aiText.replace("\\", "\\\\")
                           .replace("\"", "\\\"")
                           .replace("\n", "\\n")
                           .replace("\r", "");

            resp.getWriter().write("{\"reply\":\"" + aiText + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"error\":\"Lỗi kết nối AI: " + e.getMessage() + "\"}");
        }
    }

    /** Extract text từ Gemini response JSON */
    private String extractGeminiText(String json) {
        try {
            int idx = json.indexOf("\"text\":");
            if (idx < 0) return null;
            int start = json.indexOf("\"", idx + 7) + 1;
            int end   = json.indexOf("\"", start);
            // Xử lý escaped quotes
            while (end > 0 && json.charAt(end - 1) == '\\') {
                end = json.indexOf("\"", end + 1);
            }
            if (start < 0 || end < 0) return null;
            return json.substring(start, end)
                       .replace("\\n", "\n")
                       .replace("\\\"", "\"")
                       .replace("\\\\", "\\");
        } catch (Exception e) {
            return null;
        }
    }

    /** Extract value từ JSON đơn giản */
    private String extractJson(String json, String key) {
        try {
            String search = "\"" + key + "\":\"";
            int idx = json.indexOf(search);
            if (idx < 0) return null;
            int start = idx + search.length();
            int end   = json.indexOf("\"", start);
            while (end > 0 && json.charAt(end - 1) == '\\') {
                end = json.indexOf("\"", end + 1);
            }
            return json.substring(start, end).replace("\\\"", "\"");
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type");
        resp.setStatus(200);
    }
}
