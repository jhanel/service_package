// Notes from 6/28 meeting
// convert new class to json and send it to json
// create new order data . dart
// make a new order object that will be sent to json

import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer; // Import Dart's built-in logging library

class NewOrder {
  final String process;
  final String unit;
  final String type;
  final int quantity;
  final double rate;
  final double estimatedPrice;

  NewOrder({
    required this.process,
    required this.unit,
    required this.type,
    required this.quantity,
    required this.rate,
    required this.estimatedPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'process': process,
      'unit': unit,
      'type': type,
      'quantity': quantity,
      'rate': rate,
      'estimatedPrice': estimatedPrice,
    };
  }
}

Future<void> submitNewOrder(NewOrder order) async {
  const String filePath = 'data.json'; // Path to your JSON file

  // File instance to interact with the JSON file
  File file = File(filePath);
  List<dynamic> orders = [];

  // Check if the file exists and read its contents
  if (await file.exists()) {
    String contents = await file.readAsString();
    orders = jsonDecode(contents);
  }

  // Append the new order to the list of orders
  orders.add(order.toJson());

  // Write the updated list of orders back to the JSON file
  await file.writeAsString(jsonEncode(orders));

  // Log the order submission
  developer.log('Order submitted!');
}