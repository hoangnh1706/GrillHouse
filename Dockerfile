# --- Bước 1: Build với Eclipse Temurin JDK 17 (thay openjdk:17-jdk-slim đã bị xóa) ---
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Cài Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

COPY . .

# Định nghĩa biến môi trường JDK_17 để Ant của NetBeans nhận đúng JDK
ENV platforms.JDK_17.home=/opt/java/openjdk

# Build
RUN ant clean dist

# --- Bước 2: Chạy trên Tomcat 9 + JDK 17 (thay tomcat:9.0-jdk17-openjdk-slim đã bị xóa) ---
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
