import 'dart:convert';
import 'package:blogapp/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:blogapp/models/api_response.dart';

import '../constant.dart';
import 'user_service.dart';

// Fetch comments for a specific post
Future<ApiResponse> getComments(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send GET request to fetch comments for the post
    final response = await http.get(Uri.parse('$postsURL/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        // Map response data to Comment model
        apiResponse.data = jsonDecode(response.body)['comments']
            .map((p) => Comment.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
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

// Create a new comment on a post
Future<ApiResponse> createComment(int postId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send POST request to create a new comment
    final response = await http.post(Uri.parse('$postsURL/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'comment': comment // Pass the comment text as the request body
        });

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body); // Comment created successfully
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

// Delete a comment by its ID
Future<ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send DELETE request to remove the comment
    final response = await http.delete(Uri.parse('$commentsURL/$commentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    // Handle response based on status code
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

// Edit an existing comment by its ID
Future<ApiResponse> editComment(int commentId, String comment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Retrieve authentication token
    String token = await getToken();

    // Send PUT request to update the comment
    final response = await http.put(Uri.parse('$commentsURL/$commentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'comment': comment // Pass the updated comment text
        });

    // Handle response based on status code
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
