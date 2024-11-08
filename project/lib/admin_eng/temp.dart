import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode
import 'data.dart'; // Ensure you import your data.dart for orderJson and NewOrder
class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();
}

class ProcessImage {
  final String processName;
  final String imagePath;

  ProcessImage({required this.processName, required this.imagePath});
}

class AdminServicesState extends State<AdminServices> {
  String sortBy = 'Date'; // Default sort option
  bool hideCompletedOrders = false; // Toggle switch state
  bool showAllOrders = true; // Toggle for showing all orders
  List<NewOrder> orders = []; // List to hold parsed orders
  List<bool> expandedState = []; // List to keep track of expanded order states
  final DateTime graphStartDate = DateTime.now().subtract(const Duration(days: 180));
  final double dayWidth = 5.0;

  Widget getProcessImage(String process) {
  switch (process) {
    case 'Thermoforming':
      return const Image(image: AssetImage('assets/icons/emb_thermoform_sm.png'));
    case '3D Printing':
      return const Image(image: AssetImage('assets/icons/emb_printer_3d_sm.png'));
    case 'Milling':
      return const Image(image: AssetImage('assets/icons/emb_mill_sm.png'));
    default:
      return const Image(image: AssetImage('assets/icons/default_icon.png')); // Fallback icon
  }
}



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

final int currentWeek = (DateTime.now().day - 1) ~/ 7 + 1; // Calculate current week of the month

// Helper method to build the date header up to the current week
List<Widget> chartHeader(BuildContext context) {
  DateTime now = DateTime.now();
  int currYear = now.year;
  int currMonth = now.month;

  // Start from October
  if (currMonth == 11) {
    currMonth = 10; // Start from October
    currYear = 2024; // Set year to 2024 if we're in November 2024
  }

  List<Widget> headerDates = [];

  // Loop through weeks for October and November
  int weeksInOctober = 4;  // Assuming 4 weeks for October
  int weeksInNovember = 2; // Only show 2 weeks for November

  for (int month = currMonth; month <= 11; month++) {
    int weeksToShow = (month == 10) ? weeksInOctober : weeksInNovember; // Weeks for October and November
    for (int week = 1; week <= weeksToShow; week++) {
      headerDates.add(
        SizedBox(
          width: 250, // Consistent width for each week header to align with columns below
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${_getMonthName(month)} '${currYear.toString().substring(2)} Week $week",
              style: TextStyle(
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        ),
      );
    }
  }

  return headerDates;
}

// Helper function to get month name
String _getMonthName(int month) {
  const List<String> monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return monthNames[month - 1];
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
                Text('Process: ${order.process}'), // Process text
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
          /*Padding(
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
          ),*/
        ],
      ),
      body: Row(
        children: [
          // Vertical container on the left
          Container(
            width: 300, // Width of the container
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).canvasColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
           SizedBox(
              height: 25,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DateTime.now().year.toString(),
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                )
              )
            ),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: 40, // Limit the image size
                                    child: getProcessImage(order.process), // Image widget
                                  ),
                                ),
                                const SizedBox(width: 8.0), // Spacing
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.name,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                      ),
                                      Text(
                                        'Status: ${order.status}',
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                      ),
                                    ],
                                  ),
                                ),
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
          Column(
  children: [
    // Date header with consistent alignment and background color
    Container(
      color: Theme.of(context).cardColor, // Background color for the header
      child: SizedBox(
        // Dynamically adjust width of the SizedBox to match the timeline container
        width: MediaQuery.of(context).size.width - 300, // Full width minus the vertical container width (300px)
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ensures no extra space in header
            children: chartHeader(context), // Generates chart header with dates
          ),
        ),
      ),
    ),

    // Timeline content with evenly spaced vertical dividers
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          // Dynamically calculate width based on screen size and the width of the vertical container
          width: MediaQuery.of(context).size.width - 300, // Full width minus the vertical container width (300px)
          color: Theme.of(context).canvasColor, // Background color for the timeline container
          child: Row(
            children: [
              // Weekly slots with content
              for (int week = 1; week <= currentWeek; week++) ...[
                // Weekly slot container
                Container(
                  width: 250, // Fixed width for each week
                  height: double.infinity,
                  color: Colors.transparent, // Transparent background for each week
                  child: Center(
                    child: Text(
                      'Week $week content', // Placeholder for weekly content
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // Vertical Divider for each week, excluding the last one
                if (week < currentWeek)
                  VerticalDivider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    width: 20, // Consistent width for spacing
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  ],
)






        ],
      ),
    );
  }
}