import 'package:flutter/material.dart';

class ServicesDetails extends StatefulWidget {
  final String serviceId; 
  final Function onUpdate; 
  final String userId; 

  const ServicesDetails({
    Key? key,
    required this.serviceId,
    required this.onUpdate,
    required this.userId,
  }) : super(key: key);

  @override
  ServicesDetailsState createState() => ServicesDetailsState();
}

class ServicesDetailsState extends State<ServicesDetails> {
  final List<TextEditingController> _serviceControllers = [];
  bool _hasBeenSaved = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on your services data
    _serviceControllers.add(TextEditingController());
    // Add more controllers if you have multiple services
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    for (var controller in _serviceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._serviceControllers.map((controller) {
              return TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Service Detail'),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text(
              _hasBeenSaved ? 'Saved!' : '',
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _hasBeenSaved = !_hasBeenSaved;
            // Assuming you would want to call the update function with relevant data
            widget.onUpdate(); // Pass any necessary parameters
            // Optionally reset the text fields or handle saving
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                _hasBeenSaved = !_hasBeenSaved;
              });
            });
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
