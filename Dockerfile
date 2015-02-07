FROM dockerfile/java:oracle-java7
MAINTAINER Nicholas Iaquinto <nickiaq@gmail.com>

# In case someone loses the Dockerfile
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

# Gradle
ENV GRADLE_VERSION 2.2.1
WORKDIR /usr/bin
RUN wget "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip" && \
    unzip "gradle-${GRADLE_VERSION}-all.zip" && \
    ln -s "gradle-${GRADLE_VERSION}" gradle && \
    rm "gradle-${GRADLE_VERSION}-all.zip"

# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Caches
VOLUME ["/root/.gradle/caches"]

# Default command is "/usr/bin/gradle -version" on /app dir
# (ie. Mount project at /app "docker --rm -v /path/to/app:/app gradle <command>")
VOLUME ["/app"]
WORKDIR /app
ENTRYPOINT ["gradle"]
CMD ["-version"]
