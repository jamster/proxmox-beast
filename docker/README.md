# AI Stack Deployment Guide

This guide provides step-by-step instructions to set up a local AI stack using Docker Compose. The stack includes Ollama, OpenWebUI, SearxNG, Apache Tika, n8n, and Nginx Proxy Manager for SSL termination.

## Prerequisites

- **Docker and Docker Compose:** Ensure Docker and Docker Compose are installed on your system.
- **NVIDIA Container Toolkit:** Required for GPU access.
- **Proxmox LXC with GPU Passthrough:** Properly configured for GPU usage.

## Directory Structure

/data/ # Data directory for all services 
docker-compose.yml # Common configurations 

docker-compose.ollama.yml # Ollama service 
docker-compose.openwebui.yml # OpenWebUI service 
docker-compose.searxng.yml # SearxNG service 
docker-compose.tika.yml # Apache Tika service 
docker-compose.n8n.yml # n8n service 
docker-compose.nginx.yml # Nginx Proxy Manager service 
.env # Environment variables 
setup.sh # Setup script



## Setup Steps

### 1. Clone or Create the Necessary Files

Copy the provided Docker Compose files, `.env`, and `setup.sh` into a directory on your Docker host.

### 2. Update Environment Variables

Edit the `.env` file to set your desired configuration:

- **User and Group IDs:**
  - `PUID` and `PGID` should match the user running Docker (usually `1000`).
- **SearxNG Configuration:**
  - `SEARXNG_BASE_URL`: Set to your desired domain or IP address.
- **n8n Configuration:**
  - `N8N_BASIC_AUTH_USER`: Set your n8n username.
  - `N8N_BASIC_AUTH_PASSWORD`: Set your n8n password.
  - `N8N_WEBHOOK_URL`: Set to your n8n domain or IP address.

### 3. Run the Setup Script

Make the script executable and run it:

```bash
chmod +x setup.sh
./setup.sh

