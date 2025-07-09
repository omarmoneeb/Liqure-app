import '../network/pocketbase_client.dart';

class SeedData {
  final PocketBaseClient _client;
  
  SeedData(this._client);
  
  static const List<Map<String, dynamic>> popularSpirits = [
    // Whiskey
    {
      'name': 'Jameson Irish Whiskey',
      'type': 'whiskey',
      'abv': 40.0,
      'country': 'Ireland',
      'description': 'Triple distilled Irish whiskey with a smooth, balanced taste.'
    },
    {
      'name': 'Jack Daniel\'s Old No. 7',
      'type': 'whiskey',
      'abv': 40.0,
      'country': 'United States',
      'description': 'Tennessee whiskey with a distinctive charcoal mellowing process.'
    },
    {
      'name': 'Macallan 12 Year',
      'type': 'scotch',
      'abv': 40.0,
      'country': 'Scotland',
      'description': 'Single malt Scotch whisky aged in sherry oak casks.'
    },
    {
      'name': 'Glenfiddich 12 Year',
      'type': 'scotch',
      'abv': 40.0,
      'country': 'Scotland',
      'description': 'Speyside single malt with fresh pear and subtle oak notes.'
    },
    {
      'name': 'Buffalo Trace',
      'type': 'bourbon',
      'abv': 45.0,
      'country': 'United States',
      'description': 'Kentucky straight bourbon with caramel and vanilla notes.'
    },
    {
      'name': 'Maker\'s Mark',
      'type': 'bourbon',
      'abv': 45.0,
      'country': 'United States',
      'description': 'Wheated bourbon with a smooth, sweet finish.'
    },
    
    // Vodka
    {
      'name': 'Grey Goose',
      'type': 'vodka',
      'abv': 40.0,
      'country': 'France',
      'description': 'Premium French vodka made from winter wheat.'
    },
    {
      'name': 'Absolut',
      'type': 'vodka',
      'abv': 40.0,
      'country': 'Sweden',
      'description': 'Swedish vodka with a clean, crisp taste.'
    },
    {
      'name': 'Belvedere',
      'type': 'vodka',
      'abv': 40.0,
      'country': 'Poland',
      'description': 'Polish rye vodka with a creamy texture.'
    },
    {
      'name': 'Tito\'s Handmade Vodka',
      'type': 'vodka',
      'abv': 40.0,
      'country': 'United States',
      'description': 'Corn-based vodka distilled in copper pot stills.'
    },
    
    // Gin
    {
      'name': 'Tanqueray',
      'type': 'gin',
      'abv': 47.3,
      'country': 'United Kingdom',
      'description': 'London Dry Gin with juniper, coriander, and angelica.'
    },
    {
      'name': 'Hendrick\'s',
      'type': 'gin',
      'abv': 44.0,
      'country': 'United Kingdom',
      'description': 'Scottish gin infused with cucumber and rose petals.'
    },
    {
      'name': 'Bombay Sapphire',
      'type': 'gin',
      'abv': 47.0,
      'country': 'United Kingdom',
      'description': 'London Dry Gin with 10 hand-selected botanicals.'
    },
    
    // Rum
    {
      'name': 'Bacardi Superior',
      'type': 'rum',
      'abv': 40.0,
      'country': 'Puerto Rico',
      'description': 'Light rum aged in oak barrels for smoothness.'
    },
    {
      'name': 'Captain Morgan Spiced Rum',
      'type': 'rum',
      'abv': 35.0,
      'country': 'Puerto Rico',
      'description': 'Spiced rum with vanilla and caramel notes.'
    },
    {
      'name': 'Mount Gay Eclipse',
      'type': 'rum',
      'abv': 40.0,
      'country': 'Barbados',
      'description': 'Golden rum with rich molasses and spice flavors.'
    },
    
    // Tequila
    {
      'name': 'Patrón Silver',
      'type': 'tequila',
      'abv': 40.0,
      'country': 'Mexico',
      'description': '100% agave tequila with crisp, smooth taste.'
    },
    {
      'name': 'Don Julio 1942',
      'type': 'tequila',
      'abv': 38.0,
      'country': 'Mexico',
      'description': 'Añejo tequila aged in oak barrels for 2.5 years.'
    },
    {
      'name': 'Herradura Silver',
      'type': 'tequila',
      'abv': 40.0,
      'country': 'Mexico',
      'description': '100% blue agave tequila with citrus and pepper notes.'
    },
    
    // Mezcal
    {
      'name': 'Del Maguey Vida',
      'type': 'mezcal',
      'abv': 42.0,
      'country': 'Mexico',
      'description': 'Artisanal mezcal with smoky, earthy flavors.'
    },
    {
      'name': 'Montelobos Espadín',
      'type': 'mezcal',
      'abv': 43.2,
      'country': 'Mexico',
      'description': 'Single-village mezcal with fresh agave character.'
    },
    
    // Liqueurs
    {
      'name': 'Grand Marnier',
      'type': 'liqueur',
      'abv': 40.0,
      'country': 'France',
      'description': 'Orange liqueur blended with cognac.'
    },
    {
      'name': 'Cointreau',
      'type': 'liqueur',
      'abv': 40.0,
      'country': 'France',
      'description': 'Triple sec orange liqueur with sweet and bitter orange peels.'
    },
    {
      'name': 'Kahlúa',
      'type': 'liqueur',
      'abv': 20.0,
      'country': 'Mexico',
      'description': 'Coffee liqueur with rum base and vanilla notes.'
    },
    {
      'name': 'Baileys Irish Cream',
      'type': 'liqueur',
      'abv': 17.0,
      'country': 'Ireland',
      'description': 'Irish whiskey blended with cream and cocoa.'
    },
    
    // Wine examples
    {
      'name': 'Caymus Cabernet Sauvignon',
      'type': 'wine',
      'abv': 14.5,
      'country': 'United States',
      'description': 'Rich Napa Valley Cabernet with dark fruit flavors.'
    },
    {
      'name': 'Dom Pérignon',
      'type': 'wine',
      'abv': 12.5,
      'country': 'France',
      'description': 'Prestige champagne with complex minerality.'
    },
    
    // Beer examples
    {
      'name': 'Guinness Draught',
      'type': 'beer',
      'abv': 4.2,
      'country': 'Ireland',
      'description': 'Irish dry stout with creamy texture and coffee notes.'
    },
    {
      'name': 'Heineken',
      'type': 'beer',
      'abv': 5.0,
      'country': 'Netherlands',
      'description': 'Premium lager with a mild bitter taste.'
    },
  ];
  
  Future<void> seedDrinks() async {
    try {
      print('Starting to seed drinks database...');
      
      for (int i = 0; i < popularSpirits.length; i++) {
        final drink = popularSpirits[i];
        
        try {
          await _client.instance.collection('drinks').create(body: drink);
          print('Created drink ${i + 1}/${popularSpirits.length}: ${drink['name']}');
        } catch (e) {
          print('Failed to create ${drink['name']}: $e');
        }
      }
      
      print('✅ Seeding completed! Created ${popularSpirits.length} drinks.');
    } catch (e) {
      print('❌ Seeding failed: $e');
      throw e;
    }
  }
  
  Future<void> clearDrinks() async {
    try {
      print('Clearing drinks database...');
      
      // Get all drinks
      final result = await _client.instance.collection('drinks').getList(perPage: 500);
      
      // Delete each drink
      for (final drink in result.items) {
        await _client.instance.collection('drinks').delete(drink.id);
      }
      
      print('✅ Cleared ${result.items.length} drinks from database.');
    } catch (e) {
      print('❌ Failed to clear drinks: $e');
      throw e;
    }
  }
  
  Future<int> getDrinksCount() async {
    try {
      final result = await _client.instance.collection('drinks').getList(page: 1, perPage: 1);
      return result.totalItems;
    } catch (e) {
      return 0;
    }
  }
}