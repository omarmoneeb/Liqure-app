import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  
  SignOutUseCase(this._repository);
  
  Future<void> call() async {
    await _repository.signOut();
  }
}