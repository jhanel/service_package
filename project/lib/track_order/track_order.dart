import 'package:flutter/material.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  TrackOrderPageState createState() => TrackOrderPageState();
}

class TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _orderIdController = TextEditingController();
  String _orderStatus = '';

  void _trackOrder() {
    setState(() {
      _orderStatus = 'Results for Order #${_orderIdController.text}:';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _orderIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Order ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _trackOrder,
              child: const Text('Track Order'),
            ),
            const SizedBox(height: 16.0),
            Text(
              _orderStatus,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}