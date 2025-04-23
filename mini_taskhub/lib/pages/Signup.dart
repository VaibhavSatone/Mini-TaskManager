import 'package:flutter/material.dart';
import 'package:mini_taskhub/auth/auth_services.dart';
import 'package:mini_taskhub/pages/Login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool agreedToTerms = false;

  // Validation functions
  String? validateField(String? value, String fieldType) {
    if (value == null || value.isEmpty) return 'Please enter your $fieldType';
    if (fieldType == 'email' &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email';
    }
    if (fieldType == 'password' && value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Signup function
  void signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final nameError = validateField(name, 'full name');
    final emailError = validateField(email, 'email');
    final passwordError = validateField(password, 'password');

    if (nameError == null &&
        emailError == null &&
        passwordError == null &&
        agreedToTerms) {
      try {
        final authService = AuthService();
        final result = await authService.signupWithEmailPassword(email, password);

        if (result != null) {
          // OPTIONAL: Save full name to Supabase
          // Uncomment the following block if your Supabase has a `profiles` table

          /*
          final userId = result.user?.id;
          if (userId != null) {
            await Supabase.instance.client
                .from('profiles')
                .insert({'id': userId, 'full_name': name});
          }
          */

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Signup successful! Please check your email for verification.')),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              nameError ?? emailError ?? passwordError ?? 'Please agree to the terms.'),
        ),
      );
    }
  }

  // UI layout
  Widget buildTextField(String hint, IconData icon,
      TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !passwordVisible : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF455A64),
          prefixIcon: Icon(icon, color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => passwordVisible = !passwordVisible),
                  color: Colors.white,
                )
              : null,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212730),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              buildTextField('Full Name', Icons.person, nameController, false),
              buildTextField(
                  'Email Address', Icons.email, emailController, false),
              buildTextField('Password', Icons.lock, passwordController, true),
              Row(
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    onChanged: (value) =>
                        setState(() => agreedToTerms = value!),
                    activeColor: const Color(0xFFFED36A),
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the Privacy Policy & Terms',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFED36A),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 20),
              const Text('Or continue with',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                label: const Text('Google',
                    style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Color(0xFFFED36A))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
