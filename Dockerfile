FROM maven:3.6-jdk-11 as maven
COPY tester /opt/hunnor-dict/export-ant/tester
COPY formats /opt/hunnor-dict/export-ant/formats
WORKDIR /opt/hunnor-dict/export-ant/tester
RUN mvn

FROM openjdk:11-jdk
RUN mkdir /opt/export-ant
RUN apt-get update && apt-get install --assume-yes --allow-unauthenticated ant fop stardict-tools && apt-get clean
ENV HUNNOR_ANT_JAVA_HOME /docker-java-home
ENV HUNNOR_ANT_SAXON_JAR /opt/saxon-9-he/saxon9he.jar
ENV HUNNOR_ANT_STARDICT_COMPILER /usr/lib/stardict-tools/stardict-text2bin
RUN mkdir -p /opt/saxon-9-he && \
    cd /opt/saxon-9-he && \
    wget -q https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.7/SaxonHE9-7-0-21J.zip && \
    unzip SaxonHE9-7-0-21J.zip && \
    rm -rf SaxonHE9-7-0-21J.zip doc notices saxon9-test.jar saxon9-xqj.jar
RUN mkdir -p /opt/sdict && \
    cd /opt/sdict && \
    wget -q http://swaj.net/sdict/ptksdict-1.2.4.tar.gz && \
    tar -xzf ptksdict-1.2.4.tar.gz && \
    rm ptksdict-1.2.4.tar.gz
COPY . /opt/export-ant
WORKDIR /opt/export-ant
ENTRYPOINT ["ant"]
