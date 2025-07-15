# ---------- Stage 1 ----------
FROM maven:3.9.4-eclipse-temurin-17 AS maven

WORKDIR /aws-pom

# Write the fixed POM
RUN echo '\
<project xmlns="http://maven.apache.org/POM/4.0.0" \
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> \
  <modelVersion>4.0.0</modelVersion> \
  <groupId>dummy</groupId> \
  <artifactId>aws-deps</artifactId> \
  <version>1.0</version> \
  <repositories> \
    <repository> \
      <id>central</id> \
      <url>https://repo1.maven.org/maven2</url> \
    </repository> \
  </repositories> \
  <dependencies> \
    <dependency> \
      <groupId>org.apache.hadoop</groupId> \
      <artifactId>hadoop-aws</artifactId> \
      <version>3.4.1</version> \
    </dependency> \
    <dependency> \
      <groupId>com.amazonaws</groupId> \
      <artifactId>aws-java-sdk-bundle</artifactId> \
      <version>1.12.661</version> \
    </dependency> \
  </dependencies> \
</project>' > pom.xml

RUN mvn dependency:copy-dependencies \
    -DoutputDirectory=/aws-libs \
    -f pom.xml

# --------------------------------------------------------
# Stage 2 - Build Hive Metastore image
# --------------------------------------------------------
FROM apache/hive:4.0.0

USER root

# Install curl (for downloading jars)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------
# Copy AWS SDK jars from Maven stage
# --------------------------------------------------------
COPY --from=maven /aws-libs /opt/hive/lib/

# --------------------------------------------------------
# Download additional Hadoop and JDBC jars manually
# --------------------------------------------------------

# Hadoop jars
RUN curl -L -o /opt/hive/lib/hadoop-common-3.4.1.jar \
      https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.4.1/hadoop-common-3.4.1.jar && \
    curl -L -o /opt/hive/lib/hadoop-auth-3.4.1.jar \
      https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-auth/3.4.1/hadoop-auth-3.4.1.jar && \
    curl -L -o /opt/hive/lib/hadoop-aws-3.4.1.jar \
      https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar

# Postgres JDBC
RUN curl -L -o /opt/hive/lib/postgresql-42.7.3.jar \
      https://jdbc.postgresql.org/download/postgresql-42.7.3.jar

# Log4j jars
RUN curl -L -o /opt/hive/lib/log4j-api-2.20.0.jar \
      https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.20.0/log4j-api-2.20.0.jar && \
    curl -L -o /opt/hive/lib/log4j-core-2.20.0.jar \
      https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.20.0/log4j-core-2.20.0.jar

# --------------------------------------------------------
# Add entrypoint script
# --------------------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# --------------------------------------------------------
# Set Hive metastore JDBC connection properties
# --------------------------------------------------------
ENV HADOOP_OPTS="-Djavax.jdo.option.ConnectionDriverName=org.postgresql.Driver \
-Djavax.jdo.option.ConnectionURL=jdbc:postgresql://postgres:5432/metastore \
-Djavax.jdo.option.ConnectionUserName=hive \
-Djavax.jdo.option.ConnectionPassword=hive"

ENTRYPOINT ["/entrypoint.sh"]
