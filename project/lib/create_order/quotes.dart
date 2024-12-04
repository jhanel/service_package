import 'package:flutter/material.dart';

class QuotePage extends StatelessWidget {
  final String process;
  final String units;
  final String rate;
  final String type;

  const QuotePage({super.key, 
    required this.process,
    required this.units,
    required this.rate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    const double estimatedPrice = 0.0;  
    const String estimatedDelivery = '5 days';  

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Units: $units'),
            Text('Rate: $rate'),
            Text('Type: $type'),
            const SizedBox(height: 20),
            Text('Estimated Price: \$${estimatedPrice.toStringAsFixed(2)}'),
            const Text('Estimated Delivery: $estimatedDelivery'),
            const SizedBox(height: 20),
          
          ],
        ),
      ),
    );
  }
}