import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  TrackOrderPageState createState() => TrackOrderPageState();
}

class TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _orderIdController = TextEditingController();
  String _orderStatus = '';

  void _trackOrder() {
    // Simulate an order tracking process
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
            if (_orderStatus.isNotEmpty) ...[
              _buildTimelineTile('Order Received', Icons.shopping_cart, true),
              _buildTimelineTile('Order Reviewed', Icons.local_shipping, false),
              _buildTimelineTile('Order Shipped', Icons.local_shipping, false),
              _buildTimelineTile('Out for Delivery', Icons.directions_bike, false),
              _buildTimelineTile('Delivered', Icons.home, false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile(String title, IconData icon, bool isCompleted) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      endChild: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: const TextStyle(fontSize: 18.0)),
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted ? Colors.green : Colors.grey,
        thickness: 4,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted ? Colors.green : Colors.grey,
        thickness: 4,
      ),
    );
  }
}
