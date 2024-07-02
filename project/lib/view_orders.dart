import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'dart:convert'; // Import to use JSON encoding and decoding
import 'dart:io'; // Import to handle file operations

class ViewOrdersPage extends StatefulWidget { // Define a stateful widget called ViewOrdersPage
  const ViewOrdersPage({super.key}); // Constructor with an optional key parameter

  @override
  ViewOrdersPageState createState() => ViewOrdersPageState(); // Create the state for this widget
}

class ViewOrdersPageState extends State<ViewOrdersPage> { // Define the state for ViewOrdersPage
  List<dynamic> orders = []; // List to store the orders

  @override
  void initState() {
    super.initState();
    _loadOrders(); // Load the orders when the widget is initialized
  }

  Future<void> _loadOrders() async { // Async function to load orders from the JSON file
    const String filePath = 'data.json'; // Path to the JSON file
    File file = File(filePath); // Create a File object for the JSON file

    if (await file.exists()) { // Check if the file exists
      String contents = await file.readAsString(); // Read the contents of the file as a string
      setState(() {
        orders = jsonDecode(contents); // Decode the JSON string into a list of dynamic objects and update the state
      });
    } else {
      setState(() {
        orders = []; // If the file does not exist, set orders to an empty list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'), // Title in the app bar
      ),
      body: ListView.builder( // ListView.builder to build a scrollable list of orders
        itemCount: orders.length, // Number of items in the list
        itemBuilder: (context, index) { // Function to build each item in the list
          var order = orders[index]; // Get the order at the current index
          return ListTile( // Create a ListTile for each order
            title: Text('Order ${index + 1}'), // Title of the ListTile showing the order number
            subtitle: Text(order.toString()), // Subtitle showing the order details
          );
        },
      ),
    );
  }
}
