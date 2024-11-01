import 'package:flutter/material.dart';
import 'services_details.dart'; // Importing services_details.dart
import 'data.dart'; // Importing data.dart

class ServicesWidget extends StatefulWidget {
  const ServicesWidget({Key? key}) : super(key: key);

  @override
  ServicesWidgetState createState() => ServicesWidgetState();
}

class ServicesWidgetState extends State<ServicesWidget> {
  List<NewOrder> _services = []; // List to hold services (using NewOrder)

  @override
  void initState() {
    super.initState();
    _loadServices(); // Load initial services data
  }

  void _loadServices() {
    // Assuming you have a list of services in your data.dart
    // Here you would replace with your actual data initialization
    _services = [
      // Example data; replace this with your actual service initialization logic
      NewOrder(
        orderNumber: '1',
        name: 'Service A',
        process: 'Process A',
        unit: 'Unit A',
        type: 'Type A',
        quantity: 10,
        rate: 100.0,
        dateSubmitted: '2024-10-01',
        department: 'Dept A',
        status: 'Pending', 
        estimatedPrice: 0.00, 
        filePath: '', 
        journalTransferNumber: '',
        
      ),
      NewOrder(
        orderNumber: '2',
        name: 'Service B',
        process: 'Process B',
        unit: 'Unit B',
        type: 'Type B',
        quantity: 20,
        rate: 200.0,
        dateSubmitted: '2024-10-02',
        department: 'Dept B',
        status: 'Completed', 
        estimatedPrice: 0.00, 
        filePath: '', 
        journalTransferNumber: '',
        
      ),
      // Add more services as needed...
    ];
  }

  void _addOrEditService({NewOrder? service}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesDetails(
          serviceId: service?.orderNumber ?? '',
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

  void _confirmDeleteService(int index) {
    // Show a confirmation dialog before deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this service?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _services.removeAt(index); // Remove service from the list
                });
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service deleted successfully.')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
              onPressed: () => _confirmDeleteService(index), // Confirm before deletion
            ),
          );
        },
      ),
    );
  }
}