import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

/// A stateless widget representing the Search Page.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      initialIndex: 3, // Sets the initial selected index for navigation

      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the default back arrow
        title: const Text('Search'), // Sets the title of the AppBar
        elevation: 0, // Removes AppBar shadow for a flat design
        backgroundColor: Colors.white, // Sets the background color of AppBar
        foregroundColor: Colors.black, // Sets the color of title and icons
      ),

      body: const Center(
        child: Text('Search Page'), // Placeholder text for the search page
      ),
    );
  }
}
