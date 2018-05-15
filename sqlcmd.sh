#!/bin/bash

docker exec -it unitest \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@55w0rd -d unitest \
    -Y 25 -w 125
