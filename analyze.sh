#!/bin/bash
docker exec -i mjai-recoder_db_1 psql -U user -d mjai_db < ./analyze.sql -v NAME=$1