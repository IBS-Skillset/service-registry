FROM public.ecr.aws/amazoncorretto/amazoncorretto:11

WORKDIR /opt/app

COPY target/service-registry.jar /opt/app/service-registry.jar

ENTRYPOINT ["/usr/bin/java"]
CMD ["-Dspring.profiles.active=dev", "-Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true", "-jar", "/opt/app/service-registry.jar"]

EXPOSE 8761