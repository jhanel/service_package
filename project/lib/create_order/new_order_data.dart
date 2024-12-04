import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

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
  const String filePath = 'data.json'; 

  File file = File(filePath); 
  List<dynamic> orders = [];
  
  if (await file.exists()) {
    String contents = await file.readAsString();
    orders = jsonDecode(contents);
  }

  orders.add(order.toJson()); 

  await file.writeAsString(jsonEncode(orders)); 

  developer.log('Order submitted!');
}