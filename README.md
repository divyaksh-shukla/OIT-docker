# OIT in Docker
- [OIT in Docker](#oit-in-docker)
  - [Docker Volume](#docker-volume)
  - [Dockerfile](#dockerfile)
  - [Commands to run](#commands-to-run)
## Docker Volume
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
# Get the oracle java image
FROM store/oracle/serverjre:1.8.0_241-b07
LABEL Author="Divyaksh (@divyaksh-shukla)"

# Installing additional tools
RUN yum install -y unzip

WORKDIR /home/oit
COPY ix-8-5-4-linux-x86-64.zip .
RUN unzip ix-8-5-4-linux-x86-64.zip -d ix_image
WORKDIR /home/oit/ix_image
RUN sh makedemo.sh
WORKDIR /home/oit/ix_image/sdk/demo

ENV CLASSPATH=oilink.jar:oitsample.jar

```

## Commands to run
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

**OUTPUT**
```bash
$ bash run-it.sh 
Sending build context to Docker daemon  125.5MB
Step 1/11 : FROM store/oracle/serverjre:1.8.0_241-b07
 ---> ef9c1a0152ab
Step 2/11 : LABEL Author="Divyaksh (@divyaksh-shukla)"
 ---> Using cache
 ---> 375998c9ca19
Step 3/11 : RUN yum install -y unzip
 ---> Using cache
 ---> 3116220fc555
Step 4/11 : WORKDIR /home/oit
 ---> Using cache
 ---> e9a5f7f9978b
Step 5/11 : COPY ix-8-5-4-linux-x86-64.zip .
 ---> Using cache
 ---> 6f07b04abbae
Step 6/11 : RUN unzip ix-8-5-4-linux-x86-64.zip -d ix_image
 ---> Using cache
 ---> 85d6e5a3ce1e
Step 7/11 : WORKDIR /home/oit/ix_image
 ---> Using cache
 ---> 20256453949d
Step 8/11 : RUN ls
 ---> Running in 5c9d8519c1de
makedemo.sh
README
redist
sdk
Removing intermediate container 5c9d8519c1de
 ---> 6b8673720c9b
Step 9/11 : RUN sh makedemo.sh
 ---> Running in 47f7e4b17e60
Removing intermediate container 47f7e4b17e60
 ---> 0fa1b311067f
Step 10/11 : WORKDIR /home/oit/ix_image/sdk/demo
 ---> Running in cd60511e8e72
Removing intermediate container cd60511e8e72
 ---> 53a3eb155b79
Step 11/11 : ENV CLASSPATH=oilink.jar:oitsample.jar
 ---> Running in 0d95affdf08d
Removing intermediate container 0d95affdf08d
 ---> bdad82cab940
Successfully built bdad82cab940
Successfully tagged oit-sample:1
File Identifier : Adobe Acrobat (PDF)(1557)
File Identifier (Raw): Adobe Acrobat (PDF)(1557)
Creating file: /home/oit/outputs/test.tif
Creating file: /home/oit/outputs/test0001.tiff
Creating file: /home/oit/outputs/test0002.tiff
Export Successful
```