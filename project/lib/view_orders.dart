/*import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ViewOrdersPage extends StatefulWidget {
  const ViewOrdersPage({Key? key}) : super(key: key);

  @override
  ViewOrdersPageState createState() => ViewOrdersPageState();
}

class ViewOrdersPageState extends State<ViewOrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders(); // Initial load of orders when the page is first created
  }

  Future<void> _loadOrders() async {
    try {
      String filePath = 'data.json';
      File file = File(filePath);

      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          orders = jsonDecode(contents);
        });
      } else {
        setState(() {
          orders = [];
        });
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return ListTile(
              title: Text('Order ${index + 1}'),
              subtitle: Text(order.toString()),
            );
          },
        ),
      ),
    );
  }
}*/
