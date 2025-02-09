import 'package:blog_app/controllers/blogController.dart';
import 'package:blog_app/controllers/userController.dart';
import 'package:blog_app/pages/auth/signin/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_scaffold.dart';

// Profile Page widget
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for user and blog data
  final userController = Get.find<UserController>();
  final blogController = Get.find<BlogController>();

  @override
  void initState() {
    super.initState();
    // Fetch user's profile data when the page is initialized
    userController.getUsersProfile().catchError((error) {
      // Handle token expiration or unauthorized access
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while user data is being fetched
      if (userController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Handle case where no user data is available (possibly expired token)
      if (userController.user.isEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Oops! Something went wrong. Please log in again.",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Button to log out and redirect to login screen
                ElevatedButton(
                  onPressed: () {
                    userController.logout();
                    Get.offAll(() => const LoginScreen());
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ),
        );
      }

      // User data is available, proceed to show profile page
      return AppScaffold(
        initialIndex: 3, // Set initial selected index for the navigation bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Profile'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // User profile section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Avatar (Initial of the user's name)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userController.user['name'][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User's name
                    Text(
                      userController.user['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // User's email
                    Text(
                      userController.user['email'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Log out button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          userController.logout();
                          Get.offAll(() => const LoginScreen());
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // "My Blogs" section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Blogs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Blog List
                    ListView.builder(
                      shrinkWrap: true, // Prevent scrolling in the list view
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userController.posts.length,
                      itemBuilder: (context, index) {
                        final blog = userController.posts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            // Blog image
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                blog['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              blog['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              blog['createdAt'].split("T")[0], // Format date
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red[700],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  blogController.deletePost(blog['_id']);
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
