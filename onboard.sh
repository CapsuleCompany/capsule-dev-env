#!/bin/bash

set -e

# Ensure src/ directory exists
mkdir -p src

# Clone repositories into src/
echo "Cloning repositories..."
git clone https://github.com/your-org/capsule-service.git src/capsule-service
git clone https://github.com/your-org/location-service-api.git src/location-service-api
git clone https://github.com/your-org/notification-service-api.git src/notification-service-api
git clone https://github.com/your-org/payment-service-api.git src/payment-service-api
git clone https://github.com/your-org/schedule-service-api.git src/schedule-service-api
git clone https://github.com/your-org/user-service-api.git src/user-service-api

# Copy .env file
echo "Setting up environment variables..."
cp .env.example .env || echo ".env already exists"

# Build and start services
echo "Building and starting services..."
docker-compose up --build -d

echo "All services are running!"
