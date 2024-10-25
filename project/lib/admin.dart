import 'dart:convert';
import 'package:flutter/material.dart';

const String orderJson = '''
[
  {
    "orderNumber": "001",
    "name": "John Doe",
    "process": "Thermoforming",
    "unit": "mm",
    "type": "Aluminum",
    "quantity": 10,
    "rate": 2.5,
    "estimatedPrice": 25.0,
    "filePath": "path/to/file1.stl",
    "dateSubmitted": "2024-10-20",
    "journalTransferNumber": "JT001",
    "department": "Manufacturing",
    "status": "Received"
  },
  {
    "orderNumber": "002",
    "name": "Jane Smith",
    "process": "3D Printing",
    "unit": "cm",
    "type": "Steel",
    "quantity": 5,
    "rate": 4.7,
    "estimatedPrice": 23.5,
    "filePath": "path/to/file2.obj",
    "dateSubmitted": "2024-10-21",
    "journalTransferNumber": "JT002",
    "department": "Prototyping",
    "status": "In Progress"
  }
]
''';

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();
}

class AdminServicesState extends State<AdminServices> {
  List<NewOrder> orders = [];

  @override
  void initState() {
    super.initState();
    // Parse JSON and initialize the orders list
    final List<dynamic> jsonOrders = jsonDecode(orderJson);
    orders = jsonOrders.map((order) => NewOrder.fromJson(order)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: orders.isEmpty
              ? const Center(
                  child: Text(
                    'No orders at this time',
                    style: TextStyle(
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderContainer(
                      order: order,
                      onUpdateStatus: () => _updateOrderStatus(order),
                      onDelete: () => _deleteOrder(order),
                    );
                  },
                ),
        ),
      ),
    );
  }

  // Function to update the order status
    void _updateOrderStatus(NewOrder order) {
    List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed'];
    int currentIndex = statuses.indexOf(order.status);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Order Status'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: statuses.map((status) {
                int statusIndex = statuses.indexOf(status);

                return ListTile(
                  title: Text(
                    status,
                    style: TextStyle(
                      color: statusIndex <= currentIndex ? Colors.grey : Colors.black,
                    ),
                  ),
                  enabled: statusIndex > currentIndex,
                  onTap: statusIndex > currentIndex ? () {
                    setState(() {
                      order.status = status;
                      order.successMessage = 'Order updated successfully: $status';
                    });
                    Navigator.pop(context);
                  } : null,
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _deleteOrder(NewOrder order) {
    setState(() {
      orders.remove(order);
    });
  }
}

class NewOrder {
  final String orderNumber;
  final String name;
  final String process;
  final String unit;
  final String type;
  final int quantity;
  final double rate;
  final double estimatedPrice;
  final String filePath;
  final String dateSubmitted;
  final String journalTransferNumber;
  final String department;
  String status;
  String? successMessage;

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
    required this.status,
    this.successMessage,
  });

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      orderNumber: json['orderNumber'],
      name: json['name'],
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
      status: json['status'],
    );
  }

  // Add this function to calculate the order's duration in days
  int daysSinceSubmitted() {
    final date = DateTime.parse(dateSubmitted);
    final now = DateTime.now();
    return now.difference(date).inDays;
  }

}

class OrderContainer extends StatelessWidget {
  final NewOrder order;
  final VoidCallback onUpdateStatus;
  final VoidCallback onDelete;

  const OrderContainer({
    Key? key,
    required this.order,
    required this.onUpdateStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.process,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),

          Text('Order Number: ${order.orderNumber}'),
          Text('Name: ${order.name}'),
          Text('Date Submitted: ${order.dateSubmitted}'),
          Text('Journal Entry Number: ${order.journalTransferNumber}'),
          Text('Department: ${order.department}'),
          Text('Unit: ${order.unit}'),
          Text('Type: ${order.type}'),
          Text('Quantity: ${order.quantity}'),
          Text('Rate: \$${order.rate.toStringAsFixed(2)}'),
          Text('Estimated Price: \$${order.estimatedPrice.toStringAsFixed(2)}'),
          Text('File Path: ${order.filePath}'),

          const SizedBox(height: 8.0),

          // Timeline: Show days since submitted
          Text(
            'Days in Queue: ${order.daysSinceSubmitted()} days',
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Optional progress bar showing up to a max (e.g., 30 days)
          LinearProgressIndicator(
            value: order.daysSinceSubmitted() / 30,
            backgroundColor: Colors.grey.shade400,
            color: Colors.redAccent,
          ),

          // Display success message if available
          if (order.successMessage != null)
            Text(
              order.successMessage!,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),

            const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onUpdateStatus,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                  side: WidgetStateProperty.all(BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
                  minimumSize: WidgetStateProperty.all(const Size(100, 36)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: onDelete,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xffe64e46)),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
                  minimumSize: WidgetStateProperty.all(const Size(100, 36)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Color(0xfefefefe),
                    fontSize: 14.0,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

  