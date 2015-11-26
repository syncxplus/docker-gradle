FROM java:8-jdk
MAINTAINER Nicholas Iaquinto <nickiaq@gmail.com>

# Gradle
ENV GRADLE_VERSION 2.7
ENV GRADLE_SHA cde43b90945b5304c43ee36e58aab4cc6fb3a3d5f9bd9449bb1709a68371cb06
WORKDIR /usr/lib

RUN curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && echo "$GRADLE_SHA gradle-bin.zip" | sha256sum -c - \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip" \
 && mkdir -p /usr/src/app

# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/src/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Caches
VOLUME /root/.gradle/caches

# Default command is "/usr/bin/gradle -version" on /usr/bin/app dir
# (ie. Mount project at /usr/bin/app "docker --rm -v /path/to/app:/usr/bin/app gradle <command>")
VOLUME /usr/bin/app
WORKDIR /usr/bin/app
ENTRYPOINT gradle
CMD -version
