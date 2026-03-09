#!/bin/bash

# 1. Démarrer le service SSH sur le master
service ssh start

# 2. Démarrer le service SSH sur les slaves à distance
ssh hadoop-slave1 "service ssh start"
ssh hadoop-slave2 "service ssh start"

# 3. Exporter les variables root pour Hadoop 3
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root

# 4. Lancer les services Hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

echo "------------------------------------------"
echo "Cluster Hadoop démarré avec succès !"
echo "Accès Web HDFS : http://localhost:9870"
echo "Accès Web YARN : http://localhost:8088"
echo "------------------------------------------"