//from lsicompapp we will need to be given the "order group" (see report_group from report_api), functions fro creating order, 
//updateing order, currentUser to determine if admin or student -nlw
import 'package:flutter/material.dart';
import 'create_order.dart';
import 'track_order.dart';
import 'order_data.dart';
import 'package:css/css.dart';
import 'styles/savedWidgets.dart';
import 'admin.dart';



ThemeData currentTheme = CSS.lightTheme;
//bool isAdmin = true;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> 
{
  //ThemeData currentTheme = CSS.lightTheme;
  void switchTheme(LsiThemes theme) {
    setState(() {
      currentTheme = CSS.changeTheme(theme);  
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limbitless Team Services',
      theme: currentTheme,  
      home: MyHomePage(onThemeChanged: switchTheme), 
      debugShowCheckedModeBanner: false,  
    );
  }
}

class MyHomePage extends StatelessWidget {

  final Function(LsiThemes) onThemeChanged;

  const MyHomePage({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services:',
          style: TextStyle(
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<LsiThemes>(
              value: LsiThemes.light,  
              items: LsiThemes.values.map((LsiThemes theme) {
                return DropdownMenuItem<LsiThemes>(
                  value: theme,
                  child: Text(theme.name),
                );
              }).toList(),
              onChanged: (LsiThemes? newTheme) {
                if (newTheme != null) {
                  onThemeChanged(newTheme);  
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LSIWidgets.squareButton(
                text: 'CREATE ORDER',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrderPage(
                        currentTheme: Theme.of(context),
                      ),
                    ),
                  );
                },
                textColor: Theme.of(context).primaryColorLight,
                buttonColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
                height: 50,
                width: 200,
                radius: 8,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),


              const SizedBox(height: 16.0), 

              LSIWidgets.squareButton(
                text: 'TRACK ORDER',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackOrderPage(
                        currentTheme: Theme.of(context),
                      ),
                    ),
                  );
                },
                textColor: Theme.of(context).primaryColorLight,
                buttonColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
                height: 50,
                width: 200,
                radius: 8,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),


              const SizedBox(height: 16.0),
              //need to include a check if they are admin or not -nlw
              LSIWidgets.squareButton(
                text: 'GO TO ADMIN PAGE',
                onTap: () {
                  if (isAdmin()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminServices(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Access Denied.'),
                      ),
                    );
                  }
                },
                textColor: Theme.of(context).primaryColorLight,
                buttonColor: Theme.of(context).secondaryHeaderColor,
                borderColor: Theme.of(context).secondaryHeaderColor,
                height: 50,
                width: 200,
                radius: 8,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}