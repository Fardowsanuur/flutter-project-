import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

//
////////
class CloudinaryService {
    // Cloudinary credentials
  static const String _cloudName = 'dvgapjlqg';
  static const String _uploadPreset =
      'crowdfunding'; // Make sure this is unsigned in Cloudinary
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      // Create the multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
          ),
        );

      // Send the request
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(result);
        return jsonResponse['secure_url'];
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print('Response body: $result');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}//////