#!/bin/bash

WAIT_SECONDS=${1:-15}

docker build -t unitest .
docker rm --force unitest
docker run -d --name unitest unitest
sleep $WAIT_SECONDS
docker exec -it unitest \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@55w0rd \
    -i options.sql \
    -i schema.sql \
    -i proc_and_triggers.sql \
    -i views.sql \
    -i data.sql

docker exec -it unitest \
    /usr/bin/mssql-cli -S localhost -U sa -P P@55w0rd -d unitest \
    --less-chatty
