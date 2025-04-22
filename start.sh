#!/bin/bash

echo "🚦 Setting up port forwarding..."
sudo ./setup_port_forwarding.sh

echo "🐳 Starting all services..."
docker compose up -d