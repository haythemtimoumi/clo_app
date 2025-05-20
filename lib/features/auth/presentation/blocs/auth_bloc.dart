import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Import BLoC package for state management

// ✅ Import authentication use cases (handles business logic)
import 'package:rescoff/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:rescoff/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:rescoff/features/auth/domain/usecases/sign_out_usecase.dart';

// ✅ Import event and state classes
import 'auth_event.dart';
import 'auth_state.dart';

/// ✅ `AuthBloc` manages authentication-related states and events.
/// - It listens for **user actions** (sign in, sign up, sign out).
/// - Calls the respective use cases.
/// - Emits new states based on success or failure.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUp; // ✅ Handles user sign-up
  final SignInUseCase signIn; // ✅ Handles user sign-in
  final SignOutUseCase signOut; // ✅ Handles user sign-out

  /// ✅ Constructor - Receives use cases via dependency injection.
  /// - `super(AuthInitial())` sets the **initial state** to `AuthInitial`.
  AuthBloc({required this.signUp, required this.signIn, required this.signOut})
      : super(AuthInitial()) {
    /// ✅ Listen for `SignUpEvent`
    /// - Calls `signUpUseCase` with the provided email & password.
    /// - Emits `AuthLoading()` while processing.
    /// - If successful, emits `Authenticated(user)`.
    /// - If failed, emits `AuthError(errorMessage)`.
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading()); // 🔄 Show loading state
      try {
        final user =
            await signUp(event.email, event.password); // Call sign-up use case
        emit(Authenticated(user!)); // ✅ Emit authenticated state with user data
      } catch (e) {
        emit(AuthError(e.toString())); // ❌ Emit error state with error message
      }
    });

    /// ✅ Listen for `SignInEvent`
    /// - Calls `signInUseCase` with the provided email & password.
    /// - Emits `AuthLoading()` while processing.
    /// - If successful, emits `Authenticated(user)`.
    /// - If failed, emits `AuthError(errorMessage)`.
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading()); // 🔄 Show loading state
      try {
        final user =
            await signIn(event.email, event.password); // Call sign-in use case
        emit(Authenticated(user!)); // ✅ Emit authenticated state with user data
      } catch (e) {
        emit(AuthError(e.toString())); // ❌ Emit error state with error message
      }
    });

    /// ✅ Listen for `SignOutEvent`
    /// - Calls `signOutUseCase`.
    /// - Emits `Unauthenticated()` after signing out.
    on<SignOutEvent>((event, emit) async {
      await signOut(); // 🔹 Call sign-out use case
      emit(
          Unauthenticated()); // ✅ Emit unauthenticated state (user is logged out)
    });
  }
}
