import 'package:flutter/material.dart';
import 'quotes.dart';

class ProcessPage extends StatelessWidget {
  final String process;

  ProcessPage({super.key, required this.process});

  final TextEditingController unitsController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(process),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: unitsController,
              decoration: const InputDecoration(
                labelText: 'Units (mm, cm, inch)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rateController,
              decoration: const InputDecoration(
                labelText: 'Rate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuotePage( 
                      process: process,
                      units: unitsController.text,
                      rate: rateController.text,
                      type: typeController.text,
                    ),
                  ),
                );
              },
              child: const Text('Get Quote'),
            ),
          ],
        ),
      ),
    );
  }
}
