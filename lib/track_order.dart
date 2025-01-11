import 'package:flutter/material.dart';
import 'order_data.dart'; 
import 'package:collection/collection.dart';
import 'package:css/css.dart';
import 'styles/savedWidgets.dart';


class TrackOrderPage extends StatefulWidget {
  final dynamic currentTheme; 
  const TrackOrderPage({Key? key, required this.currentTheme}) : super(key: key);

  @override
  TrackOrderPageState createState() => TrackOrderPageState();
}

class TrackOrderPageState extends State<TrackOrderPage> {
  final TextEditingController _orderIdController = TextEditingController();
  bool _isCancelRequested = false;
  final double _volume = 100.0;
  NewOrder? _currentOrder;
  bool _isTracking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track Your Order',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600.0;

          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).canvasColor,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  if (!_isTracking) ...[
                    _buildOrderInputField(),
                    const SizedBox(height: 16.0),
                    _buildTrackButton(),
                  ] else ...[
                    Text(
                      'Hello, ${_currentOrder?.name ?? "Order not found"}',
                      style: TextStyle(
                        color: widget.currentTheme == CSS.lsiTheme
                            ? Theme.of(context).cardColor
                            : Theme.of(context).secondaryHeaderColor,
                        fontFamily: 'Klavika',
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (isMobile)
                      Column(
                        children: [
                          _buildOrderDetails(),
                          const SizedBox(height: 16.0),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _buildOrderStatus(), 
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildOrderDetails()),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              height: 400,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: _buildOrderStatus(), 
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderInputField() { //maybe also be able to search by name, jornal transfer number and contact -nlw
    return TextField(
      //controller: _orderIdController,
      decoration: InputDecoration(
        labelText: 'Enter Order ID, Name, Journal Transfer, or Contact',
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(
          color: widget.currentTheme == CSS.hallowTheme
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).hintColor,
          fontFamily: 'Klavika',
          fontWeight: FontWeight.normal,
        ),
      ),
      style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
    );
  }

  Widget _buildTrackButton() {
      return LSIWidgets.squareButton(
      text: 'TRACK',
      onTap: _trackOrder,
      textColor: Theme.of(context).primaryColorLight,
      buttonColor: Theme.of(context).secondaryHeaderColor,
      borderColor: Theme.of(context).secondaryHeaderColor,
      height: 50,
      width: 140,
      radius: 8,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    );
  }

  Widget _buildOrderDetails() { //might want to make the text inside a bit bigger -nlw
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600.0;
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor, 
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

          width: constraints.maxWidth,  
          height: isMobile ? null : 400, 
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDER DETAILS',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor, 
                  fontFamily: 'Klavika',
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),

              const SizedBox(height: 16.0),

              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration
                (
                  color: Theme.of(context).cardColor, 
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentOrder?.orderNumber ?? 'N/A',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                            'File:',
                            style: TextStyle(
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentOrder?.filePath != null && _currentOrder!.filePath.isNotEmpty
                                  ? _currentOrder!.filePath
                                  : 'No file uploaded',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentOrder?.process ?? 'N/A',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentOrder?.unit ?? 'N/A',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentOrder?.type ?? 'N/A',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark, 
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                             _currentOrder?.quantity.toString() ?? '',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                             '${_currentOrder?.rate != null ? _currentOrder!.rate.toStringAsFixed(2) : 'N/A'} per cubic unit',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor, 
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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
                              color:
                                widget.currentTheme == CSS.hallowTheme
                                ? Theme.of(context).hoverColor
                                : widget.currentTheme == CSS.darkTheme
                                ? Theme.of(context).hintColor
                                : widget.currentTheme == CSS.mintTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.lsiTheme
                                ? Theme.of(context).shadowColor
                                : widget.currentTheme == CSS.pinkTheme
                                ? Theme.of(context).shadowColor
                                : Theme.of(context).primaryColorDark,
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${(_volume * (_currentOrder?.rate ?? 0) * (_currentOrder?.quantity ?? 0)).toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontFamily: 'Klavika',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
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

  void _cancelOrder(BuildContext context) {
    if (_isCancelRequested) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Cancellation request already submitted."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      _isCancelRequested = true;
      if (_currentOrder != null) {
        _currentOrder!.markAsCancelled(); 
        notifyAdmin();
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Cancellation"),
          content: const Text("Your order has been set for cancellation."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void notifyAdmin() {
    if (_currentOrder != null) {
      int index = orders.indexWhere((order) => order.orderNumber == _currentOrder!.orderNumber);
      if (index != -1) {
        orders[index].markAsCancelled();
      }
    }
  }




  void _trackOrder() {
  String orderId = _orderIdController.text.trim();

  setState(() {
    _isTracking = true;
  });

  // Use firstWhereOrNull to safely find an order
  NewOrder? order = orders.firstWhereOrNull((o) => o.orderNumber == orderId);

  // If not found by orderNumber, search by other fields
  order ??= orders.firstWhereOrNull(
    (o) =>
        o.name.toLowerCase().contains(orderId.toLowerCase()) ||
        o.journalTransferNumber == orderId ||
        o.contact == orderId,
  );

  if (order != null) {
    // Order found, update the current order
    setState(() {
      _currentOrder = order;
    });
  } else {
    // Order not found, show a MaterialBanner
    ScaffoldMessenger.of(context).clearMaterialBanners(); // Clear any existing banners
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text("Order not found. Please check the order info."),
        backgroundColor: Colors.red.shade700,
        actions: [
          TextButton(
            child: const Text("DISMISS", style: TextStyle(color: Colors.white)),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );
    setState(() {
      _isTracking = false;
    });
  }
}



  Widget _buildOrderStatus() {
  final List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed'];

  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).splashColor,
      borderRadius: BorderRadius.circular(10.0),
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
        Text(
          'ORDER STATUS',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: statuses.map((status) {
              final bool isCompleted = statuses.indexOf(status) <= statuses.indexOf(orders[0].status);
              return Column(
                children: [
                  _buildStatusContainer(status, isCompleted, isLarge: false),
                  if (status != statuses.last) _buildStatusDivider(isCompleted),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 18.0),

        LSIWidgets.squareButton(
          text: 'CANCEL ORDER',
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Order Cancellation Request"),
                  content: const Text("Are you sure you want to cancel your order?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _cancelOrder(context);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          textColor: Theme.of(context).primaryColorLight,
          buttonColor: Theme.of(context).secondaryHeaderColor,
          borderColor: Theme.of(context).secondaryHeaderColor,
          height: 36,
          radius: 8,
          width: 130,
          margin: const EdgeInsets.only(top: 6),
        ),
      ],
    ),
  );
}


  Widget _buildStatusContainer(String title, bool isCompleted, {bool isLarge = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
        //minHeight: 50.0,
      ),
      decoration: BoxDecoration(
        color: isCompleted ? Theme.of(context).secondaryHeaderColor : Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isCompleted
                ? Theme.of(context).primaryColorLight 
                : (widget.currentTheme == CSS.mintTheme
                    ? Theme.of(context).splashColor
                    : widget.currentTheme == CSS.lsiTheme
                        ? Theme.of(context).unselectedWidgetColor
                        : widget.currentTheme == CSS.pinkTheme
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).primaryColorLight), 
            fontSize: 20.0,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDivider(bool isCompleted) {
    return Container(
      height: 10,
      width: 2,
      color: isCompleted
          ? Theme.of(context).secondaryHeaderColor
          : Theme.of(context).hoverColor,
    );
  }
}
