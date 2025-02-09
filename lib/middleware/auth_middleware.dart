import 'package:blog_app/token/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final tokenService = TokenService();

  @override
  RouteSettings? redirect(String? route) {
    bool hasToken = tokenService.hasToken();

    if (!hasToken) {
      // If no token, redirect to login except for auth-related routes
      if (route != '/signin' && route != '/signup') {
        return const RouteSettings(name: '/signin');
      }
    } else {
      // If has token and trying to access auth routes, redirect to home
      if (route == '/signin' || route == '/signup') {
        return const RouteSettings(name: '/');
      }
    }
    return null;
  }
}
