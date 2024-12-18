import 'package:flutter/material.dart';
import 'css/css.dart';
import 'order_data.dart';
import 'order_details.dart';

// I usually scroll using my touchscreen, so let me know if scrolling doesn't work with mouse

//scrolling does not seem to be working for the keyboard and mouse -nlw

ThemeData currentTheme = CSS.lightTheme;

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  AdminServicesState createState() => AdminServicesState();

  void switchTheme(LsiThemes theme) {
    
      currentTheme = CSS.changeTheme(theme);  
    
  }
 
}

class ProcessImage {
  final String processName;
  final String imagePath;

  ProcessImage({required this.processName, required this.imagePath});
}

class AdminServicesState extends State<AdminServices> {
  String sortBy = 'Date';
  bool hideCompletedOrders = false; 
  bool showAllOrders = true; 
  List<NewOrder> filteredOrders = []; 
  List<bool> expandedState = []; 
  final double dayWidth = 5.0;
  final double weekWidth = 250.0; 
  final ScrollController _scrollController = ScrollController(); 
  final OrderLogic orderLogic = OrderLogic();
  late DateTime graphStartDate;

  

  Widget getProcessImage(String process) {
    switch (process) {
      case 'Thermoforming':
        return const Image(image: AssetImage('assets/icons/emb_thermoform_sm.png'));
      case '3D Printing':
        return const Image(image: AssetImage('assets/icons/emb_printer_3d_sm.png'));
      case 'Milling':
        return const Image(image: AssetImage('assets/icons/emb_mill_sm.png'));
      default:
        return const Image(image: AssetImage('assets/icons/default_icon.png')); 
    }
  }



  @override
  void initState() {
    super.initState();
    loadOrders(); 
  }

  /* for the following methods, I was able to get the chartHeader to start
     from July 2024 using graphStartDate, but then it messed up the positioning of the timeline bar
  */

  void loadOrders() {
    expandedState = List<bool>.filled(orders.length, false);

    filteredOrders = orders.where((order) {
      if (hideCompletedOrders) {
        return order.status != 'Completed' || order.isCancelled; 
      }
      return true;
    }).toList();

    if (filteredOrders.isNotEmpty) {
      graphStartDate = DateTime(2024, 7, 1);
    }

    if (sortBy == 'Date') {
      filteredOrders.sort((a, b) => DateTime.parse(a.dateSubmitted)
          .compareTo(DateTime.parse(b.dateSubmitted)));
    } else if (sortBy == 'Status') {
      filteredOrders.sort((a, b) => statusHierarchy.indexOf(a.status)
          .compareTo(statusHierarchy.indexOf(b.status)));
    }

    setState(() {}); 
  }

  int calculateDiffinMonths(DateTime start, DateTime end) {
    int monDiff = ((end.year - start.year) * 12) + (end.month - start.month + 1);
    return monDiff;
  }

  DateTime subtractDateByMon(DateTime date, int monthdiff) {
    int newYear = date.year;
    int newMonth = (date.month - monthdiff) + 1;

    if (newMonth <= 0) {
      newYear--;
      newMonth = 12 + newMonth;
    }

    return DateTime(newYear, newMonth, 1);
  }


  List<Widget> chartHeader(BuildContext context) {
    DateTime now = DateTime.now();
    int numOfMonths = calculateDiffinMonths(graphStartDate, now);

    int currYear = graphStartDate.year;
    int currMon = graphStartDate.month;

    double weekWidth = 250.0;
    List<Widget> headerDates = [];

    int startWeek = ((graphStartDate.day - 1) ~/ 7) + 1;

    for (int i = 0; i < numOfMonths; i++) {
      if (currMon > 12) {
        currYear++;
        currMon = 1;
      }

      int endWeek = 4;
      if (currMon == now.month && currYear == now.year) {
        endWeek = ((now.day - 1) ~/ 7) + 1; 
      }

      for (int j = (i == 0 ? startWeek - 1 : 0); j < endWeek; j++) {
        headerDates.add(
          SizedBox(
            width: weekWidth,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "${Month.getMonth(currMon, currYear).name}. '${currYear.toString().substring(2)} Week ${j + 1}",
                style: TextStyle(
                  fontFamily: 'Klavika',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
        );
      }

      currMon++;
    }

    return headerDates;
  }

  List<Widget> timelineBars(BuildContext context) {
    return [
      SizedBox(
        width: calculateTotalWidth(filteredOrders, weekWidth),
        child: Stack(
          children: [
            for (int week = 0;
                week <= calculateDiffinWeeks(graphStartDate, DateTime.now());
                week++)
              Positioned(
                left: week * weekWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.black54,
                ),
              ),
            for (int index = 0; index < filteredOrders.length; index++)
              Positioned(
                top: index * 70.0 + 10, 
                left: calculateBarPosition(
                  graphStartDate,
                  DateTime.parse(filteredOrders[index].dateSubmitted),
                  weekWidth,
                ), 
                child: Container(
                  width: calculateBarWidth(
                    DateTime.parse(filteredOrders[index].dateSubmitted),
                    DateTime.now(),
                    weekWidth,
                  ), 
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    ];
  }



  int calculateDiffinWeeks(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays ~/ 7 + 1;
  }

    double calculateBarPosition(DateTime graphStartDate, DateTime barStartDate, double weekWidth) {
    int daysDifference = barStartDate.difference(graphStartDate).inDays;

    double position = (daysDifference / 7) * weekWidth;

    return position;
  }



  double calculateBarWidth(DateTime startDate, DateTime endDate, double weekWidth) {
    int daysDifference = endDate.difference(startDate).inDays + 1;
    return (daysDifference / 7) * weekWidth;
  }

  double calculateTotalWidth(List<NewOrder> orders, double weekWidth) {
    if (filteredOrders.isEmpty) return weekWidth;

    DateTime latestDate = filteredOrders
        .map((order) => DateTime.parse(order.dateSubmitted))
        .reduce((a, b) => a.isAfter(b) ? a : b);

    int totalWeeks = calculateDiffinWeeks(graphStartDate, latestDate);

    return (totalWeeks + 1) * weekWidth;
  }

  @override
  Widget build(BuildContext context) {
    List<NewOrder> filteredOrders = orders.where((order) {
      if (hideCompletedOrders && order.status == "Completed") {
        return false;
      }
      return true;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        actions: [ //will need a mobile version for the appbar -nlw
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  'Sort By:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                const SizedBox(width: 4.0),
                DropdownButton<String>(
                  value: sortBy,
                  icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).secondaryHeaderColor),
                  dropdownColor: Theme.of(context).cardColor,
                  underline: Container(),
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  items: <String>['Date', 'Status'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      sortBy = newValue!;
                      loadOrders(); 
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'Hide Completed Orders:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Switch(
                  value: hideCompletedOrders,
                  onChanged: (bool value) {
                    setState(() {
                      hideCompletedOrders = value;
                    });
                  },
                  activeColor: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'Show All Orders:',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Switch(
                  value: showAllOrders,
                  onChanged: (bool value) {
                    setState(() {
                      showAllOrders = value;
                    });
                  },
                  activeColor: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: filteredOrders.isEmpty
        ? Center(
            child: Text(
              'No orders available.',
              style: TextStyle(
                fontFamily: 'Klavika',
                fontSize: 18.0,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          )
        : Row(
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).canvasColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateTime.now().year.toString(),
                        style: TextStyle(
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        NewOrder order = filteredOrders[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsPage(order: order, index: index),
                              ),
                            );

                            if (result != null && result is NewOrder) {
                              setState(() {
                                orders[index] = result; 
                              });

                              filteredOrders = orders.where((order) {
                                if (hideCompletedOrders && order.status == "Completed") {
                                  return false;
                                }
                                return true;
                              }).toList();
                            } else if (result != null && result == true) {
                              setState(() {
                                loadOrders(); 
                              });
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      width: 40,
                                      child: getProcessImage(order.process),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.name,
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (order.isCancelled)
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                        ), 
                                        Text(
                                          'Status: ${order.status}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              color: Colors.black54,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, 
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).cardColor,
                      height: 43.0, 
                      child: Row(
                        children: chartHeader(context), 
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).canvasColor, 
                        child: Row(
                          children: timelineBars(context), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsPage extends StatefulWidget {
  final NewOrder order;
  final int index;

  const OrderDetailsPage({Key? key, required this.order, required this.index}) : super(key: key);

  @override
  OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  String? updatedStatusMessage; 
  String selectedStatus = ''; 
  String comments = ''; 
  late TextEditingController _commentsController;
  List<String> savedComments = []; 
  final List<String> statuses = ['Received', 'In Progress', 'Delivered', 'Completed']; 

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status; 
    _commentsController = TextEditingController(text: widget.order.comment);
  }

  void deleteOrder(BuildContext context) { //notify the person who created the order -nlw
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                orders.removeWhere((o) => o.orderNumber == widget.order.orderNumber);
                Navigator.pop(context); 
                Navigator.pop(context, true); 
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }



  void updateStatus(BuildContext context, String newStatus) {
    setState(() {
      widget.order.status = newStatus; 
      updatedStatusMessage = "Status updated successfully: $newStatus";

      final globalOrder = orders.firstWhere((o) => o.orderNumber == widget.order.orderNumber);
      globalOrder.status = newStatus; 
    });

    Navigator.pop(context, widget.order); 
  }



  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  // comment doesn't save when I leave Order Details page :(
  void saveComment(BuildContext context) {
    setState(() {
      widget.order.comment = comments; 
      final globalOrder = orders.firstWhere(
        (o) => o.orderNumber == widget.order.orderNumber,
        orElse: () => widget.order,
      );
      globalOrder.comment = comments; 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.close), 
        onPressed: () => Navigator.pop(context), 
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColorLight),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'Order Details: #${widget.order.orderNumber}',
                            style: const TextStyle(
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Text(
                                  'Name: ${widget.order.name}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Department: ${widget.order.department}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Journal Transfer Number: ${widget.order.journalTransferNumber}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'File: ${widget.order.filePath}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Process: ${widget.order.process}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Unit: ${widget.order.unit}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Type: ${widget.order.type}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Quantity: ${widget.order.quantity}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Rate: \$${widget.order.rate.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Date Submitted: ${widget.order.formatDateSubmitted()}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                Text(
                                  'Status: ${widget.order.status}',
                                  style: const TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.5
                                  ),
                                ),
                                if (updatedStatusMessage != null) ...[
                                  const SizedBox(height: 8.0),
                                  Text(
                                    updatedStatusMessage!,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Klavika',
                                      fontSize: 15.5
                                      ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton<String>(
                                value: statuses.contains(selectedStatus) ? selectedStatus : statuses.first,
                                items: statuses.map((status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedStatus = value;
                                      updatedStatusMessage = "Status updated successfully: $value";
                                      final globalOrder = orders.firstWhere((o) => o.orderNumber == widget.order.orderNumber);
                                      globalOrder.status = value;
                                    });
                                  }
                                },
                                dropdownColor: Theme.of(context).cardColor,
                                style: const TextStyle(fontFamily: 'Klavika', fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(width: 20.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () => deleteOrder(context),
                                child: const Text(
                                  'DELETE ORDER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColorLight),
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comments',
                            style: TextStyle(
                              fontFamily: 'Klavika',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColorLight),
                                color: Theme.of(context).canvasColor,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) => comments = value,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your comments here...',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () => saveComment(context),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontFamily: 'Klavika',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
