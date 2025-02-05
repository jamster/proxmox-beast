#!/bin/bash

# Create necessary directories
sudo mkdir -p /data/ollama
sudo mkdir -p /data/openwebui
sudo mkdir -p /data/searxng/redis
sudo mkdir -p /data/searxng/img
sudo mkdir -p /data/searxng/config
sudo mkdir -p /data/n8n
sudo mkdir -p /data/nginx/data
sudo mkdir -p /data/nginx/letsencrypt
sudo mkdir -p /data/dockage/opt/stacks
sudo mkdir -p /data/homepage
sudo mkdir -p /data/portainer
sudo mkdir -p /data/stable-diffusion
sudo mkdir -p /data/postgres/data
sudo mkdir -p /data/postgres/backups

# Set permissions
sudo chown -R 1000:1000 /data

# Create Docker networks
docker network create app_network
docker network create proxy_network

# Create Docker volumes
docker volume create --driver local --opt type=none --opt device=/data/ollama --opt o=bind ollama_data
docker volume create --driver local --opt type=none --opt device=/data/openwebui --opt o=bind openwebui_data
docker volume create --driver local --opt type=none --opt device=/data/searxng/redis --opt o=bind redis_data
docker volume create --driver local --opt type=none --opt device=/data/n8n --opt o=bind n8n_data
docker volume create --driver local --opt type=none --opt device=/data/nginx/data --opt o=bind nginx_data
docker volume create --driver local --opt type=none --opt device=/data/nginx/letsencrypt --opt o=bind nginx_letsencrypt
docker volume create --driver local --opt type=none --opt device=/data/postgres/data --opt o=bind postgres_data
docker volume create --driver local --opt type=none --opt device=/data/postgres/backups --opt o=bind postgres_backups
docker volume create --driver local --opt type=none --opt device=/data/registry/data --opt o=bind registry_data

# Pull Docker images
docker compose -f docker-compose.ollama.yml pull
docker compose -f docker-compose.openwebui.yml pull
docker compose -f docker-compose.searxng.yml pull
docker compose -f docker-compose.tika.yml pull
docker compose -f docker-compose.n8n.yml pull
docker compose -f docker-compose.nginx.yml pull
docker compose -f docker-compose.dockage.yml pull
docker compose -f docker-compose.homepage.yml pull
docker compose -f docker-compose.portainer.yml pull
docker compose -f docker-compose.postgres.yml pull

# Start all services
docker compose -f docker-compose.yml \
               -f docker-compose.dockage.yml \
               -f docker-compose.ollama.yml \
               -f docker-compose.openwebui.yml \
               -f docker-compose.searxng.yml \
               -f docker-compose.tika.yml \
               -f docker-compose.n8n.yml \
               -f docker-compose.nginx.yml \
               -f docker-compose.homepage.yml \
               -f docker-compose.automatic1111.yml \
               -f docker-compose.cloudflare-n8n.yml \
               -f docker-compose.cloudflare-openwebui.yml \
               -f docker-compose.n8n.yml \
               -f docker-compose.piper.yml \
               -f docker-compose.wyoming-whisper.yml \
               -f docker-compose.postgres.yml \
               -f docker-compose.portainer.yml up -d

