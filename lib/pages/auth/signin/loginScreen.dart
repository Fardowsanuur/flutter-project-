import 'package:blog_app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//..
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // Controls password visibility
  bool _keepSignedIn = false; // Checkbox state for keeping user signed in
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String? _passwordError; // Error message for password field
  UserController userController = UserController(); // Controller instance for user operations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400, // Restricts max width for responsiveness
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Adds horizontal padding
            child: Form(
              key: _formKey, // Assigns form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Login Title
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field Label
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email Input Field
                  TextFormField(
                    controller: userController.emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field Label
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Password Input Field
                  TextFormField(
                    controller: userController.passwordController,
                    obscureText: !_isPasswordVisible, // Toggles password visibility
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorText: _passwordError, // Displays password error if any
                      errorStyle: const TextStyle(
                        color: Colors.red,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggles password visibility
                          });
                        },
                      ),
                    ),
                  ),

                 // Forgot Password Button
                  TextButton(
                    onPressed: () {
                      // Handle forgot password functionality
                    },
                    child: Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Keep me signed in checkbox
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: _keepSignedIn,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _keepSignedIn = value ?? false;
                  //         });
                  //       },
                  //       activeColor: Colors.green,
                  //     ),
                  //     const Text(
                  //       'Keep me signed in',
                  //       style: TextStyle(
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                  // Login Button
                  // Login Button with Loading Indicator
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: userController.loading.value
                            ? null // Disables button while loading
                            : () {
                                userController.login(); // Calls login function
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: userController.loading.value
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              ) // Shows loader while processing
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an Account? ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigates to sign up screen
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign up here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
