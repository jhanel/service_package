import 'dart:convert'; // Import the Dart convert library for JSON handling

class MaterialRate { // Define a class to represent the material rate
  final double rate; // Rate of the material
  final String unit; // Unit of the material ( mm, cm, inches)
  final String material; // Type of material (Aluminum, Steel, Brass)

  MaterialRate({ // Constructor to initialize the fields of MaterialRate
    required this.rate, 
    required this.unit, 
    required this.material, 
  });

  factory MaterialRate.fromJson(Map<String, dynamic> json) { // Factory constructor to create a MaterialRate object from a JSON map
    return MaterialRate(
      rate: json['rate'], // Assign the 'rate' field from the JSON map
      unit: json['unit'], // Assign the 'unit' field from the JSON map
      material: json['mtl'], // Assign the 'material' (mtl) field from the JSON map
    );
  }
}

List<MaterialRate> parseRates(String jsonString) { // Function to parse a JSON string and return a list of MaterialRate objects
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>(); // Decode the JSON string and cast it to a list of maps

  return parsed.map<MaterialRate>((json) => MaterialRate.fromJson(json)).toList(); // Map each JSON map to a MaterialRate object using the fromJson factory constructor
                                                                                   // Convert the Iterable to a List and return it
}