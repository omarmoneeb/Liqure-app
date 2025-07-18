#!/bin/bash

# Start PocketBase server for device testing
# This script starts PocketBase listening on all network interfaces (0.0.0.0)
# so that physical devices can connect to it

echo "🚀 Starting PocketBase server for device testing..."

# Check if already running
if lsof -i :8090 > /dev/null 2>&1; then
    echo "⚠️  PocketBase is already running on port 8090"
    echo "📋 Current process:"
    lsof -i :8090
    echo ""
    echo "🔄 Do you want to restart it? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "🛑 Stopping existing PocketBase..."
        pkill -f "pocketbase serve"
        sleep 2
    else
        echo "✅ Keeping existing server running"
        exit 0
    fi
fi

# Get the machine's IP address
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

echo "📍 Your machine's IP address: $DEV_IP"
echo "🌐 Starting PocketBase on all interfaces (0.0.0.0:8090)..."
echo ""

# Start PocketBase in background
nohup ./pocketbase serve --http 0.0.0.0:8090 > pocketbase.log 2>&1 &
SERVER_PID=$!

# Wait a moment for server to start
sleep 3

# Test connectivity
echo "🔍 Testing server connectivity..."
if curl -s http://localhost:8090/api/health > /dev/null; then
    echo "✅ Server is running successfully!"
    echo ""
    echo "📱 For physical device testing:"
    echo "   • Device URL: http://$DEV_IP:8090"
    echo "   • Make sure device is on same WiFi network"
    echo "   • App should automatically use DEV_IP from .env file"
    echo ""
    echo "💻 For emulator/simulator:"
    echo "   • Emulator URL: http://localhost:8090"
    echo "   • Works automatically"
    echo ""
    echo "🎯 PocketBase Dashboard: http://localhost:8090/_/"
    echo "📊 API Health: http://localhost:8090/api/health"
    echo "📝 Logs: tail -f pocketbase.log"
    echo ""
    echo "🛑 To stop: pkill -f 'pocketbase serve'"
else
    echo "❌ Failed to start server"
    echo "📋 Check logs: tail pocketbase.log"
    exit 1
fi