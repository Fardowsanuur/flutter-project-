import 'package:blog_app/controllers/blogController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/cloudinaryService.dart';

/// Screen for adding a new blog post
class AddBlogPage extends StatefulWidget {
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  File? _selectedImage; // Variable to store the selected image

  bool _isLoading = false; // Loading state
  final blogController = Get.put(BlogController()); // Blog controller instance

  /// Function to pick an image from the camera
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
        preferredCameraDevice:
            CameraDevice.rear, // Use rear camera for better quality
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Function to submit the blog post
  Future<void> _submitBlog() async {
    if (!_formKey.currentState!.validate()) return; // Validate form
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for your blog post'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    blogController.loading.value = true; // Show loading state

    try {
      // Upload image to Cloudinary
      final imageUrl = await CloudinaryService.uploadImage(_selectedImage!);

      if (imageUrl == null) {
        throw 'Failed to upload image';
      }
      
      print('Image uploaded successfully: $imageUrl');
      blogController.imageUrl.value = imageUrl;
      blogController.addBlogPost(); // Add blog post with uploaded image
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      blogController.loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Blog'), // Page title
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Selection Widget
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Cover Image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title Input Field
                        TextFormField(
                          controller: blogController.titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter your blog title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Blog Content Input Field
                        TextFormField(
                          controller: blogController.bodyController,
                          decoration: InputDecoration(
                            labelText: 'Content',
                            hintText: 'Write your blog content here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            alignLabelWithHint: true,
                          ),
                          maxLines: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some content';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: blogController.loading.value
                                ? null
                                : _submitBlog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: blogController.loading.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Publish Blog',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (blogController.loading.value)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ));
  }
}
