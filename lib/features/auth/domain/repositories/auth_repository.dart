import '../../data/models/user_model.dart';

/// ✅ Abstract class defining the authentication methods (contract)
/// - This ensures that any class implementing `AuthRepository`
///   must provide concrete implementations for the methods below.
abstract class AuthRepository {
  /// ✅ Handles user sign-up (registration)
  /// - Takes `email` and `password` as input.
  /// - Returns a `UserModel` if registration is successful.
  /// - Returns `null` if registration fails.
  Future<UserModel?> signUp(String email, String password);

  /// ✅ Handles user sign-in (login)
  /// - Takes `email` and `password` as input.
  /// - Returns a `UserModel` if login is successful.
  /// - Returns `null` if login fails.
  Future<UserModel?> signIn(String email, String password);

  /// ✅ Handles user sign-out (logout)
  /// - Does not return anything (void function).
  Future<void> signOut();

  /// ✅ Fetch full user profile from Firestore using UID
  Future<UserModel?> getUserProfile(String uid);

  /// ✅ Update user profile in Firestore
  Future<void> updateUserProfile(UserModel user);
}
