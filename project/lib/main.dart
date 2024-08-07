import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:service_package/web_save_file.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limbitless Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false, // Removes the debug label
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services:', style: TextStyle(color: Colors.blue.shade900)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blueGrey.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateOrderPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white), // Button background color
                  foregroundColor: WidgetStateProperty.all(Colors.blue), // Button text color
                  side: WidgetStateProperty.all(const BorderSide(color: Colors.blue)), // Button border color
                ),
                child: const Text('Create Order', style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(height: 16.0), // Add spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrackOrderPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white), // Button background color
                  foregroundColor: WidgetStateProperty.all(Colors.blue), // Button text color
                  side: WidgetStateProperty.all(const BorderSide(color: Colors.blue)), // Button border color
                ),
                child: const Text('Track Order', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NewOrder {
  final String process;
  final String unit;
  final String type;
  final int quantity;
  final double rate;
  final double estimatedPrice;
  final String filePath; // Add a new field for the file path

  NewOrder({
    required this.process,
    required this.unit,
    required this.type,
    required this.quantity,
    required this.rate,
    required this.estimatedPrice,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'process': process,
      'unit': unit,
      'type': type,
      'quantity': quantity,
      'rate': rate,
      'estimatedPrice': estimatedPrice,
      'filePath': filePath, // Include file path in JSON
    };
  }
}

Future<void> submitNewOrder(NewOrder order) async {
  const String filePath = 'data.json'; // Path to your JSON file

  File file = File(filePath); // Read the existing JSON file
  List<dynamic> orders = [];
  
  if (await file.exists()) {
    String contents = await file.readAsString();
    orders = jsonDecode(contents);
  }

  orders.add(order.toJson()); // Append the new order

  await file.writeAsString(jsonEncode(orders)); // Write the updated list back to the file

  developer.log('Order submitted!');
}

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  CreateOrderPageState createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage> {
  static const List<List<String>> acceptedExt = [
    ['f3d', 'obj', 'stl', 'stp', 'step'],
    ['f3d', 'stp', 'step']
  ];

  String? _filePath;
  Uint8List? _fileBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedProcess = 'Thermoforming';
  String _selectedUnit = 'mm';
  String _selectedType = 'Aluminum';
  double _rate = 0.0;
  final double _volume = 100.0;
  int _quantity = 1;
  List<dynamic> rates = [];
  final TextEditingController _nameController = TextEditingController();

  void _loadRates() {
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

    rates = jsonDecode(jsonString);
  }

  void _calculateRate() {
    for (var rate in rates) {
      if (rate['unit'] == _selectedUnit && rate['mtl'] == _selectedType) {
        setState(() {
          _rate = rate['rate'];
        });
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRates();
    _calculateRate();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: acceptedExt.expand((x) => x).toList(),
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileBytes = result.files.single.bytes;
      });
    }
  }

  void _submitOrder() async {
  if (_formKey.currentState?.validate() ?? false) {
    // Generate a random 3-digit order number
    Random random = Random();
    int orderNumber = 100 + random.nextInt(900);

    double estimatedPrice = _volume * _rate * _quantity;
    NewOrder newOrder = NewOrder(
      process: _selectedProcess,
      unit: _selectedUnit,
      type: _selectedType,
      quantity: _quantity,
      rate: _rate,
      estimatedPrice: estimatedPrice,
      filePath: _filePath ?? '',
    );

    if (_filePath != null && _fileBytes != null) {
      await SaveFile.saveBytes(
        printName: 'order_file',
        fileType: _filePath!.split('.').last,
        bytes: _fileBytes!,
      );
    }

    submitNewOrder(newOrder);

    // Store order details in the global variable
    globalOrderDetails = OrderDetails()
      ..orderNumber = orderNumber.toString()  // Use the generated order number
      ..userName = _nameController.text
      ..rate = _rate
      ..type = _selectedType
      ..quantity = _quantity
      ..process = _selectedProcess
      ..unit = _selectedUnit;

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order submitted! Your Order ID is $orderNumber')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Order', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Container(
        color: Colors.blueGrey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickFile,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Colors.blue), // Button text color
                  side: WidgetStateProperty.all(const BorderSide(color: Colors.blue)), // Button border color
                ),
                child: const Text('Pick a File'),
              ),
              if (_filePath != null) Text('Selected file: $_filePath', style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 16.0),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedProcess,
                            decoration: const InputDecoration(
                              labelText: 'Select Process',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            items: ['Thermoforming', '3D Printing', 'Milling']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedProcess = newValue!;
                                _calculateRate();
                              });
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            decoration: const InputDecoration(
                              labelText: 'Select Unit',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            items: ['mm', 'cm', 'inches'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedUnit = newValue!;
                                _calculateRate();
                              });
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Select Type',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            items: ['Aluminum', 'Steel', 'Brass'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedType = newValue!;
                                _calculateRate();
                              });
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter Quantity',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: '1',
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a quantity';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _quantity = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Text('Rate: $_rate per cubic unit', style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Process: $_selectedProcess', style: const TextStyle(color: Colors.black)),
                          Text('Unit: $_selectedUnit', style: const TextStyle(color: Colors.black)),
                          Text('Type: $_selectedType', style: const TextStyle(color: Colors.black)),
                          Text('Quantity: $_quantity', style: const TextStyle(color: Colors.black)),
                          Text('Rate: $_rate per cubic unit', style: const TextStyle(color: Colors.black)),
                          Text('Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
                          const Text('Estimated Delivery:', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    foregroundColor: WidgetStateProperty.all(Colors.blue), // Button text color
                    side: WidgetStateProperty.all(const BorderSide(color: Colors.blue)), // Button border color
                  ),
                  child: const Text('Submit Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  TrackOrderPageState createState() => TrackOrderPageState();
}

class TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _orderIdController = TextEditingController();
  String _orderStatus = '';
  final double _volume = 100.0;

  bool _isTracking = false;

  void _trackOrder() {
    setState(() {
      _orderStatus = 'Results for Order #${_orderIdController.text}:';
      _isTracking = true; // Hide the input field and button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Order', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Container(
        color: Colors.blueGrey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_orderStatus.isNotEmpty)
              Text(
                _orderStatus,
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            const SizedBox(height: 16.0),
            if (!_isTracking) ...[
              TextField(
                controller: _orderIdController,
                decoration: const InputDecoration(
                  labelText: 'Enter Order ID',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _trackOrder,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Colors.blue), // Button text color
                  side: WidgetStateProperty.all(const BorderSide(color: Colors.blue)), // Button border color
                ),
                child: const Text('Track Order'),
              ),
              const SizedBox(height: 16.0),
            ],
            if (_orderStatus.isNotEmpty) 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderDetails(),
                  const SizedBox(height: 16.0),
                  _buildOrderStatus(),
                ],
              ),
          ],
        ),
      ),
    );
  }



    Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Number: ${globalOrderDetails.orderNumber}'),
          Text('User Name: ${globalOrderDetails.userName}'),
          Text('Process: ${globalOrderDetails.process}'),
          Text('Unit: ${globalOrderDetails.unit}'),
          Text('Type: ${globalOrderDetails.type}'),
          Text('Quantity: ${globalOrderDetails.quantity}'),
          Text('Rate: ${globalOrderDetails.rate} per cubic unit'),
          Text('Estimated Price: \$${(_volume * globalOrderDetails.rate * globalOrderDetails.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusContainer('Order Received', true),
          _buildDivider(),
          _buildStatusContainer('Order Reviewed', false),
          _buildDivider(),
          _buildStatusContainer('Order Shipped', false),
          _buildDivider(),
          _buildStatusContainer('Out for Delivery', false),
          _buildDivider(),
          _buildStatusContainer('Delivered', false),
        ],
      ),
    );
  }

  Widget _buildStatusContainer(String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14.0),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      width: 20,
      color: Colors.blue,
    );
  }
}


// Global variable to store order details
class OrderDetails {
  String orderNumber = '';
  String userName = '';
  double rate = 0.0;
  String type = '';
  int quantity = 0;
  String process = '';
  String unit = '';
}

OrderDetails globalOrderDetails = OrderDetails();