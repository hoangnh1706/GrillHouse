# --- Bước 1: Build ---
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

COPY . .

# Ghi đè JDK path vào project.properties (override đường dẫn Windows)
RUN echo "platforms.JDK_17.home=/opt/java/openjdk" >> nbproject/project.properties && \
    echo "platform.active=JDK_17" >> nbproject/project.properties

# Verify
RUN ls /opt/java/openjdk/bin/javac && echo "JDK found OK"

# Build WAR
RUN ant clean dist

# --- Bước 2: Tomcat 10 + JDK 17 (Jakarta EE 10) ---
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
