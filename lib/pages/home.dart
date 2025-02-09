import 'package:blog_app/controllers/blogController.dart';
import 'package:blog_app/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_scaffold.dart';
import 'package:timeago/timeago.dart' as timeago;

// Home page where a list of blogs is displayed
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final blogController = Get.put(BlogController()); // Blog controller instance

  @override
  void initState() {
    super.initState();
    blogController.getBlogPost(); // Fetch the blog posts when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Blogs'), // Title of the AppBar
        elevation: 0, // Removes shadow from the AppBar
        backgroundColor: Colors.white, // AppBar background color
        foregroundColor: Colors.black, // Text color in the AppBar
        automaticallyImplyLeading: false, // Removes the back arrow from AppBar
      ),
      body: Obx(() {
        // Reactive widget updates based on the controller's state
        if (blogController.loading.value) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner
        }

        if (blogController.data.isEmpty) {
          return const Center(child: Text('No blogs found')); // Show message if no blogs available
        }

        // ListView to display blog posts
        return ListView.builder(
          padding: const EdgeInsets.all(16), // Padding around the list
          itemCount: blogController.data.length, // Number of blog posts
          itemBuilder: (context, index) {
            final blog = blogController.data[index]; // Get individual blog data
            return BlogItem(
              blog: blog, 
              onTap: () => Get.to(() => BlogDetailsPage(blog: blog)), // Navigate to blog details page on tap
            );
          },
        );
      }),
    );
  }
}

// Widget to display each blog item in the list
class BlogItem extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap; // Callback function when tapped

  const BlogItem({
    Key? key,
    required this.blog,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blogController = Get.find<BlogController>(); // Get the blog controller instance

    return Card(
      margin: const EdgeInsets.only(bottom: 16), // Card margin between items
      child: InkWell(
        onTap: onTap, // Trigger onTap when the card is tapped
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.image.isNotEmpty)
              Image.network(
                blog.image, // Display the blog image
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover, // Cover the space with the image
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200, // Placeholder in case of error
                  color: Colors.grey[300],
                  child: const Icon(Icons.error), // Display error icon if image fails to load
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16), // Padding for the blog content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align title and bookmark icon
                    children: [
                      Expanded(
                        child: Text(
                          blog.title, // Display the blog title
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Obx(() => IconButton(
                        icon: Icon(
                          blogController.isBookmarked(blog)
                              ? Icons.bookmark // Display filled bookmark icon
                              : Icons.bookmark_border, // Display empty bookmark icon
                          color: blogController.isBookmarked(blog)
                              ? Colors.blue // Color when bookmarked
                              : Colors.grey, // Color when not bookmarked
                        ),
                        onPressed: () =>
                            blogController.toggleBookmark(blog), // Toggle bookmark status
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Posted by ${blog.user.email}', // Display user email who posted the blog
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(DateTime.parse(blog.createdAt)), // Format the creation date using timeago
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Blog details page that shows full content of a selected blog
class BlogDetailsPage extends StatelessWidget {
  final Blog blog;

  const BlogDetailsPage({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title), // Display the blog title on the AppBar
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.image.isNotEmpty)
              Image.network(
                blog.image, // Display the blog image
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey[300], // Placeholder for image loading error
                  child: const Icon(Icons.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title, // Display the blog title
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 4),
                      Text(blog.user.email), // Display user email
                      const Spacer(),
                      Text(
                        timeago.format(DateTime.parse(blog.createdAt)), // Format and display the creation date
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    blog.story, // Display the full blog content
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
