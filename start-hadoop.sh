#!/bin/bash
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root

export JAVA_HOME=/usr/local/openjdk-8
export PATH=$JAVA_HOME/bin:$PATH

export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root

service ssh start
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/start-dfs.sh
tail -f /dev/null
