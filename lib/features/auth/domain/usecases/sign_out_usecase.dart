import '../repositories/auth_repository.dart'; // ✅ Import the authentication repository interface

/// ✅ `SignOutUseCase` handles the business logic for user logout.
/// - It does not interact with Firebase directly.
/// - It only calls the `signOut()` method from the repository.
class SignOutUseCase {
  final AuthRepository
      repository; // ✅ Reference to the authentication repository

  /// ✅ Constructor - Requires an `AuthRepository` to be provided.
  /// - This ensures dependency injection.
  SignOutUseCase(this.repository);

  /// ✅ The `call()` method performs user sign-out.
  /// - Calls `signOut()` from the repository.
  /// - Returns a `Future<void>` (no data is returned, just logs out the user).
  Future<void> call() {
    return repository.signOut();
  }
}
