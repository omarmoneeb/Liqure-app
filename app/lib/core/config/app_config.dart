import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String _pocketbaseUrlKey = 'POCKETBASE_URL';
  static const String _environmentKey = 'ENVIRONMENT';
  
  static String get pocketbaseUrl {
    // For mobile devices in development, use your machine's IP address
    // instead of localhost
    final url = dotenv.env[_pocketbaseUrlKey] ?? 'http://localhost:8090';
    
    // In development, if running on a real device, replace localhost
    // with your machine's IP address
    if (isDevelopment && url.contains('localhost')) {
      // Check if a dev IP is specifically configured
      final devIp = dotenv.env['DEV_IP'];
      if (devIp != null && devIp.isNotEmpty) {
        return url.replaceAll('localhost', devIp);
      }
      
      // If we're not on web and using localhost, show warning
      if (!kIsWeb) {
        if (kDebugMode) {
          debugPrint('⚠️ AppConfig: Using localhost on device may cause connectivity issues.');
          debugPrint('💡 Set DEV_IP in .env file to your machine\'s IP address');
          debugPrint('💡 Example: DEV_IP=192.168.1.100');
        }
      }
    }
    
    return url;
  }
  
  static String get environment => 
      dotenv.env[_environmentKey] ?? 'development';
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env file doesn't exist, use defaults
      if (kDebugMode) {
        debugPrint('Warning: .env file not found, using default configuration');
      }
    }
  }
}