FROM gcr.io/google-appengine/debian

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y libxt-dev

WORKDIR /opt

RUN wget https://storage.googleapis.com/growingabit-io-backend/jdk-7u80-linux-x64.tar.gz
RUN tar -xzf jdk-7u80-linux-x64.tar.gz
RUN export JAVA_HOME=/opt/jdk1.7.0_80

RUN export PATH=$JAVA_HOME/bin:$PATH

RUN wget https://storage.googleapis.com/growingabit-io-backend/apache-maven-3.3.9-bin.zip
RUN unzip apache-maven-3.3.9-bin.zip
RUN export M2_HOME=/opt/apache-maven-3.3.9

RUN export PATH=$M2_HOME/bin:$PATH

RUN mkdir mcr_runtime_installer
RUN mkdir mcr

WORKDIR /opt/mcr_runtime_installer

RUN wget https://storage.googleapis.com/growingabit-io-backend/MCR_R2017a_glnxa64_installer.zip

RUN unzip MCR_R2017a_glnxa64_installer.zip

RUN ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent

WORKDIR /opt

RUN git clone https://github.com/growingabit/appengine-matlab-service

WORKDIR /opt/appengine-matlab-service/lib

RUN cp /opt/mcr/v92/toolbox/javabuilder/jar/javabuilder.jar ./javabuilder.jar

RUN ./maven-install-jars.sh

WORKDIR /opt/appengine-matlab-service

RUN ./mvnw clean package

WORKDIR /

CMD ["java", "-jar", "/opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar"]