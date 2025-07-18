// Script to add test cabinet data via PocketBase API
// Run this in the PocketBase admin console or via node.js with PocketBase SDK

const testItems = [
  {
    drink_id: "whiskey_macallan_18",
    user_id: "42cam700tc7j973", 
    status: "available",
    added_at: "2025-07-01",
    location: "main_shelf",
    quantity: 1,
    purchase_price: 89.99,
    purchase_store: "Fine Wine & Spirits",
    fill_level: 95,
    personal_notes: "Special occasion whiskey, smooth and complex",
    tags: ["whiskey", "premium", "aged", "special"]
  },
  {
    drink_id: "bourbon_buffalo_trace",
    user_id: "42cam700tc7j973",
    status: "available", 
    added_at: "2025-06-15",
    location: "bar_cart",
    quantity: 1,
    purchase_price: 24.99,
    purchase_store: "Local Liquor Store",
    fill_level: 70,
    personal_notes: "Great daily bourbon, excellent value",
    tags: ["bourbon", "value", "daily"]
  },
  {
    drink_id: "rum_diplomatico_reserva",
    user_id: "42cam700tc7j973", 
    status: "available",
    added_at: "2025-06-20",
    location: "wine_fridge", 
    quantity: 1,
    purchase_price: 45.99,
    purchase_store: "Premium Spirits Co",
    fill_level: 60,
    personal_notes: "Venezuelan rum, perfect for sipping",
    tags: ["rum", "venezuelan", "sipping", "smooth"]
  },
  {
    drink_id: "gin_hendricks",
    user_id: "42cam700tc7j973",
    status: "available",
    added_at: "2025-05-10", 
    location: "main_shelf",
    quantity: 1,
    purchase_price: 32.99,
    purchase_store: "Downtown Spirits",
    fill_level: 40,
    personal_notes: "Unique botanical gin, great for cocktails",
    tags: ["gin", "botanical", "cocktails", "cucumber"]
  },
  {
    drink_id: "vodka_grey_goose",
    user_id: "42cam700tc7j973",
    status: "empty",
    added_at: "2025-04-01",
    finished_date: "2025-07-08", 
    location: "bar_cart",
    quantity: 1,
    purchase_price: 39.99,
    fill_level: 0,
    personal_notes: "Premium vodka, finished at party last week",
    tags: ["vodka", "premium", "smooth", "party"]
  },
  {
    drink_id: "tequila_don_julio_1942",
    user_id: "42cam700tc7j973",
    status: "wishlist",
    added_at: "2025-07-10",
    location: "main_shelf",
    quantity: 1,
    personal_notes: "Want to try this premium tequila for special occasions",
    tags: ["tequila", "premium", "special", "aged"]
  },
  {
    drink_id: "scotch_lagavulin_16",
    user_id: "42cam700tc7j973", 
    status: "available",
    added_at: "2025-03-15",
    location: "storage_room",
    quantity: 1,
    purchase_price: 79.99,
    purchase_store: "Whiskey Warehouse",
    fill_level: 85,
    personal_notes: "Peated Islay scotch, intense and smoky",
    tags: ["scotch", "islay", "peated", "smoky", "intense"]
  },
  {
    drink_id: "cognac_hennessy_vs",
    user_id: "42cam700tc7j973",
    status: "available", 
    added_at: "2025-02-20",
    location: "main_shelf",
    quantity: 1,
    purchase_price: 54.99,
    purchase_store: "Elite Spirits",
    fill_level: 90,
    personal_notes: "Classic cognac, perfect after dinner",
    tags: ["cognac", "classic", "after-dinner", "smooth"]
  },
  {
    drink_id: "mezcal_del_maguey_vida", 
    user_id: "42cam700tc7j973",
    status: "available",
    added_at: "2025-01-30",
    location: "bar_cart",
    quantity: 1, 
    purchase_price: 28.99,
    purchase_store: "Agave Imports",
    fill_level: 55,
    personal_notes: "Smoky mezcal, great for experimenting with cocktails",
    tags: ["mezcal", "smoky", "cocktails", "experimental"]
  },
  {
    drink_id: "japanese_whisky_nikka_coffey_grain",
    user_id: "42cam700tc7j973",
    status: "available",
    added_at: "2025-01-15", 
    location: "wine_fridge",
    quantity: 1,
    purchase_price: 67.99,
    purchase_store: "Japanese Import Store", 
    fill_level: 75,
    personal_notes: "Exceptional Japanese whisky, smooth and balanced",
    tags: ["japanese", "whisky", "smooth", "balanced", "premium"]
  }
];

console.log("Test cabinet items to add:");
console.log(JSON.stringify(testItems, null, 2));

// Instructions for adding via PocketBase admin:
console.log("\nTo add these items:");
console.log("1. Go to PocketBase admin: http://10.1.0.71:8090/_/");
console.log("2. Navigate to Collections > cabinet_items");
console.log("3. Click 'New record' for each item");
console.log("4. Copy the data from above");