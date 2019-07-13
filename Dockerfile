# Run XSpec tests with Maven

FROM maven:3.6-jdk-11 as maven

COPY tester /opt/hunnor-dict/export-ant/tester
COPY formats /opt/hunnor-dict/export-ant/formats

WORKDIR /opt/hunnor-dict/export-ant/tester
RUN mvn verify

COPY dependencies /opt/hunnor-dict/export-ant/dependencies

WORKDIR /opt/hunnor-dict/export-ant/dependencies
RUN mvn verify





FROM openjdk:11-jdk

COPY --from=maven /opt/hunnor-dict/export-ant/jars /opt/hunnor-dict/jars

RUN apt-get update && apt-get install --assume-yes --allow-unauthenticated ant stardict-tools && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/sdict && \
    cd /opt/sdict && \
    wget -q http://swaj.net/sdict/ptksdict-1.2.4.tar.gz && \
    tar -xzf ptksdict-1.2.4.tar.gz && \
    rm ptksdict-1.2.4.tar.gz

COPY . /opt/hunnor-dict/export-ant

WORKDIR /opt/hunnor-dict/export-ant
ENTRYPOINT ["ant", "-lib", "/opt/hunnor-dict/jars"]
