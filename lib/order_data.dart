List<NewOrder> orders = [];

const double volume = 100.0;
const List<String> statusHierarchy = ['Received', 'In Progress', 'Delivered', 'Completed'];

class NewOrder {
  String orderNumber;
  String name;
  String contact;
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
  String? imagePath;
  String status;
  String comment;
  String? successMessage;

  NewOrder({
    required this.orderNumber,
    required this.name,
    required this.contact,
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
    this.imagePath,
    this.status = "Received",
    this.comment = "",
    this.successMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'name': name,
      'contact': contact,
      'process': process,
      'unit': unit,
      'type': type,
      'quantity': quantity,
      'rate': rate,
      'estimatedPrice': estimatedPrice,
      'filePath': filePath,
      'dateSubmitted': dateSubmitted,
      'journalTransferNumber': journalTransferNumber,
      'department': department,
      'isCancelled': isCancelled,
      'imagePath': imagePath,
      'status': status,
      'comment': comment,
      'successMessage': successMessage,
    };
  }

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      orderNumber: json['orderNumber'],
      name: json['name'],
      contact: json['contact'],
      process: json['process'],
      unit: json['unit'],
      type: json['type'],
      quantity: json['quantity'],
      rate: (json['rate'] as num).toDouble(),
      estimatedPrice: (json['estimatedPrice'] as num).toDouble(),
      filePath: json['filePath'],
      dateSubmitted: json['dateSubmitted'],
      journalTransferNumber: json['journalTransferNumber'],
      department: json['department'],
      isCancelled: json['isCancelled'] ?? false,
      imagePath: json['imagePath'],
      status: json['status'] ?? "",
      comment: json['comment'] ?? "",
      successMessage: json['successMessage'],
    );
  }

  void markAsCancelled() {
    isCancelled = true;
  }

  double calculateEstimatedPrice(double volume) {
    return volume * rate * quantity;
  }

  int daysSinceSubmitted() {
    final date = DateTime.parse(dateSubmitted);
    final now = DateTime.now();
    return now.difference(date).inDays;
  }

  String formatDateSubmitted() {
    final DateTime parsedDate = DateTime.parse(dateSubmitted);
    return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} "
           "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";
  }

}

class Month {
  Month({
    required this.name,
    required this.days,
  });

  String name;
  int days;

  static Month getMonth(int monthNum, int year) {
    Month thisMonth;
    if (monthNum == 0) {
      monthNum = 12;
    }

    switch (monthNum) {
      case 1:
        thisMonth = Month(name: "Jan", days: 31);
        break;
      case 2:
        thisMonth = Month(name: "Feb", days: (year % 4 == 0) ? 29 : 28);
        break;
      case 3:
        thisMonth = Month(name: "Mar", days: 31);
        break;
      case 4:
        thisMonth = Month(name: "Apr", days: 30);
        break;
      case 5:
        thisMonth = Month(name: "May", days: 31);
        break;
      case 6:
        thisMonth = Month(name: "Jun", days: 30);
        break;
      case 7:
        thisMonth = Month(name: "Jul", days: 31);
        break;
      case 8:
        thisMonth = Month(name: "Aug", days: 31);
        break;
      case 9:
        thisMonth = Month(name: "Sep", days: 30);
        break;
      case 10:
        thisMonth = Month(name: "Oct", days: 31);
        break;
      case 11:
        thisMonth = Month(name: "Nov", days: 30);
        break;
      case 12:
        thisMonth = Month(name: "Dec", days: 31);
        break;
      default:
        thisMonth = Month(name: "", days: 0);
    }

    return thisMonth;
  }
}