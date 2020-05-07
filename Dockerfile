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
