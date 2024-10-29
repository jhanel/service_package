import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
//import 'data.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String sortBy;
  final ValueChanged<String?> onSortChanged;
  final bool hideCompletedOrders;
  final ValueChanged<bool> onHideCompletedOrdersChanged;
  final bool showAllOrders;
  final ValueChanged<bool> onShowAllOrdersChanged;

  const CustomAppBar({super.key, 
    required this.sortBy,
    required this.onSortChanged,
    required this.hideCompletedOrders,
    required this.onHideCompletedOrdersChanged,
    required this.showAllOrders,
    required this.onShowAllOrdersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      actions: [
        // Sort By Dropdown
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
                onChanged: onSortChanged,
              ),
            ],
          ),
        ),

        // Toggle Hide Completed Orders
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
                onChanged: onHideCompletedOrdersChanged,
                activeColor: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          ),
        ),

        // Toggle Show All Orders
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
                onChanged: onShowAllOrdersChanged,
                activeColor: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CurrentDateWidget extends StatelessWidget {
  const CurrentDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String monthYearWeek = '${DateFormat('MMM. \'yy').format(now)} Week ${(now.day / 7).ceil()}';

    return Container(
      height: kToolbarHeight,
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      child: Text(
        monthYearWeek,
        style: TextStyle(
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }
}
