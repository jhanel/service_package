/*import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart'; // Import the logger package

class Database {
  static final Logger _logger = Logger(); // Create a logger instance

  static Future<dynamic> once(String filePath) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String fullPath = '${appDocDir.path}/$filePath';

      // Read the JSON file from the full path
      String jsonData = await File(fullPath).readAsString();

      // Decode the JSON data into a dynamic object
      dynamic data = jsonDecode(jsonData);

      return data; // Return the decoded data
    } catch (e, stackTrace) {
      _logger.e('Error reading JSON file', stackTrace: stackTrace); // Log an error message with error and stack trace
      return null; // Return null in case of an error
    }
  }
}*/
