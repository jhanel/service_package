import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'data.dart'; 
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
  bool hideCompletedOrders = false; 
  bool showAllOrders = true; 
  List<NewOrder> orders = []; 
  List<bool> expandedState = []; 
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
      return const Image(image: AssetImage('assets/icons/default_icon.png')); 
  }
}



  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    List<dynamic> jsonList = json.decode(orderJson);
    orders = jsonList.map((json) => NewOrder.fromJson(json)).toList();
    expandedState = List<bool>.filled(orders.length, false);
    setState(() {});
  }

final int currentWeek = (DateTime.now().day - 1) ~/ 7 + 1; 

List<Widget> chartHeader(BuildContext context) {
  
  DateTime now = DateTime.now();

  DateTime? earliestDate;
  if (orders.isNotEmpty) {
    earliestDate = orders
        .map((order) => DateTime.parse(order.dateSubmitted))
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }

  // Fallback to today's date if no orders exist
  earliestDate ??= now;

  int daysDifference = now.difference(earliestDate).inDays;
  int totalWeeks = (daysDifference / 7).ceil(); // Total weeks from earliest date to now

  List<Widget> headerDates = [];
  for (int week = 0; week < totalWeeks; week++) {
    DateTime weekStart = earliestDate.add(Duration(days: week * 7));
    int weekOfMonth = ((weekStart.day - 1) ~/ 7) + 1;

    headerDates.add(
      SizedBox(
        width: 250, 
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

String _getMonthName(int month) {
  const List<String> monthNames = [
    "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.",
    "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."
  ];
  return monthNames[month - 1];
}









  void deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  orders.removeAt(index); 
                  expandedState.removeAt(index);
                });
                Navigator.of(context).pop(); 
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
                    });
                  },
                ),
              ],
            ),
          ),
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
          Container(
            width: 300, 
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
                              builder: (context) => OrderDetailsPage(order: order),
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
                                    width: 40, 
                                    child: getProcessImage(order.process), 
                                  ),
                                ),
                                const SizedBox(width: 8.0), 
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.name,
                                        style: const TextStyle(fontFamily: 'Klavika', fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, 
                                      ),
                                      Text(
                                        'Status: ${order.status}',
                                        overflow: TextOverflow.ellipsis,
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
String? updatedStatusMessage; 
String selectedStatus = ''; 
String comments = ''; 
final List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed']; 

@override
void initState() {
super.initState();
selectedStatus = widget.order.status; 
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
    onPressed: () => Navigator.pop(context), 
    child: const Text('Cancel'),
  ),
  TextButton(
    onPressed: () {
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
updatedStatusMessage = "Status updated successfully: $newStatus"; 
selectedStatus = newStatus; 
});
}

void saveComment(BuildContext context) {
setState(() {
// save comment code
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
    icon: const Icon(Icons.close), 
    onPressed: () => Navigator.pop(context), 
    ),
    backgroundColor: Theme.of(context).cardColor,
    ),
    body: Center(
        child: Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  // Order Details Container
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColorLight),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Details',
                            style: TextStyle(
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Text(
                                  'Name: ${widget.order.name}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  'Process: ${widget.order.process}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                          'Order Number: ${widget.order.orderNumber}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Unit: ${widget.order.unit}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Type: ${widget.order.type}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Quantity: ${widget.order.quantity}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Rate: \$${widget.order.rate.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Date Submitted: ${widget.order.dateSubmitted}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Department: ${widget.order.department}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Status: ${widget.order.status}',
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        if (updatedStatusMessage != null) ...[
                                          const SizedBox(height: 8.0),
                                          Text(
                                            updatedStatusMessage!,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontFamily: 'Klavika'
                                              ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton<String>(
                                value: selectedStatus,
                                items: statuses.map((status) {
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
                                      selectedStatus = value;
                                      updatedStatusMessage = "Status updated successfully: $value";
                                    });
                                  }
                                },
                                dropdownColor: Theme.of(context).cardColor,
                                style: const TextStyle(fontFamily: 'Klavika', fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(width: 20.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () => deleteOrder(context),
                                child: const Text(
                                  'DELETE ORDER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Comments Container
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColorLight),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comments',
                            style: TextStyle(
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColorLight),
                                color: Theme.of(context).canvasColor,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) => comments = value,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your comments here...',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () => saveComment(context),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontFamily: 'Klavika',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}