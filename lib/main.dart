import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrd_con/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'sheetselector.dart'; // Import your SheetSelector widget
void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
