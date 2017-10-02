#!/usr/bin/env bash

PROFILE=${1:-flex}
echo "Aws Profile set to $PROFILE"
$(echo `aws ecr get-login --region eu-central-1 --profile $PROFILE` | sed 's/-e none //g')

docker-compose -f docker-cloud-compose.yml down

# For the case where we remove a worker from docker-compose.
docker-compose rm

# Remove all current images on the target machine
echo "Removing all existing images"
docker rmi -f $(docker images -q)

echo "Firing up stack"
docker-compose -f docker-cloud-compose.yml up --force-recreate --build -d
