#!/bin/bash

echo ""
echo -e "\nBuilding modern Docker Hadoop image (Ubuntu 24.04 + Hadoop 3.4.3)\n"

# Utilisation d'un tag plus explicite pour éviter les conflits avec l'ancienne version
sudo docker build -t zaid.elfid/hadoop:3.4.3 .

echo -e "\nBuild complete. Image tagged as zaid.elfid/hadoop:3.4.3\n"