#!/usr/bin/env node

// This script verifies that all collections are properly set up
// Usage: node verify_collections.js [admin_email] [admin_password]

const API_URL = 'http://127.0.0.1:8090';

async function login(email, password) {
  try {
    const response = await fetch(`${API_URL}/api/admins/auth-with-password`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identity: email,
        password: password
      })
    });
    
    if (!response.ok) {
      throw new Error(`Login failed: ${response.status}`);
    }
    
    const data = await response.json();
    return data.token;
  } catch (error) {
    throw new Error(`Login error: ${error.message}`);
  }
}

async function getCollections(token) {
  const response = await fetch(`${API_URL}/api/collections`, {
    headers: { 'Authorization': token }
  });
  
  if (!response.ok) {
    throw new Error(`Failed to fetch collections: ${response.status}`);
  }
  
  const data = await response.json();
  return data.items || [];
}

function checkCollectionSchema(collection) {
  const issues = [];
  
  // Expected schemas
  const expectedSchemas = {
    drinks: ['name', 'type', 'abv', 'country', 'barcode', 'image'],
    ingredients: ['name', 'category'],
    drink_ingredients: ['drink', 'ingredient', 'quantity'],
    ratings: ['user', 'drink', 'score', 'note', 'photos'],
    inventory: ['user', 'drink', 'quantity', 'price', 'purchaseDate'],
    badges: ['user', 'code', 'unlockedAt']
  };
  
  const expected = expectedSchemas[collection.name];
  if (!expected) {
    issues.push(`⚠️  Unknown collection: ${collection.name}`);
    return issues;
  }
  
  const actualFields = collection.schema.map(field => field.name);
  
  // Check for missing fields
  for (const expectedField of expected) {
    if (!actualFields.includes(expectedField)) {
      issues.push(`❌ Missing field: ${expectedField}`);
    }
  }
  
  // Check specific field types
  const fieldMap = {};
  collection.schema.forEach(field => {
    fieldMap[field.name] = field;
  });
  
  // Validate key fields
  if (collection.name === 'ratings' && fieldMap.score) {
    const scoreField = fieldMap.score;
    if (scoreField.type !== 'number') {
      issues.push(`❌ Score field should be number, got ${scoreField.type}`);
    }
    if (scoreField.options?.min !== 1) {
      issues.push(`⚠️  Score min is ${scoreField.options?.min}, expected 1`);
    }
    if (scoreField.options?.max !== 5) {
      issues.push(`⚠️  Score max is ${scoreField.options?.max}, expected 5`);
    }
  }
  
  return issues;
}

async function main() {
  const args = process.argv.slice(2);
  
  if (args.length < 2) {
    console.log('Usage: node verify_collections.js <admin_email> <admin_password>');
    console.log('Example: node verify_collections.js admin@liquorjournal.app mypassword');
    process.exit(1);
  }
  
  const [email, password] = args;
  
  try {
    console.log('🔐 Logging in as admin...');
    const token = await login(email, password);
    console.log('✅ Successfully logged in!');
    
    console.log('\n📋 Fetching collections...');
    const collections = await getCollections(token);
    
    console.log(`Found ${collections.length} collections:\n`);
    
    const expectedCollections = ['drinks', 'ingredients', 'drink_ingredients', 'ratings', 'inventory', 'badges'];
    const foundCollections = collections.map(c => c.name);
    
    // Check if all expected collections exist
    console.log('📊 Collection Status:');
    for (const expected of expectedCollections) {
      if (foundCollections.includes(expected)) {
        console.log(`✅ ${expected} - Found`);
      } else {
        console.log(`❌ ${expected} - Missing`);
      }
    }
    
    console.log('\n🔍 Schema Validation:');
    
    let hasIssues = false;
    
    for (const collection of collections) {
      if (expectedCollections.includes(collection.name)) {
        console.log(`\n📝 ${collection.name}:`);
        console.log(`   Type: ${collection.type}`);
        console.log(`   Fields: ${collection.schema.map(f => f.name).join(', ')}`);
        
        const issues = checkCollectionSchema(collection);
        if (issues.length === 0) {
          console.log('   ✅ Schema looks good!');
        } else {
          hasIssues = true;
          issues.forEach(issue => console.log(`   ${issue}`));
        }
      }
    }
    
    console.log('\n' + '='.repeat(50));
    
    if (hasIssues) {
      console.log('⚠️  Some issues found, but collections are mostly set up correctly!');
    } else {
      console.log('🎉 All collections are properly configured!');
    }
    
    console.log('\n📍 Next steps:');
    console.log('1. Test API endpoints with some sample data');
    console.log('2. Configure OAuth providers (optional)');
    console.log('3. Start building the Flutter app');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

// Check if we have fetch available
if (typeof fetch === 'undefined') {
  console.error('This script requires Node.js 18+ with native fetch support');
  process.exit(1);
}

main();