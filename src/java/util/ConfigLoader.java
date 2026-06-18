package util;

import jakarta.servlet.ServletContext;
import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {
    public static String getApiKey(ServletContext context) {
        Properties props = new Properties();
        try (InputStream is = context.getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) {
                props.load(is);
                return props.getProperty("gemini.api.key");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}