# Gradle Executable Container

This docker image includes OpenJDK 8 and Gradle 3.3 configured with Gradle as the entrypoint.

## Usage

By defaut, running this image without any command will run `gradle -version` in the /usr/bin/app directory. 

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
Say you want `gradle clean war` to run if you launch the container without any options. To do that, just make a new dockerfile like the following:

```bash
# Use this image as a base
FROM niaquinto/gradle
MAINTAINER your-name <your@email.com>

# Set your default behavior
ENTRYPOINT ["gradle"]
CMD ["clean", "war"]
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
