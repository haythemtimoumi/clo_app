import 'package:equatable/equatable.dart'; // ✅ Import Equatable for event comparison

/// ✅ `AuthEvent` is an abstract class that all authentication events extend.
/// - `Equatable` is used to compare instances efficiently.
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props =>
      []; // 🔹 Default: No properties (overridden in child classes)
}

/// ✅ `SignUpEvent` is triggered when the user signs up.
/// - Contains `email` and `password` as required parameters.
class SignUpEvent extends AuthEvent {
  final String email, password; // 🔹 User's email and password

  /// ✅ Constructor requires email and password.
  SignUpEvent({required this.email, required this.password});

  /// ✅ Override `props` so events with the same values are treated as equal.
  @override
  List<Object> get props => [email, password];
}

/// ✅ `SignInEvent` is triggered when the user signs in.
/// - Contains `email` and `password` as required parameters.
class SignInEvent extends AuthEvent {
  final String email, password; // 🔹 User's email and password

  /// ✅ Constructor requires email and password.
  SignInEvent({required this.email, required this.password});

  /// ✅ Override `props` so events with the same values are treated as equal.
  @override
  List<Object> get props => [email, password];
}

/// ✅ `SignOutEvent` is triggered when the user logs out.
/// - This event has no properties because signing out doesn't require input.
class SignOutEvent extends AuthEvent {}
