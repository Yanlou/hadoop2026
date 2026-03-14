#!/bin/bash

# 1. Créer le réseau s'il n'existe pas
docker network inspect hadoop >/dev/null 2>&1 || \
    docker network create --driver bridge hadoop

# Le nombre de nœuds (1 master + N-1 slaves)
N=${1:-3}
IMAGE_NAME="zaidelfid/hadoop:3.4.3" # Vérifiez bien le nom exact ici

# 2. Démarrer le master
docker rm -f hadoop-master &> /dev/null
echo "Starting hadoop-master container..."

docker run -itd \
    --net=hadoop \
    -p 9870:9870 \
    -p 8088:8088 \
    --name hadoop-master \
    --hostname hadoop-master \
    $IMAGE_NAME

# 3. Démarrer les slaves
i=1
while [ $i -lt $N ]
do
    docker rm -f hadoop-slave$i &> /dev/null
    echo "Starting hadoop-slave$i container..."
    
    docker run -itd \
        --net=hadoop \
        --name hadoop-slave$i \
        --hostname hadoop-slave$i \
        $IMAGE_NAME
    i=$(( $i + 1 ))
done 

echo -e "\nCluster lancé avec succès ($N nœuds)."
echo "Accès : http://localhost:9870"

# Utilisation de winpty pour les utilisateurs Windows/Git Bash
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    winpty docker exec -it hadoop-master bash
else
    docker exec -it hadoop-master bash
fi
