import 'package:blog_app/pages/add_blog.dart';
import 'package:blog_app/pages/bookmarks_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/search.dart';

class AppScaffold extends StatefulWidget {
  final Widget body; // The main content of the page
  final String? title; // Optional title for the AppBar
  final bool showBackButton; // Determines whether to show a back button
  final PreferredSizeWidget? appBar; // Allows a custom AppBar
  final int initialIndex; // Initial selected index for Bottom Navigation Bar

  const AppScaffold({
    Key? key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.appBar,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex; // Stores the current selected index

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize the selected index from the widget
  }

  /// Handles navigation when a bottom navigation item is tapped
  void _onItemTapped(int index) {
    // Special case: "Add Blog" button (index 2) should open a new page without updating the index
    if (index == 2) {
      Get.toNamed('/addBlog'); // Navigate to the "Add Blog" page
      return; // Exit function to prevent updating the selected index
    }

    // Update the selected index
    setState(() {
      _selectedIndex = index;
    });

    // Determine the navigation route based on index
    String route = '';
    switch (index) {
      case 0:
        route = '/'; // Navigate to Home page
        break;
      case 1:
        route = '/bookmarks'; // Navigate to Bookmarks page
        break;
      case 3:
        route = '/profile'; // Navigate to Profile page
        break;
    }

    // Navigate to the selected route
    if (route.isNotEmpty) {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar, // Use the provided AppBar if available
      backgroundColor: Colors.grey[50], // Light background color
      body: widget.body, // Display the main content of the page

      /// Bottom Navigation Bar for navigating between main sections of the app
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        backgroundColor: Colors.white, // White background color for contrast
        selectedItemColor: Colors.blue, // Highlight color for selected item
        unselectedItemColor: Colors.grey, // Gray color for unselected items
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle navigation on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // Default home icon
            activeIcon: Icon(Icons.home), // Active state home icon
            label: 'Home', // Label for home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border), // Default bookmark icon
            activeIcon: Icon(Icons.bookmark), // Active state bookmark icon
            label: 'Bookmark', // Label for bookmarks
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), // "Add Blog" button (does not change index)
            label: 'Add', // Label for add button
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Default profile icon
            activeIcon: Icon(Icons.person), // Active state profile icon
            label: 'Profile', // Label for profile
          ),
        ],
      ),
    );
  }
}
