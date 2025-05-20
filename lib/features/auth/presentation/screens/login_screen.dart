import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🚀 BLoC for state management
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'register_screen.dart';
import 'home_screen.dart';

/// 🛠 Login Screen - Allows users to log into their accounts
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✏️ Controllers to capture user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // 🔄 Ensures the screen is scrollable on small devices
          padding: const EdgeInsets.symmetric(
              horizontal: 24), // 📏 Adds spacing on both sides
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // 🔹 Centers everything vertically
            children: [
              // 🔐 Login Icon
              const Icon(Icons.lock, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20), // 📏 Spacing between elements

              // 📝 Welcome Text
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Login to your account",
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
                obscureText: true, // 🔒 Hides password characters
              ),

              const SizedBox(height: 20),

              // 🔘 Login Button
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    // ❌ Show an error message if login fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is Authenticated) {
                    // ✅ Navigate to Home Screen if login is successful
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    text: "Login", // 🔘 Button Text
                    isLoading: state
                        is AuthLoading, // ⏳ Show loading indicator when signing in
                    onPressed: () {
                      // 🟢 Send SignInEvent when button is clicked
                      context.read<AuthBloc>().add(SignInEvent(
                            email:
                                emailController.text.trim(), // ✂️ Trim spaces
                            password: passwordController.text.trim(),
                          ));
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🔄 Navigate to Register Screen
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text("Don't have an account? Sign up",
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
