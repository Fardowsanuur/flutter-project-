import 'package:blog_app/controllers/userController.dart';
import 'package:blog_app/middleware/auth_middleware.dart';
import 'package:blog_app/pages/add_blog.dart';
import 'package:blog_app/pages/auth/signin/loginScreen.dart';
import 'package:blog_app/pages/auth/signup/signupScreen.dart';
import 'package:blog_app/pages/bookmarks_page.dart';
import 'package:blog_app/pages/home.dart';
import 'package:blog_app/pages/profile.dart';
import 'package:blog_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// The entry point of the Flutter application.
void main() async {
  await GetStorage.init(); // Initialize GetStorage for persistent storage
  Get.put(UserController()); // Register UserController for dependency injection
  runApp(MyApp()); // Run the main application widget
}

class MyApp extends StatelessWidget {
  final storage = GetStorage(); // Instance of GetStorage for managing local storage

  MyApp({super.key});

  /// Determines the initial route based on authentication status.
  String _getInitialRoute() {
    final token = storage.read('token'); // Read the stored authentication token
    return (token != null && token.isNotEmpty) ? '/' : '/signin'; // If token exists, navigate to Home, otherwise Sign In
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'Crypto Exchange App', // Application title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets primary theme color
        scaffoldBackgroundColor: Colors.grey[100], // Background color for scaffold
      ),
      defaultTransition: Transition.noTransition, // Disables transitions between pages
      initialRoute: _getInitialRoute(), // Set the initial route dynamically

      // Define application routes using GetX's routing system
      getPages: [
        GetPage(
          name: '/signup',
          page: () => SignupScreen(), // Navigates to the signup screen
          middlewares: [AuthMiddleware()], // Applies authentication middleware
        ),
        GetPage(
          name: '/signin',
          page: () => LoginScreen(), // Navigates to the login screen
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/',
          page: () => Home(), // Navigates to the home page
          middlewares: [AuthMiddleware()],
          preventDuplicates: true, // Prevents duplicate page instances
        ),
        GetPage(
          name: '/bookmarks',
          page: () => BookmarksPage(), // Navigates to the bookmarks page
          middlewares: [AuthMiddleware()],
          preventDuplicates: true,
        ),
        GetPage(
          name: '/profile',
          page: () => ProfilePage(), // Navigates to the profile page
          middlewares: [AuthMiddleware()],
          preventDuplicates: true,
        ),
        GetPage(
          name: '/addBlog',
          page: () => AddBlogPage(), // Navigates to the add blog page
          middlewares: [AuthMiddleware()],
          preventDuplicates: true,
        ),
      ],
    );
  }
}
