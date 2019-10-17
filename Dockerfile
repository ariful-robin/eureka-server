FROM maven:3.6-jdk-12 as build
WORKDIR /sputnik-ena-parent
COPY pom.xml .
COPY eureka-server eureka-server/
RUN mvn -f eureka-server/pom.xml clean package

#FROM frolvlad/alpine-oraclejdk8:slim
FROM openjdk:12
COPY --from=build /sputnik-ena-parent/eureka-server/target/*.jar app.jar
EXPOSE 8090 8787
ENV JAVA_OPTS="-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8787,suspend=n"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=docker -jar /app.jar" ]
