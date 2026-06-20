# ================================================
# Stage 1: Build the WAR file using Maven
# ================================================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies first (layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn package -DskipTests -B

# ================================================
# Stage 2: Run the WAR on Tomcat 10
# ================================================
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat webapps to keep it clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR as ROOT.war so it serves at "/"
COPY --from=builder /app/target/Aplikasi_Padel_Tubes_PBO-1.0-SNAPSHOT.war \
     /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
