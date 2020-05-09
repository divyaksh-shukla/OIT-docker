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
