#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Initializing Development Environment ==="

# Ensure the src/ directory exists
echo "Ensuring src/ directory exists..."
mkdir -p src

# List of repositories to clone
REPOSITORIES=(
  "capsule-service-app"
  "location-service-api"
  "notification-service-api"
  "payment-service-api"
  "schedule-service-api"
  "user-service-api"
  "tenant-service-api"
)

# Clone or update each repository
echo "Cloning or updating repositories..."
for REPO in "${REPOSITORIES[@]}"; do
  if [ ! -d "src/$REPO/.git" ]; then
    echo "Cloning $REPO..."
    git clone https://github.com/CapsuleCompany/$REPO.git src/$REPO
  else
    echo "Repository $REPO already exists. Checking for changes..."
    cd "src/$REPO"

    # Stash any local changes
    if [ -n "$(git status --porcelain)" ]; then
      echo "Stashing local changes for $REPO..."
      git stash save "Stashed by onboard.sh on $(date)"
    fi

    # Pull the latest changes
    echo "Pulling latest changes for $REPO..."
    git pull --rebase
    cd -
  fi
done

# Check if .env file exists; if not, create it from .env.example
if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
  else
    echo "Error: .env.example not found. Please create it manually."
    exit 1
  fi
else
  echo ".env file already exists. Skipping creation."
fi

# Verify required environment variables
echo "Checking environment variables in .env..."
if ! grep -q POSTGRES_USER .env || ! grep -q POSTGRES_PASSWORD .env || ! grep -q POSTGRES_DB .env; then
  echo "Error: Missing required environment variables in .env."
  echo "Please ensure POSTGRES_USER, POSTGRES_PASSWORD, and POSTGRES_DB are defined."
  exit 1
fi

# Log environment file usage
echo "Using the following .env file:"
cat .env

# Build and start Docker services
echo "Building and starting Docker containers..."
docker-compose up --build -d

echo "=== Development Environment Setup Complete ==="
echo "Services are running! Use 'docker-compose ps' to check the status of your containers."
echo "Access Capsule Service (Next.js) at http://localhost:3000"
