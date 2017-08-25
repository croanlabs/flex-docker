#!/usr/bin/env bash

echo "Firing up stack"
docker-compose -f docker-cloud-compose.yml up --force-recreate --build -d
