#!/bin/bash

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

IFS=',' read -r -a array <<< "$MONGODB_HOSTS"

mongo $MONGODB_DATABASE -u $MONGODB_USER -p $MONGODB_PASS $MONGOHOST --eval "rs.initiate(); rs.initiate({ _id : '$REPLSET',version : 1,members : [{ _id : 0,host : '$MONGODB_HOST' }]});"

for element in "${array[@]}"
do
    mongo $MONGODB_DATABASE -u $MONGODB_USER -p $MONGODB_PASS $MONGOHOST --eval "rs.add('$element');"
done