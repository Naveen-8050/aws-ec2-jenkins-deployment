 # Use Maven to build and then a slim runtime image (multi-stage)
FROM maven:3.8.8-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn -B -DskipTests package

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/sample-java-app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
