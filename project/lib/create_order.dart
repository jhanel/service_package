import 'package:flutter/material.dart';
import 'process.dart';

class CreateOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Thermoforming'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcessPage(process: 'Thermoforming')),
              );
            },
          ),
          ListTile(
            title: const Text('3D Printing'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcessPage(process: '3D Printing')),
              );
            },
          ),
          ListTile(
            title: const Text('Milling'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcessPage(process: 'Milling')),
              );
            },
          ),
          ListTile(
            title: const Text('Lathe'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcessPage(process: 'Lathe')),
              );
            },
          ),
        ],
      ),
    );
  }
}
