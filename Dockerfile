# Utilisation de la dernière version LTS stable
FROM ubuntu:24.04

LABEL maintainer="Zaid EL FID"

# Installation de Java 11 et outils nécessaires
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    openssh-server \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Variables d'environnement
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# CORRECTION ICI : L'URL et le nom du fichier doivent correspondre (3.4.3 partout)
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.4.3/hadoop-3.4.3.tar.gz && \
    tar -xzvf hadoop-3.4.3.tar.gz && \
    mv hadoop-3.4.3 $HADOOP_HOME && \
    rm hadoop-3.4.3.tar.gz

# Configuration SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Copie des fichiers de configuration
COPY config/* /tmp/
RUN mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers

# Script de démarrage (Assurez-vous qu'il est bien à côté du Dockerfile)
COPY start-hadoop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-hadoop.sh

EXPOSE 9870 8088 9000

CMD ["bash"]

