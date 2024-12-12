import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'order_data.dart';

class OrderLogic {
  static const List<List<String>> acceptedExt = [
    ['f3d', 'obj', 'stl', 'stp', 'step'],
    ['f3d', 'stp', 'step']
  ];

  List<dynamic> rates = [];

  OrderLogic() {
    _loadRates();
  }

  void _loadRates() {
    String jsonString = '''
    [
        {"rate": 2.4, "unit": "mm", "mtl": "Aluminum"},
        {"rate": 2.4, "unit": "cm", "mtl": "Aluminum"},
        {"rate": 2.4, "unit": "inches", "mtl": "Aluminum"},
        {"rate": 1.2, "unit": "mm", "mtl": "Steel"},
        {"rate": 1.2, "unit": "cm", "mtl": "Steel"},
        {"rate": 1.2, "unit": "inches", "mtl": "Steel"},
        {"rate": 4.7, "unit": "mm", "mtl": "Brass"},
        {"rate": 4.7, "unit": "cm", "mtl": "Brass"},
        {"rate": 4.7, "unit": "inches", "mtl": "Brass"}
    ]
    ''';

    rates = jsonDecode(jsonString);
  }

  double calculateRate(String selectedUnit, String selectedType) {
    for (var rate in rates) {
      if (rate['unit'] == selectedUnit && rate['mtl'] == selectedType) {
        return rate['rate'];
      }
    }
    return 0.0;
  }

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: acceptedExt.expand((x) => x).toList(),
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.name;
    }
    return null;
  }

    NewOrder createOrder({
    required String process,
    required String unit,
    required String type,
    required int quantity,
    required double rate,
    required double estimatedPrice,
    required String filePath,
    required String dateSubmitted,
    required String name,
    required String orderNumber,
    required String journalTransferNumber,
    required String department,
  }) {
    final newOrder = NewOrder(
      process: process,
      unit: unit,
      type: type,
      quantity: quantity,
      rate: rate,
      estimatedPrice: estimatedPrice,
      filePath: filePath,
      dateSubmitted: dateSubmitted,
      name: name,
      journalTransferNumber: journalTransferNumber,
      department: department,
      orderNumber: orderNumber,
    );

    return newOrder;
  }

}