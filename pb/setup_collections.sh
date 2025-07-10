#!/bin/bash

# PocketBase Collection Setup Script
# This script sets up all collections via the PocketBase API

PB_URL="${PB_URL:-http://localhost:8090}"
ADMIN_EMAIL="${PB_ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${PB_ADMIN_PASSWORD:-changeme}"

echo "Setting up PocketBase collections for Liquor Journal..."

# Wait for PocketBase to be ready
echo "Waiting for PocketBase to start..."
until curl -s ${PB_URL}/api/health > /dev/null; do
  sleep 1
done
echo "PocketBase is ready!"

# Create admin account (first run only)
echo "Creating admin account..."
curl -X POST ${PB_URL}/api/admins \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"${ADMIN_EMAIL}\",
    \"password\": \"${ADMIN_PASSWORD}\",
    \"passwordConfirm\": \"${ADMIN_PASSWORD}\"
  }" 2>/dev/null || echo "Admin might already exist"

# Login as admin
echo "Logging in as admin..."
ADMIN_TOKEN=$(curl -s -X POST ${PB_URL}/api/admins/auth-with-password \
  -H "Content-Type: application/json" \
  -d "{
    \"identity\": \"${ADMIN_EMAIL}\",
    \"password\": \"${ADMIN_PASSWORD}\"
  }" | jq -r '.token')

if [ -z "$ADMIN_TOKEN" ]; then
  echo "Failed to login as admin. Please check credentials."
  exit 1
fi

echo "Successfully logged in!"

# Function to create a collection
create_collection() {
  local name=$1
  local schema=$2
  local rules=$3
  
  echo "Creating collection: $name"
  
  curl -s -X POST ${PB_URL}/api/collections \
    -H "Authorization: Admin ${ADMIN_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\": \"$name\",
      \"type\": \"base\",
      \"schema\": $schema,
      \"listRule\": \"$rules\",
      \"viewRule\": \"$rules\",
      \"createRule\": \"$rules\",
      \"updateRule\": \"$rules\",
      \"deleteRule\": \"$rules\"
    }" > /dev/null
    
  echo "✓ Collection $name created"
}

# Create drinks collection
create_collection "drinks" '[
  {"name": "name", "type": "text", "required": true, "options": {"min": 1, "max": 255}},
  {"name": "type", "type": "select", "required": true, "options": {"maxSelect": 1, "values": ["whiskey", "bourbon", "scotch", "vodka", "gin", "rum", "tequila", "mezcal", "liqueur", "wine", "beer", "cocktail", "other"]}},
  {"name": "abv", "type": "number", "required": false, "options": {"min": 0, "max": 100}},
  {"name": "country", "type": "text", "required": false, "options": {"max": 100}},
  {"name": "barcode", "type": "text", "required": false, "options": {"max": 100}},
  {"name": "image", "type": "file", "required": false, "options": {"maxSelect": 1, "maxSize": 5242880, "mimeTypes": ["image/jpeg", "image/png", "image/gif", "image/webp"]}}
]' ""

# Create ingredients collection
create_collection "ingredients" '[
  {"name": "name", "type": "text", "required": true, "options": {"min": 1, "max": 255}},
  {"name": "category", "type": "select", "required": true, "options": {"maxSelect": 1, "values": ["spirit", "mixer", "garnish", "syrup", "juice", "bitter", "other"]}}
]' ""

# Get collection IDs for relations
DRINKS_ID=$(curl -s ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" | jq -r '.items[] | select(.name=="drinks") | .id')
  
INGREDIENTS_ID=$(curl -s ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" | jq -r '.items[] | select(.name=="ingredients") | .id')

# Create drink_ingredients junction table
echo "Creating collection: drink_ingredients"
curl -s -X POST ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"drink_ingredients\",
    \"type\": \"base\",
    \"schema\": [
      {\"name\": \"drink\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"$DRINKS_ID\", \"cascadeDelete\": true, \"maxSelect\": 1}},
      {\"name\": \"ingredient\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"$INGREDIENTS_ID\", \"cascadeDelete\": false, \"maxSelect\": 1}},
      {\"name\": \"quantity\", \"type\": \"text\", \"required\": false, \"options\": {\"max\": 100}}
    ],
    \"listRule\": \"\",
    \"viewRule\": \"\",
    \"createRule\": \"\",
    \"updateRule\": \"\",
    \"deleteRule\": \"\"
  }" > /dev/null
echo "✓ Collection drink_ingredients created"

# Create ratings collection
echo "Creating collection: ratings"
curl -s -X POST ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"ratings\",
    \"type\": \"base\",
    \"schema\": [
      {\"name\": \"user\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"_pb_users_auth_\", \"cascadeDelete\": true, \"maxSelect\": 1}},
      {\"name\": \"drink\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"$DRINKS_ID\", \"cascadeDelete\": true, \"maxSelect\": 1}},
      {\"name\": \"score\", \"type\": \"number\", \"required\": true, \"options\": {\"min\": 0, \"max\": 5}},
      {\"name\": \"note\", \"type\": \"text\", \"required\": false, \"options\": {\"max\": 1000}},
      {\"name\": \"photos\", \"type\": \"file\", \"required\": false, \"options\": {\"maxSelect\": 5, \"maxSize\": 5242880, \"mimeTypes\": [\"image/jpeg\", \"image/png\", \"image/gif\", \"image/webp\"]}}
    ],
    \"listRule\": \"@request.auth.id = user\",
    \"viewRule\": \"@request.auth.id = user\",
    \"createRule\": \"@request.auth.id = user\",
    \"updateRule\": \"@request.auth.id = user\",
    \"deleteRule\": \"@request.auth.id = user\"
  }" > /dev/null
echo "✓ Collection ratings created"

# Create inventory collection
echo "Creating collection: inventory"
curl -s -X POST ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"inventory\",
    \"type\": \"base\",
    \"schema\": [
      {\"name\": \"user\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"_pb_users_auth_\", \"cascadeDelete\": true, \"maxSelect\": 1}},
      {\"name\": \"drink\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"$DRINKS_ID\", \"cascadeDelete\": false, \"maxSelect\": 1}},
      {\"name\": \"quantity\", \"type\": \"number\", \"required\": true, \"options\": {\"min\": 0}},
      {\"name\": \"price\", \"type\": \"number\", \"required\": false, \"options\": {\"min\": 0}},
      {\"name\": \"purchaseDate\", \"type\": \"date\", \"required\": false}
    ],
    \"listRule\": \"@request.auth.id = user\",
    \"viewRule\": \"@request.auth.id = user\",
    \"createRule\": \"@request.auth.id = user\",
    \"updateRule\": \"@request.auth.id = user\",
    \"deleteRule\": \"@request.auth.id = user\"
  }" > /dev/null
echo "✓ Collection inventory created"

# Create badges collection
echo "Creating collection: badges"
curl -s -X POST ${PB_URL}/api/collections \
  -H "Authorization: Admin ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"badges\",
    \"type\": \"base\",
    \"schema\": [
      {\"name\": \"user\", \"type\": \"relation\", \"required\": true, \"options\": {\"collectionId\": \"_pb_users_auth_\", \"cascadeDelete\": true, \"maxSelect\": 1}},
      {\"name\": \"code\", \"type\": \"text\", \"required\": true, \"options\": {\"min\": 1, \"max\": 50}},
      {\"name\": \"unlockedAt\", \"type\": \"date\", \"required\": true}
    ],
    \"listRule\": \"@request.auth.id = user\",
    \"viewRule\": \"@request.auth.id = user\",
    \"createRule\": \"@request.auth.id = user\",
    \"updateRule\": \"@request.auth.id = user\",
    \"deleteRule\": null
  }" > /dev/null
echo "✓ Collection badges created"

echo ""
echo "✅ All collections created successfully!"
echo ""
echo "PocketBase Admin UI: ${PB_URL}/_/"
echo "Admin Email: ${ADMIN_EMAIL}"
echo "Admin Password: ${ADMIN_PASSWORD}"
echo ""
echo "Next steps:"
echo "1. Visit the admin UI to verify the collections"
echo "2. Configure OAuth providers if needed"
echo "3. Start building your Flutter app!"