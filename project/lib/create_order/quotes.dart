import 'package:flutter/material.dart';

class QuotePage extends StatelessWidget {
  final String process;
  final String units;
  final String rate;
  final String type;

  const QuotePage({super.key, 
    required this.process,
    required this.units,
    required this.rate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    // simulate quote calculation
    const double estimatedPrice = 0.0;  // placeholder
    const String estimatedDelivery = '5 days';  // placeholder

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Quote for $process'),
      )*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Units: $units'),
            Text('Rate: $rate'),
            Text('Type: $type'),
            const SizedBox(height: 20),
            Text('Estimated Price: \$${estimatedPrice.toStringAsFixed(2)}'),
            const Text('Estimated Delivery: $estimatedDelivery'),
            const SizedBox(height: 20),
            /*Center(
              child: ElevatedButton(
                onPressed: () {
                  // request order data will be sent here
                },
                child: const Text('Request Order'),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}





























/*import 'package:flutter/material.dart'; // widgets and tools
import 'package:file_picker/file_picker.dart'; // allows use of native file explorer
import 'package:http/http.dart' as http; // allows for individual http requests

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  FilePickerResult? _file; // will hold the result of the file picking action

  // Future is a Flutter class used for asynchronous programming, used to fetch data from a web API
  Future<void> _pickFile() async { // async method that returns a Future
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // opens file picker and awaits user's selection

    if (result != null) { // IF user selects file
      setState(() { // THEN call setState() to update UI
        _file = result; // and update _file
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_file != null) {
      var request = http.MultipartRequest( // sends POST request to specified URL
        'POST',
        Uri.parse('https://pkgserver.com/upload'),
      );
      request.files.add( // adds the selected file to the request as a multipart file
        await http.MultipartFile.fromPath(
          'file',
          _file!.files.single.path!,
        ),
      );
      var response = await request.send(); // sends request and waits for response

      if (response.statusCode == 200) { // checks the status code of the response
        print('File uploaded successfully');
      } else {
        print('File upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Quote'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Choose File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _file != null ? _uploadFile : null,
              child: const Text('Upload File'),
            ),
            const SizedBox(height: 20),
            _file != null
                ? Text('File selected: ${_file!.files.single.name}')
                : const Text('No file selected'),
          ],
        ),
      ),
    );
  }
}*/
