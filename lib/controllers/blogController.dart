import 'dart:convert';
import 'package:blog_app/models/blog.dart';
import 'package:blog_app/token/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
///.....//
class BlogController extends GetxController {
  final loading = false.obs;
  // final String baseUrl = 'http://localhost:5000';
  // final String baseUrl = 'https://blog-api-8kzp.vercel.app';
  final String baseUrl = 'http://10.0.2.2:5000';
    final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final imageUrl = "".obs;
  var Token = ''.obs;
  final tokenService = TokenService();
  final data = <Blog>[].obs;
  final bookmarkedPosts = <Blog>[].obs;

  void toggleBookmark(Blog blog) {
    if (isBookmarked(blog)) {
      bookmarkedPosts.removeWhere((post) => post.id == blog.id);
    } else {
      bookmarkedPosts.add(blog);
    }
  }

  bool isBookmarked(Blog blog) {
    return bookmarkedPosts.any((post) => post.id == blog.id);
  }

  @override
  void onInit() {
    super.onInit();
    initializeToken();
  }

  Future<void> initializeToken() async {
    String? storedToken = await tokenService.getToken();
    if (storedToken != null) {
      Token.value = storedToken;
    }
  }

  Future<void> addBlogPost() async {
    loading.value = true;

    final body = {
      "title": titleController.text,
      "story": bodyController.text,
      "image": imageUrl.value
    };
    print(body);

    if (titleController.text == "" ||
        bodyController.text == "" ||
        imageUrl.value == "") {
      Get.snackbar("missing", "one of the data is missing");
      return;
    }
    try {
      // loading.value = true;
      loading.value = false;
      print(Token.value);
      final response = await http.post(Uri.parse(baseUrl + '/api/posts'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Token.value}'
          });
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        loading.value = false;
        Get.snackbar(
          "success",
          'Registration failed: ${data["success"]}',
          backgroundColor: Colors.green.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed('/');
      } else {
        loading.value = false;
        Get.snackbar(
          "Error",
          'Registration failed: ${data["message"]}',
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar("error", "error during post${e}");
    }
  }

  Future<void> getBlogPost() async {
    try {
      loading.value = true;
      final response = await http.get(
        Uri.parse('$baseUrl/api/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Token.value}'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['posts'] != null) {
          final List<dynamic> postsData = responseData['posts'];
          data.value = postsData.map((item) => Blog.fromJson(item)).toList();
        } else {
          Get.snackbar('Error', 'Invalid response format');
        }
      } else {
        print(response.body);
        Get.snackbar('Error', 'Failed to load blogs');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
  Future<void> deletePost(String postId) async {
  try {
    loading.value = true;
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Token.value}',
      },
    );

    if (response.statusCode == 204) {
      // Remove the deleted post from the list
      data.removeWhere((post) => post.id == postId);
      Get.snackbar(
        "Success",
        "Post deleted successfully",
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to delete post: ${response.body}",
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Network error: $e",
      backgroundColor: Colors.red.withOpacity(0.1),
      duration: const Duration(seconds: 3),
    );
  } finally {
    loading.value = false;
  }
}
}
