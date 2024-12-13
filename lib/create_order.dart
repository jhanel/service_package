import 'package:flutter/material.dart';
import 'dart:math';
import 'css/css.dart';
import 'order_data.dart';
import 'order_details.dart';

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
  String _selectedProcess = 'Thermoforming';
  String _selectedUnit = 'mm';
  String _selectedType = 'Aluminum';
  int _quantity = 1;
  double _rate = 0.0;

  void _calculateRate() {
    setState(() {
      _rate = orderLogic.calculateRate(_selectedUnit, _selectedType);
    });
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

      NewOrder newOrder = orderLogic.createOrder(
        process: _selectedProcess,
        unit: _selectedUnit,
        type: _selectedType,
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
      });
    }
  }

  Widget _buildSubmitOrder() {
    return Center(
      child: ElevatedButton(
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

  Widget _buildForm(bool isMobile) {
    return Form(
      key: _formKey, 
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      : Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                              : Theme.of(context).highlightColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name field!';
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
                      : Theme.of(context).splashColor,
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
                              : Theme.of(context).highlightColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a journal transfer number';
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
                      : Theme.of(context).splashColor,
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
                              : Theme.of(context).highlightColor,
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
                  child: Container(
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
                      : Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                            : Theme.of(context).highlightColor, 
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
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
                      : Theme.of(context).splashColor,
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
                            : Theme.of(context).highlightColor,
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                        ),
                      ),
                      style:  TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a journal transfer number!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
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
                      : Theme.of(context).splashColor,
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
                            : Theme.of(context).highlightColor,
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
                ),
              ],
            ),
    );
  }

  Widget _buildFilePicker() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
            backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
            side: WidgetStateProperty.all(BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
            minimumSize: WidgetStateProperty.all(const Size(100, 36)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: Text(
            'PICK A FILE',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.bold,
              color:
                  widget.currentTheme == CSS.hallowTheme
                  ? Theme.of(context).primaryColorLight
                  : widget.currentTheme == CSS.darkTheme
                  ? Theme.of(context).primaryColorLight
                  : widget.currentTheme == CSS.mintTheme
                  ? Theme.of(context).primaryColorLight
                  : widget.currentTheme == CSS.lsiTheme
                  ? Theme.of(context).primaryColorLight
                  : widget.currentTheme == CSS.pinkTheme
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).primaryColorLight,
            ),
          ),
        ),

        const SizedBox(width: 10), 

        if (_fileName != null)
          Expanded(
            child: Text(
              _fileName!, 
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12.0),
              overflow: TextOverflow.ellipsis, 
            ),
          ),
      ],
    );
  }

  Widget _buildSelection() {
  return Container
  (
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
                offset: const Offset(1, 1,),
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
            decoration: InputDecoration(
              labelText: 'Select Process',
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextStyle(
              fontSize: 15.0,
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
                  : Theme.of(context).secondaryHeaderColor,
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
            decoration: InputDecoration(
              labelText: 'Select Unit',
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextStyle(
              fontSize: 15.0,
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
                  : Theme.of(context).secondaryHeaderColor,
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
            decoration: InputDecoration(
              labelText: 'Select Type',
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextStyle(
              fontSize: 15.0,
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
                  : Theme.of(context).secondaryHeaderColor,
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
            decoration: InputDecoration(
              labelText: 'Enter Quantity',
              labelStyle: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Klavika',
                fontWeight: FontWeight.bold,
              ),
            ),
            keyboardType: TextInputType.number,
            initialValue: '1',
            style: TextStyle(
              fontSize: 14.0,
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
                  : Theme.of(context).secondaryHeaderColor,
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
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).secondaryHeaderColor,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.bold,
            ),
          ),
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
            'Process: $_selectedProcess',
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
                  : Theme.of(context).secondaryHeaderColor,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Unit: $_selectedUnit',
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
                  : Theme.of(context).secondaryHeaderColor,
              fontFamily: 'Klavika',
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Type: $_selectedType',
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
                  : Theme.of(context).secondaryHeaderColor,
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
                  : Theme.of(context).secondaryHeaderColor,
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
                  : Theme.of(context).secondaryHeaderColor,
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
                  : Theme.of(context).secondaryHeaderColor,
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
                  : Theme.of(context).secondaryHeaderColor,
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