import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:qrd_con/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  @override
  final List<dynamic> grArray;

  HomeScreen({required this.grArray});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final gsheets = GSheets(credentials); // Replace with your credentials
  final spreadsheetId = '1WXCU7v7qFXQxYh_N5aqY-bupZ7fOC4oC5JhTmgWgzrI'; // Replace with your spreadsheet ID
  var grNumbers = [] ; // Replace with your GR numbers
  String? _storedValue;

  List<String> fetchedData = [];

  @override
  void initState() {
    super.initState();
    grNumbers = widget.grArray;
    if (grNumbers.length!=0){
      try{
      _loadStoredValue();
      }catch(e){
        _storedValue='Null Event';
      }
      fetchDataFromGoogleSheets();
    }else{
      setState(() {
        fetchedData.add('Scan');
      });
    }
  }
  Future<void> _loadStoredValue() async {
    final storedValue = await loadData();
    setState(() {
      _storedValue = storedValue;
      // _controller.text = _storedValue ?? '';
    });
  }

  Future<void> fetchDataFromGoogleSheets() async {
    for (final grNumber in grNumbers) {
      final spreadsheet = await gsheets.spreadsheet('1WXCU7v7qFXQxYh_N5aqY-bupZ7fOC4oC5JhTmgWgzrI');
      final beSheet = await spreadsheet.worksheetByTitle('BE');
      final teSheet = await spreadsheet.worksheetByTitle('TE');
      final seSheet = await spreadsheet.worksheetByTitle('SE');
      // final re = await beSheet!.values.map.rowByKey();
      final beData = await beSheet!.values.map.allRows() as List<Map<String, String>>;
      final teData = await teSheet!.values.map.allRows() as List<Map<String, String>>;
      final seData = await seSheet!.values.map.allRows() as List<Map<String, String>>;

      // Convert the data to the expected format (List<List<dynamic>>)
      final beDataList = beData.map((row) => row.values.toList()).toList();
      final teDataList = teData.map((row) => row.values.toList()).toList();
      final seDataList = seData.map((row) => row.values.toList()).toList();

      // create worksheet if it does not exist yet
      // var sheet = spreadsheet.worksheetByTitle('example');
      // sheet ??= await spreadsheet.addWorksheet('example');
      // final secondRow = {
      //   'index': '5',
      //   'letter': 'f',
      //   'number': '6',
      //   'label': 'f6',
      // };
      // await sheet.values.map.appendRow(secondRow);

      fetchAndPrintDataForGR(beDataList, grNumber);
      fetchAndPrintDataForGR(teDataList, grNumber);
      fetchAndPrintDataForGR(seDataList, grNumber);
    }
  }

  Future<void> fetchAndPrintDataForGR(List<List<dynamic>> data, String grNumber) async {
    final spreadsheet = await gsheets.spreadsheet('1-nxX_qLH1mXWnDBQEYu7odUX73V7nug8cdx6D7Hwiw0');
    for (final row in data) {
      if (row.isNotEmpty && row[0] == grNumber) {
        final name = row[1];
        final email = row[2];
        final mobileNumber = row[3];
        final feedback = row[4];
        final adhaar = row[5];
        var sheet = spreadsheet.worksheetByTitle('Sheet1');
        sheet ??= await spreadsheet.addWorksheet('Sheet1');
        DateTime now = DateTime.now();
        String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        final secondRow = {
          'Event' : _storedValue,
          'Name': name,
          'Email': email,
          'Mobile Number': mobileNumber,
          'Timestamp': formattedTimestamp,
          'Aadhar' : adhaar,
        };
        await sheet.values.map.appendRow(secondRow);



        // _submitForm(name, email, mobileNumber, feedback);
        setState(() {
          fetchedData.add(
            'GR Number: $grNumber\nName: $name\nEmail: $email\nMobile Number: $mobileNumber\nFeedback: $feedback\n---',
          );
        });
      }
    }
  }
  _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //
    // final snackBar = SnackBar(content: Text(message));
    // _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sheets Data Fetcher'),
      ),
      body: ListView.builder(
        itemCount: fetchedData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              fetchedData[index],
              style: TextStyle(fontSize: 16.0),
            ),
          );
        },
      ),
    );
  }
  Future<String?> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('of');
  }
}
