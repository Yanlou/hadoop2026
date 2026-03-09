#!/bin/bash

# N est le nombre total de nœuds du cluster (1 Master + N-1 Slaves)
N=$1

if [ $# = 0 ]
then
    echo "Please specify the node number of hadoop cluster!"
    exit 1
fi

# 1. Mise à jour du fichier des nœuds (Hadoop 3 utilise 'workers' au lieu de 'slaves')
i=1
rm -f config/workers
touch config/workers

while [ $i -lt $N ]
do
    echo "hadoop-slave$i" >> config/workers
    ((i++))
done 

echo -e "\nFichier config/workers mis à jour avec $((N-1)) esclaves.\n"

# 2. Reconstruction de l'image Docker avec la nouvelle configuration
echo -e "Building modern Docker Hadoop image (Ubuntu 24.04 + Hadoop 3.4.3)...\n"

# Utilisation de votre tag personnalisé pour la version 3.4.3
sudo docker build -t zaid/hadoop:3.4.3 .

echo -e "\nBuild terminé. Image taguée : zaid/hadoop:3.4.3\n"