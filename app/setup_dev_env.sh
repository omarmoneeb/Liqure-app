#!/bin/bash

# Setup Development Environment Script
# This script helps configure the app for development on physical devices

echo "🚀 Setting up development environment for Liquor Journal..."

# Find the machine's IP address
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEV_IP=$(ipconfig getifaddr en0)
    if [ -z "$DEV_IP" ]; then
        DEV_IP=$(ipconfig getifaddr en1)
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    DEV_IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')
else
    # Windows (Git Bash)
    DEV_IP=$(ipconfig | grep -A 10 "Wireless LAN adapter Wi-Fi" | grep "IPv4 Address" | cut -d: -f2 | sed 's/^ *//')
fi

echo "📍 Detected IP address: $DEV_IP"

# Create .env file
if [ -f ".env" ]; then
    echo "⚠️  .env file already exists. Creating backup..."
    cp .env .env.backup
fi

echo "📝 Creating .env file..."

cat > .env << EOF
# PocketBase Configuration
POCKETBASE_URL=http://localhost:8090
# For production, use your actual server URL:
# POCKETBASE_URL=https://api.yourdomain.com

# Development IP for physical devices
DEV_IP=$DEV_IP

# Environment
ENVIRONMENT=development
EOF

echo "✅ Created .env file with DEV_IP=$DEV_IP"
echo ""
echo "📱 To use on physical device:"
echo "   1. Make sure PocketBase is running on your laptop: pb serve"
echo "   2. Connect your device to the same WiFi network"
echo "   3. Build and run the app on your device"
echo ""
echo "💻 To use on emulator/simulator:"
echo "   1. The app will use localhost:8090 automatically"
echo "   2. Make sure PocketBase is running: pb serve"
echo ""
echo "🔄 If you need to change the IP address later:"
echo "   1. Edit the .env file"
echo "   2. Update the DEV_IP value"
echo "   3. Restart the app"
echo ""
echo "🎉 Setup complete!"