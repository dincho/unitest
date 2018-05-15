FROM microsoft/mssql-server-linux:2017-latest

RUN apt-get -qq update && apt-get -qq -y install mssql-cli

ENV ACCEPT_EULA y
ENV SA_PASSWORD P@55w0rd

EXPOSE 1433

ADD . /unitest
WORKDIR /unitest
