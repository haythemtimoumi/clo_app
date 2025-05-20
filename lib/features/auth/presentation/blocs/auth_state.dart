import 'package:equatable/equatable.dart'; // ✅ Import Equatable to simplify state comparisons

import 'package:rescoff/features/auth/data/models/user_model.dart';

/// ✅ `AuthState` is an abstract class that all authentication states extend.
/// - Using `Equatable` ensures that state changes are detected correctly.
abstract class AuthState extends Equatable {
  @override
  List<Object> get props =>
      []; // 🔹 Default: No properties (overridden in child classes)
}

/// ✅ `AuthInitial` is the **default state** when the app starts.
class AuthInitial extends AuthState {}

/// ✅ `AuthLoading` is emitted while authentication is in progress (e.g., login/signup).
class AuthLoading extends AuthState {}

/// ✅ `Authenticated` is emitted when a user successfully logs in.
/// - Stores the authenticated `UserModel` containing user data.
class Authenticated extends AuthState {
  final UserModel user; // 🔹 Stores user data

  /// ✅ Constructor requires a `UserModel` object.
  Authenticated(this.user);

  /// ✅ Override `props` so Flutter knows when the state has changed.
  @override
  List<Object> get props => [user];
}

/// ✅ `Unauthenticated` is emitted when the user logs out or the session expires.
class Unauthenticated extends AuthState {}

/// ✅ `AuthError` is emitted when an authentication failure occurs.
/// - Contains an error `message` that can be displayed to the user.
class AuthError extends AuthState {
  final String message; // 🔹 Stores error message

  /// ✅ Constructor requires an error message.
  AuthError(this.message);

  /// ✅ Override `props` so Flutter recognizes changes in the state.
  @override
  List<Object> get props => [message];
}
