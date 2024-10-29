import 'dart:convert';
import 'package:flutter/material.dart';
//import 'services_api.dart';

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
    );
  }

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
                  onTap: statusIndex > currentIndex
                      ? () {
                          setState(() {
                            order.status = status;
                            order.successMessage = 'Order updated successfully: $status';
                          });
                          Navigator.pop(context);
                        }
                      : null,
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

  int daysSinceSubmitted() {
    final date = DateTime.parse(dateSubmitted);
    final now = DateTime.now();
    return now.difference(date).inDays;
  }
}

class OrderContainer extends StatefulWidget {
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
  OrderContainerState createState() => OrderContainerState();
}

class OrderContainerState extends State<OrderContainer> {
  bool isExpanded = false;

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
            widget.order.process,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),

          // Collapsible details
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Number: ${widget.order.orderNumber}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text('Name: ${widget.order.name}'),
                Text('Date Submitted: ${widget.order.dateSubmitted}'),
                Text('Journal Entry Number: ${widget.order.journalTransferNumber}'),
                Text('Department: ${widget.order.department}'),
                Text('Unit: ${widget.order.unit}'),
                Text('Type: ${widget.order.type}'),
                Text('Quantity: ${widget.order.quantity}'),
                Text('Rate: \$${widget.order.rate.toStringAsFixed(2)}'),
                Text('Estimated Price: \$${widget.order.estimatedPrice.toStringAsFixed(2)}'),
                Text('File Path: ${widget.order.filePath}'),
              ],
            ),

          const SizedBox(height: 8.0),

          // Status buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: widget.onUpdateStatus,
                child: const Text('Update Status'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: widget.onDelete,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}