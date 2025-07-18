// Script to manually create cabinet_items collection
// Run this in PocketBase admin console

const collection = {
  "name": "cabinet_items",
  "type": "base",
  "system": false,
  "schema": [
    {
      "name": "id",
      "type": "text",
      "system": true,
      "required": true,
      "presentable": false,
      "options": {
        "min": 15,
        "max": 15,
        "pattern": "^[a-z0-9]+$"
      }
    },
    {
      "name": "drink_id",
      "type": "relation",
      "required": true,
      "presentable": false,
      "options": {
        "collectionId": "pbc_3720670791",
        "cascadeDelete": false,
        "minSelect": null,
        "maxSelect": 1
      }
    },
    {
      "name": "user_id", 
      "type": "relation",
      "required": true,
      "presentable": false,
      "options": {
        "collectionId": "_pb_users_auth_",
        "cascadeDelete": true,
        "minSelect": null,
        "maxSelect": 1
      }
    },
    {
      "name": "status",
      "type": "select",
      "required": true,
      "presentable": false,
      "options": {
        "maxSelect": 1,
        "values": ["available", "wishlist", "empty", "discontinued"]
      }
    },
    {
      "name": "added_at",
      "type": "date",
      "required": true,
      "presentable": false
    },
    {
      "name": "purchase_date",
      "type": "date",
      "required": false,
      "presentable": false
    },
    {
      "name": "opened_date",
      "type": "date", 
      "required": false,
      "presentable": false
    },
    {
      "name": "finished_date",
      "type": "date",
      "required": false,
      "presentable": false
    },
    {
      "name": "location",
      "type": "select",
      "required": false,
      "presentable": false,
      "options": {
        "maxSelect": 1,
        "values": ["main_shelf", "wine_fridge", "bar_cart", "storage_room", "custom"]
      }
    },
    {
      "name": "custom_location",
      "type": "text",
      "required": false,
      "presentable": false,
      "options": {
        "min": null,
        "max": 255
      }
    },
    {
      "name": "quantity",
      "type": "number",
      "required": false,
      "presentable": false,
      "options": {
        "min": 0,
        "max": null,
        "noDecimal": true
      }
    },
    {
      "name": "purchase_price",
      "type": "number",
      "required": false,
      "presentable": false,
      "options": {
        "min": 0,
        "max": null,
        "noDecimal": false
      }
    },
    {
      "name": "purchase_store",
      "type": "text",
      "required": false,
      "presentable": false,
      "options": {
        "min": null,
        "max": 255
      }
    },
    {
      "name": "purchase_notes",
      "type": "text",
      "required": false,
      "presentable": false,
      "options": {
        "min": null,
        "max": 1000
      }
    },
    {
      "name": "fill_level",
      "type": "number",
      "required": false,
      "presentable": false,
      "options": {
        "min": 0,
        "max": 100,
        "noDecimal": true
      }
    },
    {
      "name": "personal_notes",
      "type": "text",
      "required": false,
      "presentable": false,
      "options": {
        "min": null,
        "max": 2000
      }
    },
    {
      "name": "tags",
      "type": "json",
      "required": false,
      "presentable": false
    }
  ],
  "indexes": [
    "CREATE INDEX idx_cabinet_items_user_id ON cabinet_items (user_id)",
    "CREATE INDEX idx_cabinet_items_status ON cabinet_items (status)",
    "CREATE INDEX idx_cabinet_items_added_at ON cabinet_items (added_at)"
  ],
  "listRule": "@request.auth.id = user_id",
  "viewRule": "@request.auth.id = user_id", 
  "createRule": "@request.auth.id = user_id",
  "updateRule": "@request.auth.id = user_id",
  "deleteRule": "@request.auth.id = user_id"
};

console.log("Cabinet items collection schema:");
console.log(JSON.stringify(collection, null, 2));