class NewOrder {
  String orderNumber;
  String name;
  String process;
  String unit;
  String type;
  int quantity;
  double rate;
  double estimatedPrice;
  String filePath;
  String dateSubmitted;
  String journalTransferNumber;
  String department;
  bool isCancelled;

  NewOrder({
    required this.orderNumber,
    required this.name,
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
    this.isCancelled = false,
  });

  double calculateEstimatedPrice(double volume) {
    return volume * rate * quantity;
  }

  int daysSinceSubmitted() {
    final date = DateTime.parse(dateSubmitted);
    final now = DateTime.now();
    return now.difference(date).inDays;
  }
  
}

NewOrder globalOrder = NewOrder(
  orderNumber: '',
  name: '',
  process: '',
  unit: '',
  type: '',
  quantity: 0,
  rate: 0.0,
  estimatedPrice: 0.0,
  filePath: '',
  dateSubmitted: '',
  journalTransferNumber: '',
  department: '',
);

