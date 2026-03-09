#!/bin/bash

# Le nombre de nœuds par défaut est 3 (1 master + 2 slaves)
N=${1:-3}

# 1. Démarrer le conteneur hadoop-master
docker rm -f hadoop-master &> /dev/null
echo "Starting hadoop-master container..."

# On utilise l'image zaid.elfid/hadoop:3.4.3
docker run -itd \
                --net=hadoop \
                -p 9870:9870 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                zaid.elfid/hadoop:3.4.3 &> /dev/null


# 2. Démarrer les conteneurs hadoop-slaves
i=1
while [ $i -lt $N ]
do
    docker rm -f hadoop-slave$i &> /dev/null
    echo "Starting hadoop-slave$i container..."
    
    docker run -itd \
                    --net=hadoop \
                    --name hadoop-slave$i \
                    --hostname hadoop-slave$i \
                    zaid.elfid/hadoop:3.4.3 &> /dev/null
    i=$(( $i + 1 ))
done 

# 3. Entrer dans le terminal du master
echo -e "\nCluster lancé avec succès ($N nœuds)."
echo "Accès à l'interface Web : http://localhost:9870"
docker exec -it hadoop-master bash