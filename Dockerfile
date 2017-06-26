FROM eu.gcr.io/growbit-0/matlab-compiler-runtime:latest

WORKDIR /opt

ADD criptoOracleValori.jar /opt/criptoOracleValori.jar

RUN unzip ./criptoOracleValori.jar

# qui il file ctf ha contenuto!?
RUN ls -la /opt/criptoOracleValori

RUN java -jar /opt/jd-core-java/build/libs/jd-core-java-1.2.jar ./criptoOracleValori.jar

# qui il file ctf non ha contenuto?!
RUN ls -la /opt/criptoOracleValori.src/criptoOracleValori
# lo levo pure
RUN rm /opt/criptoOracleValori.src/criptoOracleValori/criptoOracleValori.ctf

# profit
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
# usare quello unzippato perche' quello decompilato e' vuoto!?
RUN cp /opt/criptoOracleValori/criptoOracleValori.ctf BOOT-INF/classes/criptoOracleValori/criptoOracleValori.ctf
RUN zip -g /opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar BOOT-INF/classes/criptoOracleValori/criptoOracleValori.ctf

WORKDIR /

EXPOSE 8080

# no UTF-8 because Matlab wrapper use java.io instead of java.nio
# see http://docs.oracle.com/javase/7/docs/technotes/guides/intl/encoding.doc.html
CMD ["java", "-Xmx2048M", "-Dfile.encoding=UTF8", "-jar", "/opt/appengine-matlab-service/target/appengine-matlab-service-0.0.1.jar"]