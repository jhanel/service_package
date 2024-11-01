import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode
import 'data.dart'; // Ensure you import your data.dart for orderJson and NewOrder
import 'widget.dart'; // Import the widget containing your Services management

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();
}

class AdminServicesState extends State<AdminServices> {
  String sortBy = 'Date'; // Default sort option
  bool hideCompletedOrders = false; // Toggle switch state
  bool showAllOrders = true; // Toggle for showing all orders
  List<NewOrder> orders = []; // List to hold parsed orders
  List<bool> expandedState = []; // List to keep track of expanded order states

  @override
  void initState() {
    super.initState();
    loadOrders(); // Load orders when the state initializes
  }

  void loadOrders() {
    // Parse the JSON string and create a list of NewOrder objects
    List<dynamic> jsonList = json.decode(orderJson);
    orders = jsonList.map((json) => NewOrder.fromJson(json)).toList();
    expandedState = List<bool>.filled(orders.length, false); // Initialize expanded state
    setState(() {}); // Trigger a rebuild to display orders
  }

  void deleteOrder(int index) {
    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  orders.removeAt(index); // Remove order from the list
                  expandedState.removeAt(index); // Remove the expanded state
                });
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void updateOrderStatus(int index) {
    // Update order status logic
    List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed', 'Canceled'];
    String currentStatus = orders[index].status; // Get the current status

    // Show a dialog with the status options
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: statuses.map((status) {
                return RadioListTile<String>(
                  title: Text(status),
                  value: status,
                  groupValue: currentStatus,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        orders[index].status = value; // Update the order status
                        orders[index].successMessage = 'Order updated successfully to $value'; // Success message
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without updating
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showOrderDetails(NewOrder order) {
    // Display order details in a dialog or full-screen view
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(order.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Order Number: ${order.orderNumber}'),
                Text('Process: ${order.process}'),
                Text('Unit: ${order.unit}'),
                Text('Type: ${order.type}'),
                Text('Quantity: ${order.quantity}'),
                Text('Rate: \$${order.rate.toStringAsFixed(2)}'),
                Text('Date Submitted: ${order.dateSubmitted}'),
                Text('Department: ${order.department}'),
                Text('Status: ${order.status}'),
                if (order.successMessage != null) ...[
                  const SizedBox(height: 8.0),
                  Text(order.successMessage!, style: const TextStyle(color: Colors.green)),
                ],
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => updateOrderStatus(orders.indexOf(order)), // Update order status
              child: const Text('Update Status'),
            ),
            TextButton(
              onPressed: () {
                deleteOrder(orders.indexOf(order)); // Delete order
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete Order'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter orders based on toggles
    List<NewOrder> filteredOrders = orders.where((order) {
      if (hideCompletedOrders && order.status == "Completed") {
        return false;
      }
      return true;
    }).toList();

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
        actions: [
          // Sort By Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  'Sort By:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                const SizedBox(width: 4.0),
                DropdownButton<String>(
                  value: sortBy,
                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).secondaryHeaderColor),
                  dropdownColor: Theme.of(context).cardColor,
                  underline: Container(),
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  items: <String>['Date', 'Status'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      sortBy = newValue!;
                      // Here you can add sorting logic based on sortBy value
                      // E.g. sort the filteredOrders list
                    });
                  },
                ),
              ],
            ),
          ),

          // Toggle Hide Completed Orders
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'Hide Completed Orders:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Switch(
                  value: hideCompletedOrders,
                  onChanged: (bool value) {
                    setState(() {
                      hideCompletedOrders = value;
                    });
                  },
                  activeColor: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            ),
          ),

          // Toggle Show All Orders
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'Show All Orders:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Switch(
                  value: showAllOrders,
                  onChanged: (bool value) {
                    setState(() {
                      showAllOrders = value;
                    });
                  },
                  activeColor: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            ),
          ),

          // Button to Manage Services
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Manage Services',
              color: Theme.of(context).secondaryHeaderColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicesWidget(), // Navigate to ServicesWidget
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Vertical container on the left
          Container(
            width: 300, // Width of the container
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            _formatCurrentMonth(), // Assume this function returns "Nov '24"
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      NewOrder order = filteredOrders[index];
                      return GestureDetector(
                        onTap: () {
                          showOrderDetails(order); // Show order details in a dialog
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('Status: ${order.status}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right side for any other content or widgets
          Expanded(
            child: Container(
              color: Theme.of(context).canvasColor,
              child: const Center(child: Text('Timeline of Orders')),
            ),
          ),
        ],
      ),

    );
  }

  // Helper method to format the current month
  String _formatCurrentMonth() {
    final now = DateTime.now();
    final month = now.month;
    final year = now.year.toString().substring(2); // Get last two digits of the year
    return '${_getMonthName(month)} \'$year';
  }

  // Helper method to get month name from month number
  String _getMonthName(int month) {
    const monthNames = [
      '', // Placeholder for index 0
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month];
  }
}