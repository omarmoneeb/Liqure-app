// Sample script to add test cabinet data
// This can be run via the PocketBase admin dashboard console

// Sample cabinet items data
const sampleCabinetItems = [
  {
    "drink_id": "sample_whiskey_1", // This should match an existing drink ID
    "user_id": "42cam700tc7j973", // This should match the logged-in user ID
    "status": "available",
    "added_at": new Date().toISOString().split('T')[0],
    "location": "main_shelf",
    "quantity": 1,
    "purchase_price": 45.99,
    "purchase_store": "Local Liquor Store",
    "fill_level": 85,
    "personal_notes": "Excellent whiskey with smoky finish",
    "tags": ["whiskey", "smoky", "premium"]
  },
  {
    "drink_id": "sample_rum_1",
    "user_id": "42cam700tc7j973",
    "status": "wishlist", 
    "added_at": new Date().toISOString().split('T')[0],
    "location": "main_shelf",
    "quantity": 1,
    "personal_notes": "Want to try this aged rum",
    "tags": ["rum", "aged", "caribbean"]
  },
  {
    "drink_id": "sample_vodka_1", 
    "user_id": "42cam700tc7j973",
    "status": "empty",
    "added_at": new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], // 30 days ago
    "finished_date": new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], // 2 days ago
    "location": "bar_cart",
    "quantity": 1,
    "purchase_price": 29.99,
    "fill_level": 0,
    "personal_notes": "Great for cocktails, will buy again",
    "tags": ["vodka", "cocktails", "smooth"]
  }
];

console.log("Sample cabinet items to add:");
console.log(JSON.stringify(sampleCabinetItems, null, 2));

// To add these items, you would need to:
// 1. Open PocketBase admin dashboard (http://10.1.0.71:8090/_/)
// 2. Go to Collections -> cabinet_items
// 3. Add records manually or use the API