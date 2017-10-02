#!/usr/bin/env bash

echo "Shutting down stack"
docker-compose -f docker-cloud-compose.yml down
