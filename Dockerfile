FROM alpine:latest

COPY ./binaries /tmp

ENV SCALA_VERSION=2.13.1 \
    SCALA_HOME=/usr/share/scala \
    SBT_VERSION=1.3.3

# Install scala
RUN apk add --no-cache openjdk8 bash \
    && cd "/tmp" \
    && tar xzf "scala-${SCALA_VERSION}.tgz" \
    && mkdir "${SCALA_HOME}" \
    && rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat \
    && mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" \
    && ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" 

# Insall sbt
RUN export PATH="/usr/local/sbt/bin:$PATH" \
    && cd "/tmp" \
    && tar xzf "sbt-${SBT_VERSION}.tgz" \
    && mv "/tmp/sbt" "/usr/local" \
    && sbt sbtVersion

# Clean up
RUN rm -rf "/tmp/"*