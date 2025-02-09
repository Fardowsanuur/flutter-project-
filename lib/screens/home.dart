import 'package:blogapp/screens/post_screen.dart'; // Importing the screen that displays posts
import 'package:blogapp/screens/profile.dart'; // Importing the profile screen
import 'package:blogapp/services/user_service.dart'; // Importing user services (for logout functionality)
import 'package:flutter/material.dart';

import 'login.dart'; // Importing the login screen
import 'post_form.dart'; // Importing the post form screen

// Home screen that contains navigation between posts and profile
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0; // Tracks the selected index of BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'), // App title
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app), // Logout button icon
            onPressed: () {
              logout().then((value) => {
                    // Logs out the user and navigates to login screen
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false)
                  });
            },
          )
        ],
      ),
      body: currentIndex == 0
          ? PostScreen()
          : Profile(), // Display post screen or profile screen based on index
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigates to post form screen to add a new post
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostForm(
                    title: 'Add new post',
                  )));
        },
        child: Icon(Icons.add), // Floating button to add new post
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Floating button position
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5, // Space between floating action button and bottom bar
        elevation: 10, // Adds shadow effect to bottom bar
        clipBehavior: Clip.antiAlias, // Clips the shape smoothly
        shape:
            CircularNotchedRectangle(), // Creates a notch around floating action button
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), // Home icon
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), // Profile icon
                label: '')
          ],
          currentIndex: currentIndex, // Sets the current active tab
          onTap: (val) {
            setState(() {
              currentIndex = val; // Updates the selected tab index
            });
          },
        ),
      ),
    );
  }
}
