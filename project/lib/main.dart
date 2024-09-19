
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:service_package/web_save_file.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:math';
import 'css.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  
  ThemeData currentTheme = CSS.lightTheme; // default light theme from css.dart

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limbitless Team Services',
      theme: currentTheme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,  
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services:',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            color: CSS.lightTheme.primaryTextTheme.displayLarge!.color,
          ),
        ),
        backgroundColor: CSS.lightTheme.primaryColorLight
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // buttons for creating and tracking orders

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateOrderPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(CSS.lightTheme.primaryColor),
                  side: WidgetStateProperty.all( BorderSide(width: 2.0, color: CSS.lightTheme.primaryColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
                ),
                child: Text(
                  'CREATE ORDER',
                  style: TextStyle(
                    color: CSS.lightTheme.primaryColorLight,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const SizedBox(height: 16.0),  // spacing between buttons

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrackOrderPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(CSS.lightTheme.primaryColor),
                  side: WidgetStateProperty.all( BorderSide(width: 2.0, color: CSS.lightTheme.primaryColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  )),
                ),
                child: Text(
                  'TRACK ORDER',
                  style: TextStyle(
                    color: CSS.lightTheme.primaryColorLight,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
  final String filePath; // add a new field for the file path

  NewOrder
  (
    {
      required this.process,
      required this.unit,
      required this.type,
      required this.quantity,
      required this.rate,
      required this.estimatedPrice,
      required this.filePath,
    }
  );

  Map<String, dynamic> toJson() 
  {
    return 
    {
      'process': process,
      'unit': unit,
      'type': type,
      'quantity': quantity,
      'rate': rate,
      'estimatedPrice': estimatedPrice,
      'filePath': filePath, // include file path in JSON
    };
  }
}

Future<void> submitNewOrder(NewOrder order) async 
{
  const String filePath = 'data.json'; // path to JSON file

  File file = File(filePath); // read existing JSON file
  List<dynamic> orders = [];
  
  if (await file.exists()) 
  {
    String contents = await file.readAsString();
    orders = jsonDecode(contents);
  }

  orders.add(order.toJson()); // append new order

  await file.writeAsString(jsonEncode(orders)); // write updated list back to the file

  developer.log('Order submitted!');
}

class CreateOrderPage extends StatefulWidget 
{
  const CreateOrderPage( { super.key }) ;

  @override
  CreateOrderPageState createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage> 
{
  static const List<List<String>> acceptedExt = 
  [
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
  final TextEditingController _journalNumController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  void _loadRates() 
  {
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

    rates = jsonDecode( jsonString );
  }

  void _calculateRate() 
  {
    for (var rate in rates) 
    {
      if (rate['unit'] == _selectedUnit && rate['mtl'] == _selectedType) 
      {
        setState( () {  _rate = rate[ 'rate' ]; } );
        return;
      }
    }
  }

  @override
  void initState() 
  {
    super.initState();
    _loadRates();
    _calculateRate();
  }

  Future<void> _pickFile() async 
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles
    (
      type: FileType.custom,
      allowedExtensions: acceptedExt.expand((x) => x).toList(),
    );

    if (result != null) 
    {
      setState(() { _filePath = result.files.single.path; _fileBytes = result.files.single.bytes; });
    }
  }

  void _submitOrder(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {

      // generate random 3-digit number

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

      submitNewOrder(newOrder); // submit new order

      // store order details in global variable

      globalOrderDetails = OrderDetails()
        ..orderNumber = orderNumber.toString()
        ..userName = _nameController.text
        ..rate = _rate
        ..type = _selectedType
        ..quantity = _quantity
        ..process = _selectedProcess
        ..unit = _selectedUnit;

      // display snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order submitted! Your Order ID is $orderNumber')),
      );
    }
  }


  // HELPER FUNCTIONS
  
  // form fields (name, journal, department)
  Widget _buildForm(bool isMobile) {
    return Form(
      key: _formKey,  // attach the form key
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Name',
                    labelStyle: TextStyle(
                      color: CSS.lightTheme.shadowColor,
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF000000)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill out the name field!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _journalNumController,
                  decoration: InputDecoration(
                    labelText: 'Journal Transfer Number',
                    labelStyle: TextStyle(
                      color: CSS.lightTheme.shadowColor,
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF000000)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the journal transfer number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _departmentController,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    labelStyle: TextStyle(
                      color: CSS.lightTheme.shadowColor,
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF000000)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the department';
                    }
                    return null;
                  },
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      labelStyle: TextStyle(
                        color: CSS.lightTheme.shadowColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF000000)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill out the name field!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _journalNumController,
                    decoration: InputDecoration(
                      labelText: 'Journal Transfer Number',
                      labelStyle: TextStyle(
                        color: CSS.lightTheme.shadowColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF000000)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the journal transfer number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _departmentController,
                    decoration: InputDecoration(
                      labelText: 'Department',
                      labelStyle: TextStyle(
                        color: CSS.lightTheme.shadowColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF000000)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the department';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
    );
  }



  // file picker
  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
            backgroundColor: WidgetStateProperty.all(CSS.lightTheme.primaryColor),
            side: WidgetStateProperty.all( BorderSide(width: 2.0, color: CSS.lightTheme.primaryColor)),
            minimumSize: WidgetStateProperty.all(const Size(100, 36)),
            shape: WidgetStateProperty.all
            (
              RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(8.0),
                )
            )
          ),
          child: Text(
            'PICK A FILE',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.bold,
              color: CSS.lightTheme.primaryColorLight
            ),
          ),
        ),
        if (_filePath != null)
          Text(
            'Selected file: $_filePath',
            style: const TextStyle(color: Color(0xFF000000)),
          ),
      ],
    );
  }

  // selection form
  Widget _buildSelection() {
  return Container
  (
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0xFF707070),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
      child: 
      Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedProcess,
            decoration: const InputDecoration(
              labelText: 'Select Process',
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF000000),
                fontFamily: 'Klavika',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
            items: ['Thermoforming', '3D Printing', 'Milling'].map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
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
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF000000),
                fontFamily: 'Klavika',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
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
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF000000),
                fontFamily: 'Klavika',
                fontWeight: FontWeight.normal,
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
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
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF000000),
                fontFamily: 'Klavika',
                fontWeight: FontWeight.normal,
              ),
            ),
            keyboardType: TextInputType.number,
            initialValue: '1',
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF000000),
            ),
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
          Text(
            'Rate: $_rate per cubic unit',
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // generate quote
  Widget _buildQuote() {
    return 
    Container
    (
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF707070),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: 
      Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Process: $_selectedProcess',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Unit: $_selectedUnit',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Type: $_selectedType',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Quantity: $_quantity',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Rate: $_rate per cubic unit',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          const Text(
            'Estimated Delivery:',
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000),
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for the submitting order
  Widget _buildSubmitOrder() {
  return Center(
    child: ElevatedButton(
      onPressed: () {
        _submitOrder(context); // pass context directly
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(CSS.lightTheme.primaryColor),
        side: WidgetStateProperty.all(BorderSide(width: 2.0, color: CSS.lightTheme.primaryColor)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Text(
        'SUBMIT ORDER',
        style: TextStyle(
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
          color: CSS.lightTheme.primaryColorLight,
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create an Order',
          style: TextStyle(
            color: CSS.lightTheme.primaryTextTheme.displayLarge!.color,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CSS.lightTheme.primaryColorLight
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // minimum height is screen height
          ),
          child: Container(
            color: const Color(0xFFEEEEEE),
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FORM
                    _buildForm(isMobile),

                    const SizedBox(height: 30.0),

                    // FILE PICKER
                    _buildFilePicker(),

                    const SizedBox(height: 30.0),

                    // SELECTION AND QUOTE CONTAINERS
                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSelection(),
                          const SizedBox(height: 30.0),
                          _buildQuote(),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildSelection()),
                          const SizedBox(width: 20.0), // spacing between containers
                          Expanded(child: _buildQuote()),
                        ],
                      ),

                    const SizedBox(height: 60.0),

                    // SUBMIT BUTTON
                    _buildSubmitOrder(),
                  ],
                );
              },
            ),
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
  String _orderStatus = ''; // *** COME BACK TO THIS
  final double _volume = 100.0;

  bool _isTracking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track Your Order',
          style: TextStyle(
            color: CSS.lightTheme.primaryTextTheme.displayLarge!.color,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CSS.lightTheme.primaryColorLight,
      ),

      body: Container(
        color: CSS.lightTheme.hoverColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16.0),
            if (!_isTracking) ...[
              TextField(
                controller: _orderIdController,
                decoration: InputDecoration(
                  labelText: 'Enter Order ID',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: CSS.lightTheme.shadowColor,
                    fontFamily: 'Klavika', fontWeight: FontWeight.normal,
                  ),
                ),
                style: const TextStyle(color: Color(0xFF000000)),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _trackOrder,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(CSS.lightTheme.primaryColor),
                  side: WidgetStateProperty.all( BorderSide(width: 2.0, color: CSS.lightTheme.primaryColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), 
                  )),
                ),
                child: Text('TRACK',
                  style: TextStyle(
                    color: CSS.lightTheme.primaryColorLight,
                    fontFamily: 'Klavika', fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ]

            // Main widget layout method
              else ...[
              // display greeting message and order details container when tracking
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${globalOrderDetails.userName}',
                    style: TextStyle(
                      color: CSS.lightTheme.primaryColor,
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildOrderDetails(), // order deets
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16.0),


            /*if (_orderStatus.isNotEmpty) 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Message
                  Text(
                    'Hi, ${globalOrderDetails.userName}',
                    style: const TextStyle(
                      color: Color(0xFF2A94D4),
                      fontFamily: 'Klavika',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0, 
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Order Details Section
                  _buildOrderDetails(),

                  const SizedBox(height: 16.0),

                  // Order Status Section
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width, 
                    ),
                    child: _buildOrderStatus(),
                  ),
                ],
              )*/
          ],
        ),
      ),
    );
  }



  Widget _buildOrderDetails() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600.0;
        return Container(
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: CSS.lightTheme.primaryColorLight, 
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),

          width: constraints.maxWidth,  // this takes up full width
          height: isMobile ? null : 400, // adjusts height based on screen size
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                'ORDER DETAILS',
                style: TextStyle(
                  color: CSS.lightTheme.primaryColor, 
                  fontFamily: 'Klavika',
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 16.0),

              // details 
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration
                (
                  color: CSS.lightTheme.splashColor, 
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Number:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.orderNumber,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.userName,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Process:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.process,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unit:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.unit,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Type:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.type,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              globalOrderDetails.quantity.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark,
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rate:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${globalOrderDetails.rate} per cubic unit',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Price:',
                            style: TextStyle(
                              color: CSS.lightTheme.primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${(_volume * (globalOrderDetails.rate) * (globalOrderDetails.quantity)).toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CSS.lightTheme.primaryColorDark,
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


void _trackOrder() {
  setState(() {
    _orderStatus = 'Results for Order #${_orderIdController.text}:';
    _isTracking = true; // hides input field and button
  });
}



 Widget _buildOrderStatus() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600.0;

        return isMobile
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical, // enables vertical scrolling
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusContainer('Received', true),
                    _buildStatusDivider(),
                    _buildStatusContainer('Preparing', false),
                    _buildStatusDivider(),
                    _buildStatusContainer('Completed', false),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusContainer('Received', true),
                  _buildDivider(),
                  _buildStatusContainer('Preparing', false),
                  _buildDivider(),
                  _buildStatusContainer('Completed', false),
                ],
              );
      },
    );
  }

  Widget _buildStatusContainer(String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      constraints: const BoxConstraints(
        maxWidth: 200, // limits width to fit within mobile view
      ),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF2A94D4) : const Color(0xFFBBBBBB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14.0,
          fontFamily: 'Klavika',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      width: 20,
      color: const Color(0xFF2A94D4),
    );
  }

  Widget _buildStatusDivider() {
    return Container(
      height: 10,
      width: 2,
      color: const Color(0xFF2A94D4),
    );
  }
}


// global variable to store order details
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

