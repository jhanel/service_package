import 'package:flutter/material.dart';
import 'package:css/css.dart';
import 'dart:math';
import 'order_data.dart';
import 'order_details.dart';
import 'styles/savedWidgets.dart';

class CreateOrderPage extends StatefulWidget {
  final dynamic currentTheme;

  const CreateOrderPage({Key? key, required this.currentTheme}) : super(key: key);

  @override
  CreateOrderPageState createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage> {
  final OrderLogic orderLogic = OrderLogic();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _journalNumController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  String? _fileName;
  String? _selectedProcess;
  String? _selectedUnit;
  String? _selectedType;
  int _quantity = 0;
  double _rate = 0.0;

  void _calculateRate() {
    if (_selectedUnit != null && _selectedType != null) {
      setState(() {
        _rate = orderLogic.calculateRate(_selectedUnit!, _selectedType!);
      });
    } else {
      setState(() {
        _rate = 0.0; 
      });
    }
  }


  Future<void> _pickFile() async {
    String? fileName = await orderLogic.pickFile();
    if (fileName != null) {
      setState(() {
        _fileName = fileName;
      });
    }
  }

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      int orderNumber = 100 + Random().nextInt(900);
      double estimatedPrice = _quantity * _rate * volume;

    if (_selectedProcess == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a process!')),
      );
      return;
    }
    if (_selectedUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a unit!')),
      );
      return;
    }
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a type!')),
      );
      return;
    }

      NewOrder newOrder = orderLogic.createOrder(
        process: _selectedProcess!,
        unit: _selectedUnit!,
        type: _selectedType!,
        quantity: _quantity,
        rate: _rate,
        estimatedPrice: estimatedPrice,
        filePath: _fileName ?? '',
        dateSubmitted: DateTime.now().toIso8601String(),
        journalTransferNumber: _journalNumController.text,
        department: _departmentController.text,
        name: _nameController.text,
        orderNumber: orderNumber.toString(),
      );

      orders.add(newOrder);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order submitted! Your Order ID is $orderNumber')),
      );

      _formKey.currentState?.reset();
      _nameController.clear();
      _journalNumController.clear();
      _departmentController.clear();

      setState(() {
        _fileName = null;
        _quantity = 1;
        _rate = 0.0;
        _selectedProcess = null;
        _selectedUnit = null;
        _selectedType = null;
      });
    }
  }


  Widget _buildSubmitOrder() {
    return Center(
      child: ElevatedButton( //use square Button for savedWidgets -nlw
        onPressed: () => _submitOrder(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          'SUBMIT ORDER',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isMobile) { //include a contact field ??? -nlw
    return Form(
    key: _formKey, 
    child: isMobile
    ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnterTextFormField(
            height: 80,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            radius: 8,
            color: Theme.of(context).canvasColor,
            maxLines: 1,
            label: 'Name',
            controller: _nameController,
            onEditingComplete: () {
            },
            onSubmitted: (val) {},
            onTap: () {
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name!';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 80.0,
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
              color:
                widget.currentTheme == CSS.hallowTheme
                ? Theme.of(context).cardColor
                : widget.currentTheme == CSS.darkTheme
                ? Theme.of(context).unselectedWidgetColor
                : widget.currentTheme == CSS.mintTheme
                ? Theme.of(context).indicatorColor
                : widget.currentTheme == CSS.lsiTheme
                ? Theme.of(context).splashColor
                : widget.currentTheme == CSS.pinkTheme
                ? Theme.of(context).indicatorColor
                : Theme.of(context).splashColor, //gonna simplify the themes -nlw
              borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
              controller: _journalNumController,
              decoration: InputDecoration(
                labelText: 'Journal Transfer Number',
                labelStyle: TextStyle(
                  color:
                        widget.currentTheme == CSS.hallowTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.darkTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.mintTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.lsiTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.pinkTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).highlightColor, //gonna simplify the themes -nlw
                  fontFamily: 'Klavika',
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                ),
              ),
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a journal transfer number!';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 16.0),

          Container(
            height: 80.0,
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
              color:
                widget.currentTheme == CSS.hallowTheme
                ? Theme.of(context).cardColor
                : widget.currentTheme == CSS.darkTheme
                ? Theme.of(context).unselectedWidgetColor
                : widget.currentTheme == CSS.mintTheme
                ? Theme.of(context).indicatorColor
                : widget.currentTheme == CSS.lsiTheme
                ? Theme.of(context).splashColor
                : widget.currentTheme == CSS.pinkTheme
                ? Theme.of(context).indicatorColor
                : Theme.of(context).splashColor, //gonna simplify the themes -nlw
              borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
              controller: _departmentController,
              decoration: InputDecoration(
                labelText: 'Department',
                labelStyle: TextStyle(
                  color:
                        widget.currentTheme == CSS.hallowTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.darkTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.mintTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.lsiTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : widget.currentTheme == CSS.pinkTheme
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).highlightColor, //gonna simplify the themes -nlw
                  fontFamily: 'Klavika',
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                ),
              ),
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a department!';
                }
                return null;
              },
            ),
          ),
        ],
      )
    : Row(
        children: [
          Expanded(
            child: EnterTextFormField( //use entertextformfield rather than textformfield -nlw
              //width: 50,
              height: 80,
              padding: const EdgeInsets.all(10),
              radius: 8,
              color: Theme.of(context).primaryColorLight,
              maxLines: 1,
              label: 'Name',
              controller: _nameController,
              onEditingComplete: () {
              },
              onSubmitted: (val) {},
              onTap: () {
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name!';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: EnterTextFormField( //use entertextformfield rather than textformfield -nlw
              //width: 50,
              height: 80,
              padding: const EdgeInsets.all(10),
              radius: 8,
              color: Theme.of(context).primaryColorLight,
              maxLines: 1,
              label: 'Journal Transfer Number',
              controller: _journalNumController,
              onEditingComplete: () {
              },
              onSubmitted: (val) {},
              onTap: () {
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a journal transfer number!';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: EnterTextFormField( //use entertextformfield rather than textformfield -nlw
              //width: 50,
              height: 80,
              padding: const EdgeInsets.all(10),
              radius: 8,
              color: Theme.of(context).primaryColorLight,
              maxLines: 1,
              label: 'Department',
              controller: _departmentController,
              onEditingComplete: () {
              },
              onSubmitted: (val) {},
              onTap: () {
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a department!';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePicker() { //will need a check that they need a file before completing the order -nlw 
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LSIWidgets.squareButton( //use the squareButton for the elveated button -nlw
          text: 'pick a file',
          onTap: _pickFile,
          textColor: Theme.of(context).primaryColorLight,
          buttonColor: Theme.of(context).primaryColor,
          borderColor: Colors.transparent,
          height: 50,
          radius: 8,
          width: 120,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12)
        ),
      
        const SizedBox(width: 10), 

        if (_fileName != null)
          Expanded(
            child: Text(
              _fileName!, 
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20.0), //make the text here bigger -nlw
              overflow: TextOverflow.ellipsis, 
            ),
          ),
      ],
    );
  }

  Widget _buildSelection() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(1, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LSIWidgets.dropDown(
          itemVal: [
            const DropdownMenuItem(value: 'Thermoforming', child: Text('Thermoforming')),
            const DropdownMenuItem(value: '3D Printing', child: Text('3D Printing')),
            const DropdownMenuItem(value: 'Milling', child: Text('Milling')),
          ],
          value: _selectedProcess,
          hint: const Text('Select Process'),
          onchange: (newValue) {
            setState(() {
              _selectedProcess = newValue!;
              _calculateRate();
            });
          },
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          radius: 8.0,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        if (_selectedProcess == 'Process')
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              'Please select a process!',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        LSIWidgets.dropDown(
          itemVal: [
            const DropdownMenuItem(value: 'mm', child: Text('mm')),
            const DropdownMenuItem(value: 'cm', child: Text('cm')),
            const DropdownMenuItem(value: 'inches', child: Text('inches')),
          ],
          value: _selectedUnit,
          hint: const Text('Select Unit'),
          onchange: (newValue) {
            setState(() {
              _selectedUnit = newValue!;
              _calculateRate();
            });
          },
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          radius: 8.0,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        if (_selectedUnit == 'Unit')
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              'Please select a unit!',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        // Type Dropdown
        LSIWidgets.dropDown(
          itemVal: [
            const DropdownMenuItem(value: 'Aluminum', child: Text('Aluminum')),
            const DropdownMenuItem(value: 'Steel', child: Text('Steel')),
            const DropdownMenuItem(value: 'Brass', child: Text('Brass')),
          ],
          value: _selectedType,
          hint: const Text('Select Type'),
          onchange: (newValue) {
            setState(() {
              _selectedType = newValue!;
              _calculateRate();
            });
          },
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          radius: 8.0,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        if (_selectedType == 'Type')
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              'Please select a type!',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        // Quantity Field
        EnterTextFormField(
          height: 80,
          padding: const EdgeInsets.all(10),
          radius: 8,
          color: Theme.of(context).canvasColor,
          label: 'Enter Quantity',
          controller: TextEditingController(text: _quantity.toString()),
          onChanged: (value) {
            setState(() {
              _quantity = int.tryParse(value) ?? 0;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
              return 'Please enter a quantity!';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}


  Widget _buildQuote() {
    return 
    Container
    (
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(1, 1,),
              ),
            ],
      ),
      child: 
      Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Process: ${_selectedProcess ?? 'Not selected'}',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Unit: ${_selectedUnit ?? 'Not selected'}',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Type: ${_selectedType ?? 'Not selected'}',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Quantity: $_quantity',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Rate: $_rate per cubic unit',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Estimated Price: \$${(volume * _rate * _quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Estimated Delivery:',
            style: TextStyle(
              fontSize: 20.0,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).secondaryHeaderColor
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).shadowColor
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).secondaryHeaderColor, //gonna simplify the themes -nlw
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
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
            color: Theme.of(context).secondaryHeaderColor,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, 
          ),
          child: Container(
            color: Theme.of(context).canvasColor,
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(isMobile),

                    const SizedBox(height: 30.0),

                    _buildFilePicker(),

                    const SizedBox(height: 30.0),

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
                          const SizedBox(width: 20.0),
                          Expanded(child: _buildQuote()),
                        ],
                      ),

                    const SizedBox(height: 60.0),

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