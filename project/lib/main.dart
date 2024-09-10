import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:service_package/web_save_file.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:math';
import 'css.dart';

class ThemeNotifier extends ChangeNotifier
{
  ThemeData _themeData;

  ThemeNotifier( this._themeData );
  
  getTheme() => _themeData;

  setTheme( ThemeData theme )
  {
    _themeData = theme;
    notifyListeners();
  }
}

void main() 
{
  runApp(
    ChangeNotifierProvider(
      create: ( context ) => ThemeNotifier( CSS.lightTheme ), // default theme
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget
{
  const MyApp( { super.key } );

  @override
  Widget build( BuildContext context )
  {
    return Consumer<ThemeNotifier>
    (
      builder: ( context , themeNotifier , child)
      {
        return const MaterialApp
        (
          title: 'Limbitless Services',
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}

class MyHomePage extends StatelessWidget 
{
  const MyHomePage( { super.key } );
  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text
        (
          'Services',
        ),
      ),

      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            ElevatedButton // Create Order button
            (
              onPressed: ()
              {
                Navigator.push // Takes user to Create Order page
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: ( context ) => const CreateOrderPage()
                  ),
                );
              }, 
              child: Text
              (
                'Create Order',
                style: Theme.of( context ).textTheme.displayMedium,
              ),
            ),
            const SizedBox( height: 16.0 ),
            ElevatedButton // Track Order button
            (
              onPressed: () 
              {
                Navigator.push // Takes user to Track Order page
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: ( context ) => const TrackOrderPage()
                  ),
                );
              },
              child: const Text
              (
                'Track Order'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewOrder 
{
  final String process;
  final String unit;
  final String type;
  final String filePath;
  final double estimatedPrice;
  final double rate;
  final int quantity;

  NewOrder // initializing final variables above
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
      'quantity': quantity,
      'rate': rate,
      'estimatedPrice': estimatedPrice,
      'filePath': filePath,
    };
  }
}

Future<void> submitNewOrder( NewOrder order ) async
{
  const String filePath = 'data.json'; // path to JSON file

  File file = File( filePath ); // read existing JSON file
  List<dynamic> orders = [];

  if ( await file.exists() )
  {
    String contents = await file.readAsString();
    orders = jsonDecode( contents );
  }

  orders.add( order.toJson() ); // append new order
  await file.writeAsString( jsonEncode( orders) ); // write updates list back to file

  developer.log( 'Order submitted!' );
}

class CreateOrderPage extends StatefulWidget
{
  const CreateOrderPage( { super.key } );

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

  final String _selectedProcess = 'Thermoforming';
  final String _selectedUnit = 'mm';
  final String _selectedType = 'Aluminum';
  double _rate = 0.0;
  final double _volume = 100.0;
  final int _quantity = 1;
  List<dynamic> rates = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _journalNumController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  void _loadRates()
  {
    String jsonString =
    '''
    [
      {"rate": 2.4, "unit": "mm", "mtl": "Aluminum"},
      {"rate": 2.4, "unit": "cm", "mtl": "Aluminum"},
      {"rate": 2.4, "unit": "inches", "mtl": "Aluminum"},
      {"rate": 1.2, "unit": "mm", "mtl": "Steel"},
      {"rate": 1.2, "unit": "cm", "mtl": "Steel"},
      {"rate": 1.2, "unit": "inches", "mtl": "Steel"},
      {"rate": 4.7, "unit": "mm", "mtl": "Brass"},
      {"rate": 4.7, "unit": "cm", "mtl": "Brass"},
      {"rate": 4.7, "unit": "inches", "mtl": "Brass"},
    ]
    ''';
    rates = jsonDecode( jsonString );
  }

  void _calculateRate()
  {
    for( var rate in rates )
    {
      if ( rate[ 'unit' ] == _selectedUnit && rate[ 'mtl' ] == _selectedType )
      {
        setState( () { _rate = rate[ 'rate' ]; } );
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
      allowedExtensions: acceptedExt.expand( (x) => x ).toList(),
    );

    if ( result != null )
    {
      setState( () { _filePath = result.files.single.path; _fileBytes = result.files.single.bytes; } );
    }
  }

  void _submitOrder() async
  {
    if ( _formKey.currentState?.validate() ?? false )
    {
      Random random = Random(); // generate random 3-digit order num
      int orderNumber = 100 + random.nextInt( 900 );

      double estimatedPrice = _volume * _rate * _quantity;
      NewOrder newOrder = NewOrder
      (
        process: _selectedProcess,
        unit: _selectedUnit,
        type: _selectedType,
        quantity: _quantity,
        rate: _rate,
        estimatedPrice: estimatedPrice,
        filePath: _filePath ?? '',
      );

      if ( _filePath != null && _fileBytes != null )
      {
        await SaveFile.saveBytes(
          printName: 'order_file',
          fileType: _filePath!.split('.').last,
          bytes: _fileBytes!,
        );
      }

      submitNewOrder( newOrder );

      globalOrderDetails = OrderDetails() // store order details in global var
      ..orderNumber = orderNumber.toString() // use generated order num
      ..userName = _nameController.text
      ..rate = _rate
      ..type = _selectedType
      ..quantity = _quantity
      ..process = _selectedProcess
      ..unit = _selectedUnit;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of( context ).showSnackBar
      (
        SnackBar( content: Text( 'Order submitted! Your Order ID is $orderNumber' ) ),
      );
    }
  }

  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text
        (
          'Create an Order',
          // style
        ),
        // backgroundColor
      ),
      body: Container
      (
        // color
        padding: const EdgeInsets.all( 16.0 ),
        child: Form
        (
          key: _formKey,
          child: LayoutBuilder
          (
            builder: ( context , constraints )
            {
              bool isMobile = constraints.maxWidth < 600; // adjusts width based on screen size
              
            }
          ),
        )
      )
    );
  }




}

