FROM openjdk:8-jdk
RUN groupadd --system hunnor && \
	useradd --system --gid hunnor hunnor && \
	mkdir /opt/export-ant && \
	chown --recursive hunnor:hunnor /opt/export-ant

RUN apt-get update && apt-get install --assume-yes --allow-unauthenticated ant fop stardict-tools && apt-get clean

RUN mkdir -p /opt/saxon-9-he && \
    cd /opt/saxon-9-he && \
    wget https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.8/SaxonHE9-8-0-5J.zip && \
    unzip SaxonHE9-8-0-5J.zip && \
    rm -rf SaxonHE9-8-0-5J.zip doc notices saxon9-test.jar saxon9-xqj.jar

USER hunnor

COPY . /opt/export-ant

WORKDIR /opt/export-ant

ENTRYPOINT ["ant"]
