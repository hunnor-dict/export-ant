# Run XSpec tests with Maven

FROM maven:3.6-jdk-13 as maven

COPY tester /opt/hunnor-dict/export-ant/tester
COPY formats /opt/hunnor-dict/export-ant/formats

WORKDIR /opt/hunnor-dict/export-ant/tester
RUN mvn verify

COPY dependencies /opt/hunnor-dict/export-ant/dependencies

WORKDIR /opt/hunnor-dict/export-ant/dependencies
RUN mvn verify

COPY lines /opt/hunnor-dict/export-ant/lines
WORKDIR /opt/hunnor-dict/export-ant/lines
RUN mvn verify





FROM openjdk:13-jdk-buster

COPY --from=maven /opt/hunnor-dict/export-ant/jars /opt/hunnor-dict/jars

COPY --from=maven /opt/hunnor-dict/export-ant/lines/target/export-ant-lines-1.0.0.jar /opt/hunnor-dict/jars

RUN cd /opt && \
    wget -q http://apache.uib.no/ant/binaries/apache-ant-1.10.7-bin.tar.gz && \
    tar -xzf apache-ant-1.10.7-bin.tar.gz && \
    rm apache-ant-1.10.7-bin.tar.gz

ENV PATH /opt/apache-ant-1.10.7/bin:${PATH}

RUN apt-get update && \
    wget http://ftp.no.debian.org/debian/pool/main/m/mariadb-10.1/libmariadbclient18_10.1.41-0+deb9u1_amd64.deb && \
    apt-get install --assume-yes ./libmariadbclient18_10.1.41-0+deb9u1_amd64.deb && \
    wget http://ftp.no.debian.org/debian/pool/main/s/stardict-tools/stardict-tools_3.0.2-6_amd64.deb && \
    apt-get install --assume-yes ./stardict-tools_3.0.2-6_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/sdict && \
    cd /opt/sdict && \
    wget -q http://swaj.net/sdict/ptksdict-1.2.4.tar.gz && \
    tar -xzf ptksdict-1.2.4.tar.gz && \
    rm ptksdict-1.2.4.tar.gz

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --assume-yes wine32

COPY formats /opt/hunnor-dict/export-ant/formats
COPY images /opt/hunnor-dict/export-ant/images
COPY build.xml /opt/hunnor-dict/export-ant

WORKDIR /opt/hunnor-dict/export-ant
ENTRYPOINT ["ant", "-lib", "/opt/hunnor-dict/jars"]
