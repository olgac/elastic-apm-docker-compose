#!/bin/bash

ROOT_PATH=$(dirname "$0")

echo "$(date) removing apm stack"
docker stack rm apm

echo "$(date) removing sky network"
docker network rm apm

echo "$(date) pruning death containers"
docker container prune -f