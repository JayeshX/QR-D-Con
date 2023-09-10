
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SheetSelectorPage extends StatefulWidget {
  @override
  _SheetSelectorPageState createState() => _SheetSelectorPageState();
}

class _SheetSelectorPageState extends State<SheetSelectorPage> {
  TextEditingController _controller = TextEditingController();
  String? _storedValue;

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  Future<void> _loadStoredValue() async {
    final storedValue = await loadData();
    setState(() {
      _storedValue = storedValue;
      _controller.text = _storedValue ?? '';
    });
  }

  Future<void> _saveValue() async {
    await saveData();
    _loadStoredValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Value'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveValue,
              child: Text('Save Value'),
            ),
            SizedBox(height: 16),
            Text('Stored Value: $_storedValue'),
          ],
        ),
      ),
    );
  }
  // Saving data to SharedPreferences
  Future<void> saveData() async {
    String inputValue = _controller.text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('of', inputValue);
  }

// Retrieving data from SharedPreferences
  Future<String?> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('of');
  }

}
