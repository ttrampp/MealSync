#!/usr/bin/env bash
# exit on error
set -o errexit

# Define the .NET version we want
DOTNET_VERSION=10.0.103

# Download the .NET install script
curl -sSL https://dot.net/v1/dotnet-install.sh > dotnet-install.sh
chmod +x dotnet-install.sh

# Install the .NET SDK
./dotnet-install.sh -c 10.0 -v $DOTNET_VERSION --install-dir ./dotnet

# Add dotnet to PATH
export PATH="$PATH:$PWD/dotnet"

# Verify installation
dotnet --version

# Install EF Core CLI tools
dotnet tool install --global dotnet-ef
export PATH="$PATH:$HOME/.dotnet/tools"

# Build and Publish the application
dotnet publish src/MealSync.Web/MealSync.Web.csproj -c Release -o out

# Run EF Core database migrations
dotnet-ef database update --project src/MealSync.Infrastructure --startup-project src/MealSync.Web --context MealSync.Infrastructure.Data.MealSyncDbContext
