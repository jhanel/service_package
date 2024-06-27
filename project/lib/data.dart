import 'dart:convert';

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

List<MaterialRate> parseRates(String jsonString) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<MaterialRate>((json) => MaterialRate.fromJson(json)).toList();
}
