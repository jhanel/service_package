class NewOrder {
  final String process;
  final String unit;
  final String type;
  final int quantity;
  final double rate;
  final double estimatedPrice;
  String filePath;
  final String dateSubmitted;
  final String journalTransferNumber;
  final String department;

  NewOrder({
    required this.process,
    required this.unit,
    required this.type,
    required this.quantity,
    required this.rate,
    required this.estimatedPrice,
    required this.filePath,
    required this.dateSubmitted,
    required this.journalTransferNumber,
    required this.department,
  });
}

class OrderDetails {
  String orderNumber = '';
  String userName = '';
  double rate = 0.0;
  String type = '';
  int quantity = 0;
  String process = '';
  String unit = '';
}

OrderDetails globalOrderDetails = OrderDetails();