#!/bin/bash
set -m

mongodb_cmd="mongod --storageEngine $STORAGE_ENGINE  --httpinterface --rest"


if [ "$AUTH" == "yes" ]; then
    mongodb_cmd="$mongodb_cmd --auth"
fi

if [ "$KEYFILE" == "yes" ]; then
    mongodb_cmd="$mongodb_cmd --keyFile mongodb-keyfile"
fi

if [ "$JOURNALING" == "no" ]; then
    mongodb_cmd="$mongodb_cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    mongodb_cmd="$mongodb_cmd --oplogSize $OPLOG_SIZE"
fi
if [ "$AUTH" == "yes" ]; then

    if [ ! -f /data/db/.mongodb_password_set ]; then
    

        $mongodb_cmd --master &

        /set_mongodb_password.sh

        sleep 5
    fi
fi


if [ "$REPLSET" != "" ]; then
    mongodb_cmd="$mongodb_cmd --replSet $REPLSET --keyFile /mongodb-keyfile"
    else
    mongodb_cmd="$mongodb_cmd --master"
fi


if [ "$CONFIGSVR" != "" ]; then
    mongod --keyFile /mongodb-keyfile --configsvr --replSet $REPLSET &
elif [ "$MONGOS" != "" ]; then
    mongos --keyFile /mongodb-keyfile --configdb $REPLSET/$CONFIGSVR_HOSTS &
else
    mongodb_cmd &
fi



fg
