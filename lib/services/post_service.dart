import 'dart:convert';

import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/post.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// Fetch all posts
Future<ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send GET request to fetch all posts
    final response = await http.get(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        // Map response data to Post model
        apiResponse.data = jsonDecode(response.body)['posts']
            .map((p) => Post.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized; // Unauthorized access
        break;
      default:
        apiResponse.error = somethingWentWrong; // General error message
        break;
    }
  } catch (e) {
    apiResponse.error = serverError; // Handle server-related errors
  }
  return apiResponse;
}

// Create a new post with optional image
Future<ApiResponse> createPost(String body, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send POST request to create a new post
    final response = await http.post(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null
            ? {
                'body': body,
                'image': image // Include image if provided
              }
            : {
                'body': body // Only send body if image is null
              });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body); // Post created successfully
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error =
            errors[errors.keys.elementAt(0)][0]; // Validation error message
        break;
      case 401:
        apiResponse.error = unauthorized; // Unauthorized access
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong; // General error message
        break;
    }
  } catch (e) {
    apiResponse.error = serverError; // Handle server-related errors
  }
  return apiResponse;
}

// Edit an existing post
Future<ApiResponse> editPost(int postId, String body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send PUT request to update the post
    final response = await http.put(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'body': body // Update the post content
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message']; // Successfully updated
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message']; // Forbidden
        break;
      case 401:
        apiResponse.error = unauthorized; // Unauthorized access
        break;
      default:
        apiResponse.error = somethingWentWrong; // General error message
        break;
    }
  } catch (e) {
    apiResponse.error = serverError; // Handle server-related errors
  }
  return apiResponse;
}

// Delete a post by its ID
Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send DELETE request to remove the post
    final response = await http.delete(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message']; // Successfully deleted
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message']; // Forbidden
        break;
      case 401:
        apiResponse.error = unauthorized; // Unauthorized access
        break;
      default:
        apiResponse.error = somethingWentWrong; // General error message
        break;
    }
  } catch (e) {
    apiResponse.error = serverError; // Handle server-related errors
  }
  return apiResponse;
}

// Like or unlike a post
Future<ApiResponse> likeUnlikePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send POST request to like/unlike the post
    final response = await http.post(Uri.parse('$postsURL/$postId/likes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body)['message']; // Successfully liked/unliked
        break;
      case 401:
        apiResponse.error = unauthorized; // Unauthorized access
        break;
      default:
        apiResponse.error = somethingWentWrong; // General error message
        break;
    }
  } catch (e) {
    apiResponse.error = serverError; // Handle server-related errors
  }
  return apiResponse;
}
