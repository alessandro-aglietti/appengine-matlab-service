FROM gcr.io/google-appengine/debian

# https://serverfault.com/questions/362903/how-do-you-set-a-locale-non-interactively-on-debian-ubuntu
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN locale-gen --purge en_US.UTF-8
RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y libxt-dev
RUN apt-get install -y mercurial
RUN apt-get install -y zip

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

RUN mkdir mcr_installer
RUN mkdir mcr

WORKDIR /opt/mcr_installer

RUN wget https://storage.googleapis.com/growingabit-io-backend/MCR_R2017a_glnxa64_installer.zip

RUN unzip MCR_R2017a_glnxa64_installer.zip

RUN ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent

ENV MCR_ROOT="/opt/mcr"
RUN echo $MCR_ROOT
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${MCR_ROOT}/v92/runtime/glnxa64:${MCR_ROOT}/v92/bin/glnxa64:${MCR_ROOT}/v92/sys/os/glnxa64"
RUN echo $LD_LIBRARY_PATH
ENV XAPPLRESDIR="${MCR_ROOT}/v92/X11/app-defaults"
RUN echo $XAPPLRESDIR

WORKDIR /opt

RUN git clone https://github.com/growingabit/jd-core-java

WORKDIR /opt/jd-core-java

RUN ./gradlew assemble

WORKDIR /opt

ADD criptoOracleValori.jar /opt/criptoOracleValori.jar

RUN java -jar /opt/jd-core-java/build/libs/jd-core-java-1.2.jar ./criptoOracleValori.jar

RUN ls -la

WORKDIR /opt

RUN git clone https://github.com/growingabit/appengine-matlab-service

RUN cp -r /opt/criptoOracleValori.src/criptoOracleValori /opt/appengine-matlab-service/src/main/java/criptoOracleValori

WORKDIR /opt/appengine-matlab-service/lib

RUN cp /opt/mcr/v92/toolbox/javabuilder/jar/javabuilder.jar ./javabuilder.jar

RUN ./maven-install-jars.sh

WORKDIR /opt/appengine-matlab-service

RUN ./mvnw clean package

WORKDIR /opt

RUN ls -la

RUN mkdir -p BOOT-INF/classes/criptoOracleValori
RUN cp /opt/criptoOracleValori.src/criptoOracleValori/criptoOracleValori.ctf BOOT-INF/classes/criptoOracleValori/criptoOracleValori.ctf
RUN zip -g /opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar BOOT-INF/classes/criptoOracleValori/criptoOracleValori.ctf

WORKDIR /

EXPOSE 8080

CMD ["java", "-Dfile.encoding=UTF-8", "-jar", "/opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar"]