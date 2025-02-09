// ----- STRINGS ------
import 'package:flutter/material.dart';

/// Base URL for API requests (Replace 'your-Ip' with actual IP address)
const baseURL = 'http://your-Ip:8000/api';

/// API Endpoints
const loginURL = baseURL + '/login'; // Endpoint for user login
const registerURL = baseURL + '/register'; // Endpoint for user registration
const logoutURL = baseURL + '/logout'; // Endpoint for user logout
const userURL = baseURL + '/user'; // Endpoint to fetch user data
const postsURL = baseURL + '/posts'; // Endpoint to fetch posts
const commentsURL = baseURL + '/comments'; // Endpoint to fetch comments

// ----- Errors -----
const serverError = 'Server error'; // General server error message
const unauthorized = 'Unauthorized'; // Unauthorized access message
const somethingWentWrong = 'Something went wrong, try again!'; // Generic error message

// ----- INPUT DECORATION -----

/// Returns a standardized `InputDecoration` for text fields
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label, // Sets the label text
    contentPadding: EdgeInsets.all(10), // Adds padding inside the input field
    border: OutlineInputBorder( // Creates an outlined border for input field
      borderSide: BorderSide(width: 1, color: Colors.black), // Border color and width
    ),
  );
}

// ----- BUTTON -----

/// Creates a standardized `TextButton` with a blue background
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white), // White text color
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue), // Blue background
      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10)), // Vertical padding
    ),
    onPressed: () => onPressed(), // Calls the passed function when tapped
  );
}

// ----- LOGIN/REGISTER HINT -----

/// Creates a row with a text hint and a tappable label (e.g., "Don't have an account? Sign Up")
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // Centers content horizontally
    children: [
      Text(text), // Hint text
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue)), // Blue tappable label
        onTap: () => onTap(), // Calls the passed function when tapped
      ),
    ],
  );
}

// ----- LIKES AND COMMENT BUTTON -----

/// Creates an expandable `like` or `comment` button with an icon and counter
Expanded kLikeAndComment(int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(), // Calls the passed function when tapped
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10), // Adds vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers content horizontally
            children: [
              Icon(icon, size: 16, color: color), // Like or comment icon
              SizedBox(width: 4), // Adds spacing between icon and text
              Text('$value'), // Displays the number of likes/comments
            ],
          ),
        ),
      ),
    ),
  );
}
