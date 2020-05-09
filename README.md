# OIT in Docker
- [OIT in Docker](#oit-in-docker)
  - [Update (10-May-2020)](#update-10-may-2020)
  - [Docker Volume (Not required in docker-compose)](#docker-volume-not-required-in-docker-compose)
  - [Dockerfile](#dockerfile)
  - [Commands to run (Irrelevant if using docker-compose)](#commands-to-run-irrelevant-if-using-docker-compose)
  - [Docker Compose](#docker-compose)
  - [OUTPUT](#output)

## Update (10-May-2020)
- Now includes support for Web view export as well. 
- Everything now runs on a base image of oracle linux 8.2. Installation of java and nodejs happens in the Dockerfile
- jdk rpm has to be downloaded into this directory for Dockerfile to pick it up

## Docker Volume (Not required in docker-compose)
**Create a new Docker volumes**
```bash
$ docker volume create oit_output
oit_output
$ docker volume create oit_samplefiles
oit_samplefiles
$ docker volume create oit_fonts
oit_fonts
```

**See if the docker volume is created by listing**
```bash
$ docker volume ls
DRIVER              VOLUME NAME
local               oit_fonts
local               oit_output
local               oit_samplefiles
```

**Inspect the docker volume for addtional information**
```bash
$ docker volume inspect oit_output 
[
    {
        "CreatedAt": "2020-05-07T14:53:00+05:30",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/oit_output/_data",
        "Name": "oit_output",
        "Options": {},
        "Scope": "local"
    }
]
```

## Dockerfile
```Dockerfile
# Get Oracle Linux 8.2
FROM oraclelinux:8.2
LABEL Author="Divyaksh (@divyaksh-shukla)"

# Installing additional tools
RUN yum install -y gcc-c++ make unzip

# Installing java 8
WORKDIR /home/oit/java-installation
COPY jdk-8u251-linux-x64.rpm .
RUN rpm -i jdk-8u251-linux-x64.rpm

RUN java -version

# Installing nodejs
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y nodejs

WORKDIR /home/oit
COPY ix-8-5-4-linux-x86-64.zip .
COPY wv-8-5-4-linux-x86-64.zip .
RUN unzip -oq ix-8-5-4-linux-x86-64.zip -d ix_image
RUN unzip -oq wv-8-5-4-linux-x86-64.zip -d wv_web

WORKDIR /home/oit/ix_image
RUN sh makedemo.sh
WORKDIR /home/oit/wv_web
RUN sh makedemo.sh

WORKDIR /home/oit/ix_image/sdk/demo
ENV CLASSPATH=oilink.jar:oitsample.jar

WORKDIR /home/oit/wv_web/sdk/samplecode/demoserver_nodejs/
COPY demoserver.config .
COPY start.sh .

# CMD ["java", "-cp", "oilink.jar:oitsample.jar", "OITSample", "/home/oit/samplefiles/adobe-acrobat.pdf", "/home/oit/outputs/test.tif", "tiff", "/home/oit/fonts"]
# CMD ["java", "-cp", "oilink.jar:oitsample.jar", "OITSample", "/home/oit/samplefiles/adobe-acrobat.pdf", "/home/oit/outputs/test.tif", "tiff", "/home/oit/fonts"]
# CMD ["./exsimple", "/home/oit/samplefiles/adobe-acrobat.pdf", "/home/oit/outputs/testsimple.tif", "default.cfg", ";", "java", "-cp", "oilink.jar:oitsample.jar", "OITSample", "/home/oit/samplefiles/adobe-acrobat.pdf", "/home/oit/outputs/test.tif", "tiff", "/home/oit/fonts"]
CMD ["sh", "start.sh"]
```

## Commands to run (Irrelevant if using docker-compose)
**Build an image**
```bash
docker build --rm -t oit-sample:1 -f Dockerfile .
```
The created image is called oit-sample:1

**Run the image on a container with java command**
```bash
docker run -it --rm -v oit_output:/home/oit/outputs -v oit_samplefiles:/home/oit/samplefiles -v oit_fonts:/home/oit/fonts oit-sample:1 java -cp oilink.jar:oitsample.jar OITSample /home/oit/samplefiles/adobe-acrobat.pdf /home/oit/outputs/test.tif tiff /home/oit/fonts
```
**Also available as a shell command**
```bash 
bash run-it.sh
```

## Docker Compose
Defined a script named docker-compose.yml . This helps us to build an image, load volumes and initialize a start-up command
```yaml
version: '3'

services: 
    oit:
        build: .
        volumes: 
            - oit_output:/home/oit/outputs
            - oit_samplefiles:/home/oit/samplefiles
            - oit_fonts:/home/oit/fonts
        ports: 
            - 8080:8888

volumes: 
    oit_fonts:
    oit_output:
    oit_samplefiles:

```

Run these commands for docker-compose
```bash
$ docker-compose build --no-cache
# Don't put --no-cache if you want docker to  use the docker cache for faster builds

$ docker-compose up
# This will run the image on a container

$ docker-compose down
# This will destroy the container
```


## OUTPUT
```bash
$ docker-compose build
Building oit
Step 1/24 : FROM oraclelinux:8.2
 ---> 47263c4aa3bf
Step 2/24 : LABEL Author="Divyaksh (@divyaksh-shukla)"
 ---> Using cache
 ---> 6a1f63036e53
Step 3/24 : RUN yum install -y gcc-c++ make unzip
 ---> Using cache
 ---> 1554b365aa5e
Step 4/24 : WORKDIR /home/oit/java-installation
 ---> Using cache
 ---> beb76d86a407
Step 5/24 : COPY jdk-8u251-linux-x64.rpm .
 ---> Using cache
 ---> f75711967258
Step 6/24 : RUN rpm -i jdk-8u251-linux-x64.rpm
 ---> Using cache
 ---> 1fdf72f68a49
Step 7/24 : RUN java -version
 ---> Using cache
 ---> aa74f72b6027
Step 8/24 : RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
 ---> Using cache
 ---> f5803dc545a9
Step 9/24 : RUN yum install -y nodejs
 ---> Using cache
 ---> bf0895d463bc
Step 10/24 : WORKDIR /home/oit
 ---> Using cache
 ---> 3746d056692b
Step 11/24 : COPY ix-8-5-4-linux-x86-64.zip .
 ---> Using cache
 ---> 12949698b142
Step 12/24 : COPY wv-8-5-4-linux-x86-64.zip .
 ---> Using cache
 ---> 9bdc291da809
Step 13/24 : RUN unzip -oq ix-8-5-4-linux-x86-64.zip -d ix_image
 ---> Using cache
 ---> a0ab8975e2ef
Step 14/24 : RUN unzip -oq wv-8-5-4-linux-x86-64.zip -d wv_web
 ---> Using cache
 ---> 121461f3de22
Step 15/24 : WORKDIR /home/oit/ix_image
 ---> Using cache
 ---> 68bed4843f21
Step 16/24 : RUN sh makedemo.sh
 ---> Using cache
 ---> 0108dcd524d0
Step 17/24 : WORKDIR /home/oit/wv_web
 ---> Using cache
 ---> 02b28b96f39a
Step 18/24 : RUN sh makedemo.sh
 ---> Using cache
 ---> 8f14a017c7e1
Step 19/24 : WORKDIR /home/oit/ix_image/sdk/demo
 ---> Using cache
 ---> 6aaaba514b30
Step 20/24 : ENV CLASSPATH=oilink.jar:oitsample.jar
 ---> Using cache
 ---> a132a724f455
Step 21/24 : WORKDIR /home/oit/wv_web/sdk/samplecode/demoserver_nodejs/
 ---> Using cache
 ---> 02cd3886a31d
Step 22/24 : COPY demoserver.config .
 ---> Using cache
 ---> 7d9b462af872
Step 23/24 : COPY start.sh .
 ---> Using cache
 ---> 677f80ea1e8b
Step 24/24 : CMD ["sh", "start.sh"]
 ---> Using cache
 ---> 90585fe357cc
Successfully built 90585fe357cc
Successfully tagged divyaksh_oit_oit:latest

$ docker-compose up
Recreating divyaksh_oit_oit_1 ... done
Attaching to divyaksh_oit_oit_1
oit_1  | demoserver: listening on port 8888
oit_1  | (Ctrl-C to exit)
oit_1  |  export monitor listening on port 33325
oit_1  | --- Exporting: /home/oit/samplefiles/base14fonts.doc
oit_1  | --- Exporting: /home/oit/samplefiles/corel-presentation.shw
oit_1  | --- Exporting: /home/oit/samplefiles/gif-bitmap.gif
oit_1  | --- Exporting: /home/oit/samplefiles/lotus-freelance.prz
^CGracefully stopping... (press Ctrl+C again to force)
Stopping divyaksh_oit_oit_1   ... done

$ docker-compose down
Removing divyaksh_oit_oit_1 ... done
Removing network divyaksh_oit_default
```
