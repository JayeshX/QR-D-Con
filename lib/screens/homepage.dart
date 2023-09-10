import 'package:flutter/material.dart';
import 'package:qrd_con/screens/scanpage.dart';
import 'package:qrd_con/screens/sheetselector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _storedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Scan Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );
              },
              child: Text('Scan Page'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _loadStoredValue();
                print(_storedValue);
                // Navigate to the Sheet Selector Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SheetSelectorPage()),
                );
              },
              child: Text('Sheet Selector'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage()),
                );
              },
              child: Text('Details Page'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('of');
  }
  Future<void> _loadStoredValue() async {
    final storedValue = await loadData();
    setState(() {
      _storedValue = storedValue;
    });
  }
}
