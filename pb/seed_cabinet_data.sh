#!/bin/bash

# Script to add sample cabinet data via PocketBase API
# Make sure PocketBase is running on http://10.1.0.71:8090

POCKETBASE_URL="http://10.1.0.71:8090"
USER_ID="42cam700tc7j973"

echo "Adding sample cabinet items..."

# Add test items via curl
curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "whiskey_macallan_18",
    "user_id": "'$USER_ID'",
    "status": "available",
    "added_at": "2025-07-01",
    "location": "main_shelf",
    "quantity": 1,
    "purchase_price": 89.99,
    "purchase_store": "Fine Wine & Spirits",
    "fill_level": 95,
    "personal_notes": "Special occasion whiskey, smooth and complex",
    "tags": ["whiskey", "premium", "aged", "special"]
  }'

curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "bourbon_buffalo_trace",
    "user_id": "'$USER_ID'",
    "status": "available",
    "added_at": "2025-06-15",
    "location": "bar_cart",
    "quantity": 1,
    "purchase_price": 24.99,
    "purchase_store": "Local Liquor Store",
    "fill_level": 70,
    "personal_notes": "Great daily bourbon, excellent value",
    "tags": ["bourbon", "value", "daily"]
  }'

curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "rum_diplomatico_reserva",
    "user_id": "'$USER_ID'",
    "status": "available",
    "added_at": "2025-06-20",
    "location": "wine_fridge",
    "quantity": 1,
    "purchase_price": 45.99,
    "purchase_store": "Premium Spirits Co",
    "fill_level": 60,
    "personal_notes": "Venezuelan rum, perfect for sipping",
    "tags": ["rum", "venezuelan", "sipping", "smooth"]
  }'

curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "gin_hendricks",
    "user_id": "'$USER_ID'",
    "status": "available",
    "added_at": "2025-05-10",
    "location": "main_shelf",
    "quantity": 1,
    "purchase_price": 32.99,
    "purchase_store": "Downtown Spirits",
    "fill_level": 40,
    "personal_notes": "Unique botanical gin, great for cocktails",
    "tags": ["gin", "botanical", "cocktails", "cucumber"]
  }'

curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "vodka_grey_goose",
    "user_id": "'$USER_ID'",
    "status": "empty",
    "added_at": "2025-04-01",
    "finished_date": "2025-07-08",
    "location": "bar_cart",
    "quantity": 1,
    "purchase_price": 39.99,
    "fill_level": 0,
    "personal_notes": "Premium vodka, finished at party last week",
    "tags": ["vodka", "premium", "smooth", "party"]
  }'

curl -X POST "$POCKETBASE_URL/api/collections/cabinet_items/records" \
  -H "Content-Type: application/json" \
  -d '{
    "drink_id": "tequila_don_julio_1942",
    "user_id": "'$USER_ID'",
    "status": "wishlist",
    "added_at": "2025-07-10",
    "location": "main_shelf",
    "quantity": 1,
    "personal_notes": "Want to try this premium tequila for special occasions",
    "tags": ["tequila", "premium", "special", "aged"]
  }'

echo "Sample cabinet data added successfully!"