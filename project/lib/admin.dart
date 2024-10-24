import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';
import 'css.dart';

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
  _AdminServicesState createState() => _AdminServicesState();
}

class _AdminServicesState extends State<AdminServices> {
  List<NewOrder> orders = [];
  String? successMessage;

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
                      successMessage: successMessage, // Pass success message
                    );
                  },
                ),
        ),
      ),
    );
  }

  // Function to update the order status
  void _updateOrderStatus(NewOrder order) {
    // List of statuses in the correct order
    List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed'];

    // Find the current status index
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
                      color: statusIndex <= currentIndex
                          ? Colors.grey  // Grey out previous statuses
                          : Colors.black,  // Regular color for selectable statuses
                    ),
                  ),
                  enabled: statusIndex > currentIndex, // Disable previous statuses
                  onTap: statusIndex > currentIndex ? () {
                    setState(() {
                      order.status = status; // Update the order's status to the new one
                      successMessage = 'Order updated successfully: $status'; // Set success message
                    });
                    Navigator.pop(context); // Close the dialog
                  } : null, // Disable the onTap action for greyed out statuses
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without making changes
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
}

class OrderContainer extends StatelessWidget {
  final NewOrder order;
  final VoidCallback onUpdateStatus;
  final VoidCallback onDelete;
  final String? successMessage; // Message to show after status update

  const OrderContainer({
    Key? key,
    required this.order,
    required this.onUpdateStatus,
    required this.onDelete,
    this.successMessage,
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

          // Display success message if available
          if (successMessage != null)
            Text(
              successMessage!,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),

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
              color:
                  currentTheme == CSS.hallowTheme
                  ? Theme.of(context).primaryColorLight
                  : currentTheme == CSS.darkTheme
                  ? Theme.of(context).primaryColorLight
                  : currentTheme == CSS.mintTheme
                  ? Theme.of(context).primaryColorLight
                  : currentTheme == CSS.lsiTheme
                  ? Theme.of(context).primaryColorLight // MAKE WHITE
                  : currentTheme == CSS.pinkTheme
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).primaryColorLight,
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

  