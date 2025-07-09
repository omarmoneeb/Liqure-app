import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketBaseClient {
  static const String baseUrl = 'http://10.1.0.71:8090';
  
  late final PocketBase _pb;
  
  PocketBaseClient() {
    print('🔧 PocketBaseClient: Initializing with baseUrl: $baseUrl');
    _pb = PocketBase(baseUrl);
    print('🔧 PocketBaseClient: Initialized successfully');
  }
  
  PocketBase get instance => _pb;
  
  // Auth methods
  Future<RecordAuth> signInWithEmail(String email, String password) async {
    return await _pb.collection('users').authWithPassword(email, password);
  }
  
  Future<RecordModel> signUpWithEmail(String email, String password, {String? username}) async {
    final data = {
      'email': email,
      'password': password,
      'passwordConfirm': password,
      if (username != null) 'username': username,
    };
    
    return await _pb.collection('users').create(body: data);
  }
  
  void signOut() {
    _pb.authStore.clear();
  }
  
  bool isAuthenticated() {
    return _pb.authStore.isValid;
  }
  
  RecordModel? getCurrentUser() {
    return _pb.authStore.model;
  }
  
  Future<void> refreshToken() async {
    if (_pb.authStore.isValid) {
      await _pb.collection('users').authRefresh();
    }
  }
  
  Future<void> sendPasswordReset(String email) async {
    await _pb.collection('users').requestPasswordReset(email);
  }
  
  Future<RecordModel> updateProfile(String id, Map<String, dynamic> data) async {
    return await _pb.collection('users').update(id, body: data);
  }
  
  Future<void> deleteUser(String id) async {
    await _pb.collection('users').delete(id);
  }
}

// Riverpod provider
final pocketBaseClientProvider = Provider<PocketBaseClient>((ref) {
  return PocketBaseClient();
});