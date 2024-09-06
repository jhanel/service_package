import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:service_package/web_save_file.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:math';

void main() 
{
  runApp( const MyApp() );
}

class MyApp extends StatelessWidget
{
  const MyApp( { super.key } );

  @override
  Widget build( BuildContext context )
  {
    return const MaterialApp
    (
      title: 'Limbitless Services',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
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
              child: const Text
              (
                'Create Order'
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
      required this.process,
    }
  );
},