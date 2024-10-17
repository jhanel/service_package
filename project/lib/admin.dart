import 'package:flutter/material.dart';
import 'main.dart';

class AdminServices extends StatelessWidget {
   AdminServices({Key? key}) : super(key: key);

  // Sample order
  final List<NewOrder> orders = [
    NewOrder(
      process: 'Onboarding',
      unit: 'Unit A',
      type: 'Type 1',
      quantity: 10,
      rate: 15.00,
      estimatedPrice: 150.00,
      filePath: '/path/to/file', //  file path
      dateSubmitted: '2024-10-01', // New field
      journalTransferNumber: 'JEN456', // New field
      department: 'HR', // New field
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            fontSize: 22.0, 
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderContainer(order: order);
          },
        ),
      ),
    );
  }
}

// display individual orders in a container
class OrderContainer extends StatelessWidget {
  final NewOrder order;

  const OrderContainer({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0), // Thick outlined border
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.process, // header
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Order details
          Text('Date Submitted: ${order.dateSubmitted}'),
          Text('Journal Entry Number: ${order.journalTransferNumber}'),
          Text('Department: ${order.department}'),
          Text('Unit: ${order.unit}'),
          Text('Type: ${order.type}'),
          Text('Quantity: ${order.quantity}'),
          Text('Rate: \$${order.rate.toStringAsFixed(2)}'),
          Text('Estimated Price: \$${order.estimatedPrice.toStringAsFixed(2)}'),
          Text('File Path: ${order.filePath}'),
        ],
      ),
    );
  }
}

