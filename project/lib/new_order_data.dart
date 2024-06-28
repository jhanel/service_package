// Notes from 6/28 meeting
// convert new class to json and send it to json
// create new order data . dart
// make a new order object that will be sent to json

import 'dart:convert';
import 'dart:developer' as developer; // Import Dart's built-in logging library

// Define MaterialRate class
class MaterialRate {
  final double rate;
  final String unit;
  final String material;

  MaterialRate({
    required this.rate,
    required this.unit,
    required this.material,
  });

  factory MaterialRate.fromJson(Map<String, dynamic> json) {
    return MaterialRate(
      rate: json['rate'],
      unit: json['unit'],
      material: json['mtl'],
    );
  }
}

// Function to parse rates from JSON string
List<MaterialRate> getRates(String jsonString) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<MaterialRate>((json) => MaterialRate.fromJson(json)).toList();
}

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

void submitNewOrder(NewOrder order) {
  String jsonOrder = json.encode(order.toJson()); // Convert the order to a JSON string
  developer.log('Submitting order: $jsonOrder'); // Log the order submission
}
