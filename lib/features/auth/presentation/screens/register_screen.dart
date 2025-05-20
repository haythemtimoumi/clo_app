import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'complete_profile_screen.dart';
import '../../data/models/user_model.dart';

/// 🛠 Register Screen - Allows users to create a new account
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ✏️ Controllers to capture user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 👤 User Icon
              const Icon(Icons.person_add, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),

              // 📝 Create Account Text
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Sign up to get started",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),

              const SizedBox(height: 30),

              // 📧 Email Input
              CustomTextField(
                hintText: "Enter your email",
                icon: Icons.email,
                controller: emailController,
              ),

              const SizedBox(height: 12),

              // 🔑 Password Input
              CustomTextField(
                hintText: "Enter your password",
                icon: Icons.lock,
                controller: passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // 🔘 Register Button
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    // ❌ Show error message if registration fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is Authenticated) {
                    // ✅ Navigate to CompleteProfileScreen with user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompleteProfileScreen(user: state.user),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    text: "Register",
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      context.read<AuthBloc>().add(SignUpEvent(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ));
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🔄 Navigate to Login Screen
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login",
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
