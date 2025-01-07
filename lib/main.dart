//from lsicompapp we will need to be given the "order group" (see report_group from report_api), functions fro creating order, 
//updateing order, currentUser to determine if admin or student -nlw
import 'package:flutter/material.dart';
import 'create_order.dart';
import 'track_order.dart';
import 'css/css.dart'; //will need to call the package css.dart; include in the pubspec.yaml -nlw
import 'admin.dart';



ThemeData currentTheme = CSS.lightTheme;

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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateOrderPage(currentTheme: Theme.of(context),)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                  side: WidgetStateProperty.all( BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
                ),
                child: Text(
                  'CREATE ORDER',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const SizedBox(height: 16.0), 

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackOrderPage(currentTheme: Theme.of(context))),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                  side: WidgetStateProperty.all( BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  )),
                ),
                child: Text(
                  'TRACK ORDER',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              //need to include a check if they are admin or not -nlw
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminServices()), 
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                  side: WidgetStateProperty.all(BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                ),
                child: Text(
                  'GO TO ADMIN PAGE', 
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
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