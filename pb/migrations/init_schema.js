// PocketBase Migration Script - Initialize Liquor Journal Schema
// This script creates all the collections needed for the Liquor Journal app

migrate((db) => {
  // Create drinks collection
  const drinks = new Collection({
    id: "drinks_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "drinks",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "name_field",
        name: "name",
        type: "text",
        required: true,
        options: {
          min: 1,
          max: 255,
          pattern: ""
        }
      },
      {
        system: false,
        id: "type_field",
        name: "type",
        type: "select",
        required: true,
        options: {
          maxSelect: 1,
          values: ["whiskey", "bourbon", "scotch", "vodka", "gin", "rum", "tequila", "mezcal", "liqueur", "wine", "beer", "cocktail", "other"]
        }
      },
      {
        system: false,
        id: "abv_field",
        name: "abv",
        type: "number",
        required: false,
        options: {
          min: 0,
          max: 100,
          noDecimal: false
        }
      },
      {
        system: false,
        id: "country_field",
        name: "country",
        type: "text",
        required: false,
        options: {
          min: 0,
          max: 100,
          pattern: ""
        }
      },
      {
        system: false,
        id: "image_field",
        name: "image",
        type: "file",
        required: false,
        options: {
          mimeTypes: ["image/jpeg", "image/png", "image/gif", "image/webp"],
          thumbs: ["100x100", "300x300"],
          maxSelect: 1,
          maxSize: 5242880
        }
      },
      {
        system: false,
        id: "barcode_field",
        name: "barcode",
        type: "text",
        required: false,
        options: {
          min: 0,
          max: 100,
          pattern: ""
        }
      }
    ],
    indexes: ["CREATE INDEX idx_drinks_barcode ON drinks (barcode)"],
    listRule: "",
    viewRule: "",
    createRule: "@request.auth.id != ''",
    updateRule: "@request.auth.id != ''",
    deleteRule: null
  });

  // Create ingredients collection
  const ingredients = new Collection({
    id: "ingredients_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "ingredients",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "name_field",
        name: "name",
        type: "text",
        required: true,
        options: {
          min: 1,
          max: 255,
          pattern: ""
        }
      },
      {
        system: false,
        id: "category_field",
        name: "category",
        type: "select",
        required: true,
        options: {
          maxSelect: 1,
          values: ["spirit", "mixer", "garnish", "syrup", "juice", "bitter", "other"]
        }
      }
    ],
    indexes: [],
    listRule: "",
    viewRule: "",
    createRule: "@request.auth.id != ''",
    updateRule: "@request.auth.id != ''",
    deleteRule: null
  });

  // Create drink_ingredients junction table
  const drinkIngredients = new Collection({
    id: "drink_ingredients_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "drink_ingredients",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "drink_field",
        name: "drink",
        type: "relation",
        required: true,
        options: {
          collectionId: "drinks_collection",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "ingredient_field",
        name: "ingredient",
        type: "relation",
        required: true,
        options: {
          collectionId: "ingredients_collection",
          cascadeDelete: false,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "quantity_field",
        name: "quantity",
        type: "text",
        required: false,
        options: {
          min: 0,
          max: 100,
          pattern: ""
        }
      }
    ],
    indexes: [],
    listRule: "",
    viewRule: "",
    createRule: "@request.auth.id != ''",
    updateRule: "@request.auth.id != ''",
    deleteRule: null
  });

  // Create ratings collection
  const ratings = new Collection({
    id: "ratings_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "ratings",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "user_field",
        name: "user",
        type: "relation",
        required: true,
        options: {
          collectionId: "_pb_users_auth_",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "drink_field",
        name: "drink",
        type: "relation",
        required: true,
        options: {
          collectionId: "drinks_collection",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "score_field",
        name: "score",
        type: "number",
        required: true,
        options: {
          min: 0,
          max: 5,
          noDecimal: false
        }
      },
      {
        system: false,
        id: "note_field",
        name: "note",
        type: "text",
        required: false,
        options: {
          min: 0,
          max: 1000,
          pattern: ""
        }
      },
      {
        system: false,
        id: "photos_field",
        name: "photos",
        type: "file",
        required: false,
        options: {
          mimeTypes: ["image/jpeg", "image/png", "image/gif", "image/webp"],
          thumbs: ["100x100", "300x300"],
          maxSelect: 5,
          maxSize: 5242880
        }
      }
    ],
    indexes: ["CREATE INDEX idx_ratings_user_drink ON ratings (user, drink)"],
    listRule: "@request.auth.id = user",
    viewRule: "@request.auth.id = user",
    createRule: "@request.auth.id = user",
    updateRule: "@request.auth.id = user",
    deleteRule: "@request.auth.id = user"
  });

  // Create inventory collection
  const inventory = new Collection({
    id: "inventory_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "inventory",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "user_field",
        name: "user",
        type: "relation",
        required: true,
        options: {
          collectionId: "_pb_users_auth_",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "drink_field",
        name: "drink",
        type: "relation",
        required: true,
        options: {
          collectionId: "drinks_collection",
          cascadeDelete: false,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "quantity_field",
        name: "quantity",
        type: "number",
        required: true,
        options: {
          min: 0,
          max: null,
          noDecimal: false
        }
      },
      {
        system: false,
        id: "price_field",
        name: "price",
        type: "number",
        required: false,
        options: {
          min: 0,
          max: null,
          noDecimal: false
        }
      },
      {
        system: false,
        id: "purchase_date_field",
        name: "purchaseDate",
        type: "date",
        required: false,
        options: {
          min: "",
          max: ""
        }
      }
    ],
    indexes: ["CREATE INDEX idx_inventory_user ON inventory (user)"],
    listRule: "@request.auth.id = user",
    viewRule: "@request.auth.id = user",
    createRule: "@request.auth.id = user",
    updateRule: "@request.auth.id = user",
    deleteRule: "@request.auth.id = user"
  });

  // Create badges collection
  const badges = new Collection({
    id: "badges_collection",
    created: new Date().toISOString(),
    updated: new Date().toISOString(),
    name: "badges",
    type: "base",
    system: false,
    schema: [
      {
        system: false,
        id: "user_field",
        name: "user",
        type: "relation",
        required: true,
        options: {
          collectionId: "_pb_users_auth_",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: null
        }
      },
      {
        system: false,
        id: "code_field",
        name: "code",
        type: "text",
        required: true,
        options: {
          min: 1,
          max: 50,
          pattern: ""
        }
      },
      {
        system: false,
        id: "unlocked_at_field",
        name: "unlockedAt",
        type: "date",
        required: true,
        options: {
          min: "",
          max: ""
        }
      }
    ],
    indexes: ["CREATE UNIQUE INDEX idx_badges_user_code ON badges (user, code)"],
    listRule: "@request.auth.id = user",
    viewRule: "@request.auth.id = user",
    createRule: "@request.auth.id = user",
    updateRule: "@request.auth.id = user",
    deleteRule: null
  });

  // Create all collections
  return dao.saveCollection(drinks) &&
         dao.saveCollection(ingredients) &&
         dao.saveCollection(drinkIngredients) &&
         dao.saveCollection(ratings) &&
         dao.saveCollection(inventory) &&
         dao.saveCollection(badges);
}, (db) => {
  // Rollback - delete all collections
  dao.deleteCollection(dao.findCollectionByNameOrId("drinks"));
  dao.deleteCollection(dao.findCollectionByNameOrId("ingredients"));
  dao.deleteCollection(dao.findCollectionByNameOrId("drink_ingredients"));
  dao.deleteCollection(dao.findCollectionByNameOrId("ratings"));
  dao.deleteCollection(dao.findCollectionByNameOrId("inventory"));
  dao.deleteCollection(dao.findCollectionByNameOrId("badges"));
});