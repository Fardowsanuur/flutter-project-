import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blogController.dart';
import '../widgets/app_scaffold.dart';
import 'home.dart';

// BookmarksPage is a stateless widget that displays bookmarked blog posts.
class BookmarksPage extends GetView<BlogController> {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      initialIndex: 1, // Sets the bottom navigation bar index to Bookmarks
      appBar: AppBar(
        title: const Text('Bookmarks'),
        elevation: 0, // Removes the shadow from the AppBar
        backgroundColor: Colors.white, // Sets AppBar background color to white
        foregroundColor: Colors.black, // Sets AppBar text color to black
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: Obx(() {
        // If there are no bookmarked posts, display a message
        if (controller.bookmarkedPosts.isEmpty) {
          return const Center(
            child: Text('No bookmarked posts yet'),
          );
        }

        // Displays a list of bookmarked blog posts
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bookmarkedPosts.length,
          itemBuilder: (context, index) {
            final blog = controller.bookmarkedPosts[index];
            return BlogItem(
              blog: blog,
              onTap: () => Get.toNamed('/blog-details', arguments: blog),
              // Navigates to blog details page when tapped
            );
          },
        );
      }),
    );
  }
}
