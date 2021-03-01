FROM openjdk:8-jre-alpine
FROM maven:latest
COPY . .
RUN /usr/share/maven/bin/mvn clean install
COPY /target/spring-boot-rest-2-0.0.1-SNAPSHOT.jar /spring-boot-rest-2-0.0.1-SNAPSHOT.jar
CMD ["java", "-jar", "/spring-boot-rest-2-0.0.1-SNAPSHOT.jar"]