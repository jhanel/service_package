import 'package:flutter/material.dart';
import 'data.dart';
import 'new_order_data.dart';
import 'view_orders.dart';
import 'track_order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateOrderPage()), // Navigate to CreateOrderPage
                );
              },
              child: const Text('Create an Order'), // Button to create an order
            ),
            const SizedBox(height: 20), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const  ViewOrdersPage()), // Navigate to ViewOrdersPage
                );
              },
              child: const Text('View Orders'), // Button to view orders
            ),
            const SizedBox(height: 20), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackOrderPage())
                );
              },
              child: const Text('Track an Order'), // Button to track an order
            ),
          ],
        ),
      ),
    );
  }
}

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  CreateOrderPageState createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for form validation
  String _selectedProcess = 'Thermoforming'; // Default selected process
  String _selectedUnit = 'mm'; // Default selected unit
  String _selectedType = 'Aluminum'; // Default selected type
  double _rate = 0.0; // Rate value initialized to 0.0
  int _quantity = 1; // Default quantity
  final double _volume = 100.0; // Volume placeholder
  List<MaterialRate> rates = [];

  void _loadRates() { // Load rates from data.json
    String jsonString = '''
    [
        {"rate": 2.4, "unit": "mm", "mtl": "Aluminum"},
        {"rate": 2.4, "unit": "cm", "mtl": "Aluminum"},
        {"rate": 2.4, "unit": "inches", "mtl": "Aluminum"},
        {"rate": 1.2, "unit": "mm", "mtl": "Steel"},
        {"rate": 1.2, "unit": "cm", "mtl": "Steel"},
        {"rate": 1.2, "unit": "inches", "mtl": "Steel"},
        {"rate": 4.7, "unit": "mm", "mtl": "Brass"},
        {"rate": 4.7, "unit": "cm", "mtl": "Brass"},
        {"rate": 4.7, "unit": "inches", "mtl": "Brass"}
    ]
    ''';

    rates = parseRates(jsonString);
  }

  void _calculateRate() { // Method to calculate the rate based on selected unit and type
    for (var rate in rates) { // Iterate through the list of rates
      if (rate.unit == _selectedUnit && rate.material == _selectedType) { // Check if the unit and material match the selected values
        setState(() { // Update the state
          _rate = rate.rate; // Set the rate to the matched rate value
        });
        return; // Exit the method once a match is found
      }
    }
  }

  void _submitOrder() async { // Method to submit the order
    if (_formKey.currentState!.validate()) { // Validate the form
      final newOrder = NewOrder(
        process: _selectedProcess,
        unit: _selectedUnit,
        type: _selectedType,
        quantity: _quantity,
        rate: _rate,
        estimatedPrice: _volume * _rate * _quantity,
      );

      await submitNewOrder(newOrder); // Submit the order
      if (!mounted) return; // Checks if widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order submitted successfully!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRates();
    _calculateRate(); // Calculate initial rate when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Order'), // Title in the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Row(
          children: [
            Expanded(
              flex: 1, // Take half of the available width
              child: Form(
                key: _formKey, // Form key for validation
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                  children: [
                    DropdownButtonFormField<String>( // Dropdown for selecting the process
                      value: _selectedProcess, // Current selected value
                      decoration: const InputDecoration(labelText: 'Select Process'), // Input label
                      items: ['Thermoforming', '3D Printing', 'Milling', 'Lathe']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProcess = newValue!;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>( // Dropdown for selecting the unit
                      value: _selectedUnit, // Current selected value
                      decoration: const InputDecoration(labelText: 'Select Unit'), // Input label
                      items: ['mm', 'cm', 'inches'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                          _calculateRate(); // Recalculate rate when value changes
                        });
                      },
                    ),
                    DropdownButtonFormField<String>( // Dropdown for selecting the type
                      value: _selectedType, // Current selected value
                      decoration: const InputDecoration(labelText: 'Select Type'), // Input label
                      items: ['Aluminum', 'Steel', 'Brass'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedType = newValue!;
                          _calculateRate(); // Recalculate rate when value changes
                        });
                      },
                    ),
                    TextFormField( // TextField for entering the quantity
                      decoration: const InputDecoration(labelText: 'Enter Quantity'), // Input label
                      keyboardType: TextInputType.number, // Number keyboard
                      initialValue: '1', // Default value
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.tryParse(value) ?? 1; // Update quantity
                        });
                      },
                    ),
                    const SizedBox(height: 20), // Space between input fields and rate display
                    Text('Rate: $_rate per unit'), // Display the calculated rate
                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: const Text('Submit Order'), // Button to submit the order
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // Space between columns
            Expanded(
              flex: 1, // Take half of the available width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                children: [
                  Text('Process: $_selectedProcess'), // Display selected process
                  Text('Unit: $_selectedUnit'), // Display selected unit
                  Text('Type: $_selectedType'), // Display selected type
                  Text('Quantity: $_quantity'), // Display entered quantity
                  Text('Rate: $_rate per unit'), // Display calculated rate
                  Text('Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}'), // Calculate and display the estimated price
                  const Text('Estimated Delivery: TBD'), // Estimated delivery placeholder
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}