# --- Bước 1: Dùng môi trường Java + công cụ Ant để tự biên dịch code ---
FROM frekele/ant:1.10.3-jdk8 AS build
WORKDIR /app
COPY . .
# Lệnh này sẽ tự động chạy file build.xml của NetBeans để tạo ra thư mục dist và file .war trên Cloud
RUN ant clean dist

# --- Bước 2: Đẩy sản phẩm đã build vào máy chủ Tomcat ---
FROM tomcat:9.0-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Sao chép file .war vừa tự động tạo ra từ bước 1 vào Tomcat
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
