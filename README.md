# Gradle Executable Container

This Docker image includes OpenJDK 8 and Gradle 3.3 configured with Gradle as the entrypoint.

## Usage

By default, running this image without any command will run `gradle -version` in the /usr/bin/app directory.

### Doing Something Actually Useful
To run something more interesting, say `gradle clean war`, you should mount your project root in /app. For example, you can run the following to create a deployable web archive.

```bash
docker run --rm -v /path/to/your/project:/usr/bin/app:rw niaquinto/gradle clean war
```

### Plugins
Of course, you can use any command here, including those dependent on plugins. For example, if you project includes the Jetty plugin (by including `apply plugin: 'jetty'` in its build.gradle) you can run the following command to start an instance of Jetty running a WAR of your application on port 8080 on the host.

```bash
docker run --rm -p 8080:8080 -v /path/to/your/project:/usr/bin/app:rw niaquinto/gradle jettyRunWar
```

### Changing the Default Behavior
Say you want `gradle clean war` to run if you launch the container without any options. To do that, just make a new Dockerfile like the following:

```bash
FROM niaquinto/gradle

# Set your default behavior
ENTRYPOINT ["gradle"]
CMD ["clean", "war"]
```

### Caching
To cache your dependencies, you must mount the `/root/.gradle/caches` directory to your host:

`docker run --rm -v /path/to/your/project:/usr/bin/app:rw niaquinto/gradle resolveDependencies`

If you are using this image as a base container, these caches are retained between layers. So, you can decrease your image build times by running `resolveDependencies` in a separate layer, allowing Docker to only rebuild it if your project changes. (See [issue 13](https://github.com/niaquinto/docker-gradle/issues/13))

```
FROM niaquinto/gradle

COPY build.gradle .
RUN gradle resolveDependencies
COPY . .
RUN gradle build
```

Conversely if you only need to built artifact and want a smaller image size, you should removing the caches after building. You must do this within the same image that you download the dependencies and build. (Again, see [issue 13](https://github.com/niaquinto/docker-gradle/issues/13))

```
FROM niaquinto/gradle

RUN gradle build && rm -rf ${HOME}/.gradle/caches

# ...
```

## Get the Image

To build this image yourself, run...
 
```bash
docker build github.com/niaquinto/docker-gradle
```

Or, you can pull the image from the central docker repository by using... 

```bash
docker pull niaquinto/gradle
```
