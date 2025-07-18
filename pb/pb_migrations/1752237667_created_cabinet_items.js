/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = new Collection({
    "createRule": "@request.auth.id = user_id",
    "deleteRule": "@request.auth.id = user_id",
    "fields": [
      {
        "autogeneratePattern": "[a-z0-9]{15}",
        "hidden": false,
        "id": "text3208210256",
        "max": 15,
        "min": 15,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_3720670791",
        "hidden": false,
        "id": "relation_drink_id",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "drink_id",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": true,
        "collectionId": "_pb_users_auth_",
        "hidden": false,
        "id": "relation_user_id",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "user_id",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "select_status",
        "maxSelect": 1,
        "name": "status",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "available",
          "wishlist", 
          "empty",
          "discontinued"
        ]
      },
      {
        "hidden": false,
        "id": "date_added_at",
        "max": "",
        "min": "",
        "name": "added_at",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "date_purchase_date",
        "max": "",
        "min": "",
        "name": "purchase_date",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "date_opened_date",
        "max": "",
        "min": "",
        "name": "opened_date",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "date_finished_date",
        "max": "",
        "min": "",
        "name": "finished_date",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "select_location",
        "maxSelect": 1,
        "name": "location",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "select",
        "values": [
          "main_shelf",
          "wine_fridge",
          "bar_cart",
          "storage_room",
          "custom"
        ]
      },
      {
        "hidden": false,
        "id": "text_custom_location",
        "max": 255,
        "min": 0,
        "name": "custom_location",
        "pattern": "",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "number_quantity",
        "max": null,
        "min": 0,
        "name": "quantity",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "number_purchase_price",
        "max": null,
        "min": 0,
        "name": "purchase_price",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "text_purchase_store",
        "max": 255,
        "min": 0,
        "name": "purchase_store",
        "pattern": "",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "text_purchase_notes",
        "max": 1000,
        "min": 0,
        "name": "purchase_notes",
        "pattern": "",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "number_fill_level",
        "max": 100,
        "min": 0,
        "name": "fill_level",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "text_personal_notes",
        "max": 2000,
        "min": 0,
        "name": "personal_notes",
        "pattern": "",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "json_tags",
        "name": "tags",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "autodate_created",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "autodate_updated",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      }
    ],
    "id": "cabinet_items_collection",
    "indexes": [
      "CREATE INDEX `idx_cabinet_items_user_id` ON `cabinet_items` (`user_id`)",
      "CREATE INDEX `idx_cabinet_items_status` ON `cabinet_items` (`status`)",
      "CREATE INDEX `idx_cabinet_items_added_at` ON `cabinet_items` (`added_at`)"
    ],
    "listRule": "@request.auth.id = user_id",
    "name": "cabinet_items",
    "system": false,
    "type": "base",
    "updateRule": "@request.auth.id = user_id",
    "viewRule": "@request.auth.id = user_id"
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("cabinet_items_collection");

  return app.delete(collection);
});