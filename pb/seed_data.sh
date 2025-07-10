#!/bin/bash

# PocketBase Seed Data Script
# This script adds sample data to test the collections

PB_URL="${PB_URL:-http://localhost:8090}"
ADMIN_EMAIL="${PB_ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${PB_ADMIN_PASSWORD:-changeme}"

echo "Adding seed data to PocketBase..."

# Login as admin
ADMIN_TOKEN=$(curl -s -X POST ${PB_URL}/api/admins/auth-with-password \
  -H "Content-Type: application/json" \
  -d "{
    \"identity\": \"${ADMIN_EMAIL}\",
    \"password\": \"${ADMIN_PASSWORD}\"
  }" | jq -r '.token')

if [ -z "$ADMIN_TOKEN" ]; then
  echo "Failed to login as admin"
  exit 1
fi

# Create a test user
echo "Creating test user..."
USER_RESPONSE=$(curl -s -X POST ${PB_URL}/api/collections/users/records \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@liquorjournal.app",
    "emailVisibility": true,
    "password": "Test123!",
    "passwordConfirm": "Test123!",
    "name": "Test User"
  }')
  
USER_ID=$(echo $USER_RESPONSE | jq -r '.id')
echo "✓ Test user created: $USER_ID"

# Add sample drinks
echo "Adding sample drinks..."

# Whiskey
DRINK1=$(curl -s -X POST ${PB_URL}/api/collections/drinks/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jameson Irish Whiskey",
    "type": "whiskey",
    "abv": 40,
    "country": "Ireland",
    "barcode": "5011007003012"
  }' | jq -r '.id')
echo "✓ Added Jameson: $DRINK1"

# Bourbon
DRINK2=$(curl -s -X POST ${PB_URL}/api/collections/drinks/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Buffalo Trace Bourbon",
    "type": "bourbon",
    "abv": 45,
    "country": "USA",
    "barcode": "080244009045"
  }' | jq -r '.id')
echo "✓ Added Buffalo Trace: $DRINK2"

# Scotch
DRINK3=$(curl -s -X POST ${PB_URL}/api/collections/drinks/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Glenfiddich 12 Year",
    "type": "scotch",
    "abv": 40,
    "country": "Scotland",
    "barcode": "5010327000145"
  }' | jq -r '.id')
echo "✓ Added Glenfiddich: $DRINK3"

# Tequila
DRINK4=$(curl -s -X POST ${PB_URL}/api/collections/drinks/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Patrón Silver",
    "type": "tequila",
    "abv": 40,
    "country": "Mexico",
    "barcode": "721733000012"
  }' | jq -r '.id')
echo "✓ Added Patrón: $DRINK4"

# Add sample ingredients
echo "Adding sample ingredients..."

INGR1=$(curl -s -X POST ${PB_URL}/api/collections/ingredients/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Simple Syrup",
    "category": "syrup"
  }' | jq -r '.id')

INGR2=$(curl -s -X POST ${PB_URL}/api/collections/ingredients/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Lime Juice",
    "category": "juice"
  }' | jq -r '.id')

INGR3=$(curl -s -X POST ${PB_URL}/api/collections/ingredients/records \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Orange Bitters",
    "category": "bitter"
  }' | jq -r '.id')

echo "✓ Added ingredients"

# Login as test user to add user-specific data
echo "Logging in as test user..."
USER_TOKEN=$(curl -s -X POST ${PB_URL}/api/collections/users/auth-with-password \
  -H "Content-Type: application/json" \
  -d '{
    "identity": "test@liquorjournal.app",
    "password": "Test123!"
  }' | jq -r '.token')

# Add ratings
echo "Adding sample ratings..."
curl -s -X POST ${PB_URL}/api/collections/ratings/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"drink\": \"$DRINK1\",
    \"score\": 4.5,
    \"note\": \"Smooth and easy to drink. Great for beginners!\"
  }" > /dev/null
echo "✓ Added rating for Jameson"

curl -s -X POST ${PB_URL}/api/collections/ratings/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"drink\": \"$DRINK2\",
    \"score\": 5,
    \"note\": \"Amazing bourbon! Complex flavors with hints of vanilla and caramel.\"
  }" > /dev/null
echo "✓ Added rating for Buffalo Trace"

# Add inventory
echo "Adding sample inventory..."
curl -s -X POST ${PB_URL}/api/collections/inventory/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"drink\": \"$DRINK1\",
    \"quantity\": 2,
    \"price\": 29.99,
    \"purchaseDate\": \"$(date -Iseconds)\"
  }" > /dev/null
echo "✓ Added Jameson to inventory"

curl -s -X POST ${PB_URL}/api/collections/inventory/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"drink\": \"$DRINK3\",
    \"quantity\": 1,
    \"price\": 45.99,
    \"purchaseDate\": \"$(date -Iseconds)\"
  }" > /dev/null
echo "✓ Added Glenfiddich to inventory"

# Add badges
echo "Adding sample badges..."
curl -s -X POST ${PB_URL}/api/collections/badges/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"code\": \"first_review\",
    \"unlockedAt\": \"$(date -Iseconds)\"
  }" > /dev/null
echo "✓ Added 'First Review' badge"

curl -s -X POST ${PB_URL}/api/collections/badges/records \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user\": \"$USER_ID\",
    \"code\": \"whiskey_lover\",
    \"unlockedAt\": \"$(date -Iseconds)\"
  }" > /dev/null
echo "✓ Added 'Whiskey Lover' badge"

echo ""
echo "✅ Seed data added successfully!"
echo ""
echo "Test User Credentials:"
echo "Email: test@liquorjournal.app"
echo "Password: Test123!"
echo ""
echo "You can now:"
echo "1. Login to the admin UI: http://localhost:8090/_/"
echo "2. Browse the collections and data"
echo "3. Test the API endpoints"