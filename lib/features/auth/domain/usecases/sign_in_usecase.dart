import '../repositories/auth_repository.dart'; // ✅ Import the authentication repository interface
import '../../data/models/user_model.dart'; // ✅ Import the UserModel (to return user data)

/// ✅ The `SignInUseCase` class handles the **business logic** for signing in.
/// - It does not interact with Firebase directly.
/// - It only calls the repository method (`signIn()`).
class SignInUseCase {
  final AuthRepository
      repository; // ✅ Reference to the authentication repository

  /// ✅ Constructor - Requires an `AuthRepository` to be provided.
  /// - This ensures dependency injection.
  SignInUseCase(this.repository);

  /// ✅ The `call()` method performs user sign-in.
  /// - Takes `email` and `password` as input.
  /// - Calls `signIn()` from the repository.
  /// - Returns a `Future<UserModel?>` with user data if successful.
  Future<UserModel?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
