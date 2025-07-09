import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  
  SignUpUseCase(this._repository);
  
  Future<User> call(String email, String password, {String? username}) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }
    
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }
    
    if (username != null && username.isNotEmpty && username.length < 3) {
      throw Exception('Username must be at least 3 characters');
    }
    
    return await _repository.signUpWithEmail(email, password, username: username);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}