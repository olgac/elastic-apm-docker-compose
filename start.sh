#!/bin/bash

ROOT_PATH=$(dirname "$0")

echo "$(date) initializing swarm mode"
docker swarm init 2>/dev/null

echo "$(date) creating overlay network apm"
docker network create --driver=overlay --attachable apm && sleep 3

echo "$(date) pulling portainer-ce 2.1.1-alpine image"
docker pull portainer/portainer-ce:2.1.1-alpine

echo "$(date) deploying portainer v2.1.1 [admin:qwe12345]"
docker stack deploy -c $ROOT_PATH/portainer/docker-compose.yml apm

echo "$(date) pulling elasticsearch v7.12.0 image"
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.12.0

echo "$(date) deploying elasticsearch v7.12.0"
docker stack deploy -c $ROOT_PATH/elasticsearch/docker-compose.yml apm
while true; do curl -XGET http://localhost:9200 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) elasticsearch v7.12.0 is READY!"; break; fi; printf  "."; sleep 1; done

echo "$(date) pulling apm-server v7.12.0 image"
docker pull docker.elastic.co/apm/apm-server:7.12.0

echo "$(date) deploying apm-server v7.12.0"
docker stack deploy -c $ROOT_PATH/apm/docker-compose.yml apm
while true; do curl -XGET http://localhost:8200 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) apm-server v7.12.0 is READY!"; break; fi; printf  "."; sleep 1; done

echo "$(date) pulling kibana v7.12.0 image"
docker pull docker.elastic.co/kibana/kibana:7.12.0

echo "$(date) deploying kibana v7.12.0"
docker stack deploy -c $ROOT_PATH/kibana/docker-compose.yml apm
while true; do curl -XGET http://localhost:5601 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) kibana v7.12.0 is READY!"; break; fi; printf  "."; sleep 1; done