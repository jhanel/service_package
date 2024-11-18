import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode
import 'data.dart'; // Ensure you import your data.dart for orderJson and NewOrder
import '../css/css.dart';

ThemeData currentTheme = CSS.lightTheme;

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();

  void switchTheme(LsiThemes theme) {
    
      currentTheme = CSS.changeTheme(theme);  
    
  }
 
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

List<Widget> chartHeader(BuildContext context) {
  // Get current date
  DateTime now = DateTime.now();

  // Find the earliest submission date in orders
  DateTime? earliestDate;
  if (orders.isNotEmpty) {
    earliestDate = orders
        .map((order) => DateTime.parse(order.dateSubmitted))
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }

  // Fallback to today's date if no orders exist
  earliestDate ??= now;

  // Calculate the number of weeks between earliest date and today
  int daysDifference = now.difference(earliestDate).inDays;
  int totalWeeks = (daysDifference / 7).ceil(); // Total weeks from earliest date to now

  // Generate week headers
  List<Widget> headerDates = [];
  for (int week = 0; week < totalWeeks; week++) {
    DateTime weekStart = earliestDate.add(Duration(days: week * 7));
    int weekOfMonth = ((weekStart.day - 1) ~/ 7) + 1;

    headerDates.add(
      SizedBox(
        width: 250, // Consistent width for each week header
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "${_getMonthName(weekStart.month)} '${weekStart.year.toString().substring(2)} Week $weekOfMonth",
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

  return headerDates;
}

// Helper function to get month name
String _getMonthName(int month) {
  const List<String> monthNames = [
    "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.",
    "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(order: order), // Navigate to the new page
                            ),
                          );
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
                                        style: const TextStyle(fontFamily: 'Klavika', fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                      ),
                                      Text(
                                        'Status: ${order.status}',
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                        style: const TextStyle(fontFamily: 'Klavika', fontWeight: FontWeight.normal),
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
        ],
      ),
    );
  }
}

class OrderDetailsPage extends StatefulWidget {
final NewOrder order;

const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

@override
OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
String? updatedStatusMessage; // To display the status update success message
String selectedStatus = ''; // Current selected status
String comments = ''; // Stores user comments
final List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed']; // Status options

@override
void initState() {
super.initState();
selectedStatus = widget.order.status; // Initialize with the current status from data
}

void deleteOrder(BuildContext context) {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: const Text('Confirm Delete'),
content: const Text('Are you sure you want to delete this order?'),
actions: [
  TextButton(
    onPressed: () => Navigator.pop(context), // Cancel deletion
    child: const Text('Cancel'),
  ),
  TextButton(
    onPressed: () {
      // Handle deletion logic here (for now, just pop back)
      Navigator.pop(context); // Close the alert
      Navigator.pop(context); // Return to previous screen
    },
    child: const Text('Delete'),
  ),
],
);
},
);
}

void updateStatus(BuildContext context, String newStatus) {
setState(() {
updatedStatusMessage = "Status updated successfully: $newStatus"; // Show success message
selectedStatus = newStatus; // Update status
});
}

void saveComment(BuildContext context) {
setState(() {
// Logic for saving comments, if necessary, can be added here
});
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Comment saved successfully!')),
);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    leading: IconButton(
    icon: const Icon(Icons.close), // X button
    onPressed: () => Navigator.pop(context), // Close the page
    ),
    backgroundColor: Theme.of(context).cardColor,
    ),
    body: Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details Container
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColorLight),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style:  
                      TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                        ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Name: ${widget.order.name}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                    ),
                    Text(
                      'Process: ${widget.order.process}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Order Number: ${widget.order.orderNumber}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                    ),
                    Text(
                      'Unit: ${widget.order.unit}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Type: ${widget.order.type}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Quantity: ${widget.order.quantity}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Rate: \$${widget.order.rate.toStringAsFixed(2)}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Date Submitted: ${widget.order.dateSubmitted}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Department: ${widget.order.department}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      'Status: ${widget.order.status}',
                      style:  
                      const TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.normal,
                        ),
                      ),
                    if (updatedStatusMessage != null) ...[
                      const SizedBox(height: 8.0),
                      Text(
                        updatedStatusMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                    const Spacer(), // Push buttons to the bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         // Dropdown for Status Updates
                          DropdownButton<String>(
                            value: selectedStatus, // Current selected status
                            items: statuses.map((status) {
                              // Disable current and previous statuses
                              final isDisabled = statuses.indexOf(status) <= statuses.indexOf(selectedStatus);
                              return DropdownMenuItem<String>(
                                value: status,
                                enabled: !isDisabled,
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: isDisabled ? Colors.grey : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedStatus = value; // Update the status
                                  updatedStatusMessage = "Status updated successfully: $value";
                                });
                              }
                            },
                            dropdownColor: Theme.of(context).cardColor,
                            style: const TextStyle(fontFamily: 'Klavika', fontWeight: FontWeight.normal),
                          ),


                        const SizedBox(width: 20.0),

                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.red),
                            side: WidgetStateProperty.all( const BorderSide(width: 2.0, color: Colors.red)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                          ),
                          onPressed: () => deleteOrder(context),
                          child: const Text(
                            'DELETE ORDER',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16.0), // Spacing between containers
            // Comments Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColorLight),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comments',
                      style:  
                      TextStyle(
                        fontFamily: 'Klavika', 
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                        ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => comments = value, // Capture comments
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          //border: OutlineInputBorder(),
                          hintText: 'Enter your comments here...',
                        ),
                      ),
                    ),
                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                            side: WidgetStateProperty.all( BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                          ),
                          onPressed: () => saveComment(context),
                          child: Text(
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold
                            ),
                            'SAVE'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
