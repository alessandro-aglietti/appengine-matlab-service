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
ENV JAVA_HOME="/opt/jdk1.7.0_80"

ENV PATH="$JAVA_HOME/bin:$PATH"

RUN echo $PATH

RUN java -version

RUN wget https://storage.googleapis.com/growingabit-io-backend/apache-maven-3.3.9-bin.zip
RUN unzip apache-maven-3.3.9-bin.zip
ENV M2_HOME="/opt/apache-maven-3.3.9"

ENV PATH="$M2_HOME/bin:$PATH"

RUN echo $PATH

RUN mvn -v

RUN mkdir mcr_runtime_installer
RUN mkdir mcr

WORKDIR /opt/mcr_runtime_installer

RUN wget https://storage.googleapis.com/growingabit-io-backend/MCR_R2017a_glnxa64_installer.zip

RUN unzip MCR_R2017a_glnxa64_installer.zip

RUN ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent

ENV MCR_ROOT="/opt/mcr"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${MCR_ROOT}/v92/runtime/glnxa64:${MCR_ROOT}/v92/bin/glnxa64:${MCR_ROOT}/v92/sys/os/glnxa64"
ENV XAPPLRESDIR="${MCR_ROOT}/v92/X11/app-defaults"

WORKDIR /opt

RUN git clone https://github.com/growingabit/appengine-matlab-service

WORKDIR /opt/appengine-matlab-service/lib

RUN cp /opt/mcr/v92/toolbox/javabuilder/jar/javabuilder.jar ./javabuilder.jar

RUN ./maven-install-jars.sh

WORKDIR /opt/appengine-matlab-service

RUN ./mvnw clean package

WORKDIR /

CMD ["java", "-jar", "/opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar"]