#! /bin/bash

export HADOOP_PREFIX=/opt/hadoop

service ssh start
ssh-keyscan -H localhost 0.0.0.0 >> /root/.ssh/known_hosts

$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

sleep 1; 

if [ -d /localfolder ]; then
    echo "Copy content of /localfolder"
    $HADOOP_PREFIX/bin/hdfs dfs -copyFromLocal /localfolder /localfolder
else
    echo "Nothing to copy: no folder named /localfolder"
fi

if [[ $1 == "-d" ]]; then
  while true; do 
  	sleep 1000; 
  done
fi