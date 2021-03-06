FROM openjdk:8u181-jdk-stretch

LABEL maintainer="jibo@outlook.com"

# Gradle
ENV GRADLE_VERSION 4.10.1
ENV GRADLE_SHA e53ce3a01cf016b5d294eef20977ad4e3c13e761ac1e475f1ffad4c6141a92bd

RUN cd /usr/lib \
 && curl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && echo "$GRADLE_SHA gradle-bin.zip" | sha256sum -c - \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip"

# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Default command is "/usr/bin/gradle -version" on /usr/bin/app dir
# (ie. Mount project at /usr/bin/app "docker --rm -v /path/to/app:/usr/bin/app gradle <command>")
WORKDIR /usr/bin/app
ENTRYPOINT ["gradle"]
CMD ["-version"]

COPY init.gradle /root/.gradle/init.gradle
VOLUME ["/root/.gradle/caches", "/usr/bin/app"]
RUN apt-get update \
 && apt-get install -y --allow-unauthenticated --no-install-recommends locales \
 && apt-get clean && rm -r /var/lib/apt/lists/* \
 && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/1' /etc/locale.gen \
 && locale-gen \
 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone
ENV LANG zh_CN.UTF-8
