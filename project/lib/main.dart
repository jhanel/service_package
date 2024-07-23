import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:service_package/web_save_file.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:timeline_tile/timeline_tile.dart';
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
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: Center(
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
              child: const Text('Create Order'),
            ),
            const SizedBox(height: 16.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackOrderPage()),
                );
              },
              child: const Text('Track Order'),
            ),
          ],
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


      // Generate a random 3-digit order number
    Random random = Random();
    int orderNumber = 100 + random.nextInt(900);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order submitted! Your Order ID is $orderNumber')),
    );
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Enter Your Name'),
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
                child: const Text('Pick a File'),
              ),
              if (_filePath != null) Text('Selected file: $_filePath'),
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
                            decoration: const InputDecoration(labelText: 'Select Process'),
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
                            decoration: const InputDecoration(labelText: 'Select Unit'),
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
                            decoration: const InputDecoration(labelText: 'Select Type'),
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
                            decoration: const InputDecoration(labelText: 'Enter Quantity'),
                            keyboardType: TextInputType.number,
                            initialValue: '1',
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
                          Text('Rate: $_rate per cubic unit'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Process: $_selectedProcess'),
                          Text('Unit: $_selectedUnit'),
                          Text('Type: $_selectedType'),
                          Text('Quantity: $_quantity'),
                          Text('Rate: $_rate per cubic unit'),
                          Text('Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}'),
                          const Text('Estimated Delivery:'),
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