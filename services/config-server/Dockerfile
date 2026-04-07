FROM eclipse-temurin:25-jre-jammy

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1001 spring && \
    useradd --uid 1001 --gid 1001 --shell /bin/false --create-home spring

WORKDIR /app

COPY build/libs/config-server-0.4.0-alpha.jar app.jar

RUN mkdir -p /app/logs && chown -R spring:spring /app

USER 1001

ENV JAVA_OPTS="\
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  -XX:+UseG1GC \
  -XX:+UseStringDeduplication \
  -XX:+ExitOnOutOfMemoryError \
  -Xmx256m \
  -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8888

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f -s http://127.0.0.1:8888/actuator/health | grep -q '"status":"UP"' || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
