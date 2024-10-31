import 'package:flutter/material.dart';

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();
}

class AdminServicesState extends State<AdminServices> {
  String sortBy = 'Date'; // Default sort option
  bool hideCompletedOrders = false; // Toggle switch state
  bool showAllOrders = true; // Toggle for showing all orders

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
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Center(
          child: Text(
            'No orders available at this time.',
            style: TextStyle(
              fontFamily: 'Klavika',
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      ),
    );
  }
}