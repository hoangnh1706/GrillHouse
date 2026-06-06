# --- Bước 1: Dùng môi trường hỗ trợ Java 17 và tải Ant về để biên dịch ---
FROM openjdk:17-jdk-slim AS build
WORKDIR /app

# Cài đặt Ant vào môi trường Java 17
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

COPY . .

# Định nghĩa biến môi trường JDK_17 để đánh lừa cấu hình NetBeans Ant
ENV platforms.JDK_17.home=/usr/local/openjdk-17

# Chạy lệnh clean và build dự án
RUN ant clean dist

# --- Bước 2: Đẩy sản phẩm đã build vào máy chủ Tomcat ---
FROM tomcat:9.0-jdk17-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Sao chép file .war vừa tự động tạo ra từ bước 1 vào Tomcat
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
