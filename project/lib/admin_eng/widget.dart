import 'package:flutter/material.dart';
import 'services_details.dart';  // Importing services_details.dart
//import 'savedWidgets.dart';      // Importing savedWidgets.dart
import 'data.dart';              // Importing data.dart

class ServicesWidget extends StatefulWidget {
  const ServicesWidget({super.key});

  @override
  ServicesWidgetState createState() => ServicesWidgetState();
}

class ServicesWidgetState extends State<ServicesWidget> {
  final List<NewOrder> _services = []; // List to hold services (using NewOrder)

  void _addOrEditService({NewOrder? service}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesDetails(
          serviceId: service?.orderNumber ?? '', // Use orderNumber as a unique identifier
          onUpdate: (updatedService) {
            setState(() {
              if (service == null) {
                // Adding a new service
                _services.add(updatedService);
              } else {
                // Editing an existing service
                int index = _services.indexWhere((s) => s.orderNumber == service.orderNumber);
                if (index != -1) {
                  _services[index] = updatedService; // Update the service
                }
              }
            });
            Navigator.pop(context); // Close the detail view
          },
          userId: "currentUserId", // Pass the user ID if necessary
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditService(), // Navigate to add service
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return ListTile(
            title: Text(service.name),
            subtitle: Text(service.process), // Using 'process' for subtitle
            onTap: () => _addOrEditService(service: service), // Navigate to edit service
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _services.removeAt(index); // Remove service from the list
                });
              },
            ),
          );
        },
      ),
    );
  }
}