#!/bin/bash
set -m

mongodb_cmd="mongod --storageEngine $STORAGE_ENGINE"
cmd="$mongodb_cmd --httpinterface --rest"
if [ "$AUTH" == "yes" ]; then
    cmd="$cmd --auth"
fi



if [ "$KEYFILE" == "yes" ]; then
    cmd="$cmd --keyFile mongodb-keyfile"
fi

if [ "$JOURNALING" == "no" ]; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi


if [ ! -f /data/db/.mongodb_password_set ]; then
    if [ "$AUTH" == "yes" ]; then

        $cmd --master &

        /set_mongodb_password.sh

        sleep 5
    fi
fi


if [ "$REPLSET" != "" ]; then
    cmd="$cmd --replSet $REPLSET --keyFile /mongodb-keyfile"
    else
    cmd="$cmd --master"
fi

$cmd &

fg
