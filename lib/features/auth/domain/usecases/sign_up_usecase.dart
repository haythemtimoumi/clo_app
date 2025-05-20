import '../repositories/auth_repository.dart'; // ✅ Import the authentication repository interface
import '../../data/models/user_model.dart'; // ✅ Import the UserModel (to return user data)

/// ✅ `SignUpUseCase` handles the business logic for user registration.
/// - It does not interact with Firebase directly.
/// - It only calls the `signUp()` method from the repository.
class SignUpUseCase {
  final AuthRepository
      repository; // ✅ Reference to the authentication repository

  /// ✅ Constructor - Requires an `AuthRepository` to be provided.
  /// - This ensures dependency injection.
  SignUpUseCase(this.repository);

  /// ✅ The `call()` method performs user sign-up.
  /// - Takes `email` and `password` as input.
  /// - Calls `signUp()` from the repository.
  /// - Returns a `Future<UserModel?>` with user data if successful.
  Future<UserModel?> call(String email, String password) {
    return repository.signUp(email, password);
  }
}
