import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences
import 'package:http/http.dart' as http; // For API calls
import 'dart:convert'; // For JSON encoding
import 'sip.dart';

class ExpenseFormPage extends StatefulWidget {
  @override
  _ExpenseFormPageState createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCommonExpense;

  String? _titleError;
  String? _amountError;
  String? _dateError;
  String? _dropdownError;

  List<Map<String, String>> _savedExpenses = [];
  double _swipeProgress = 0.0; // To track swipe progress

  final List<String> _commonExpenses = [
    "Food",
    "Transport",
    "Utilities",
    "Rent",
    "Entertainment",
    "Health",
    "Education",
    "Shopping",
    "Travel",
    "Miscellaneous"
  ];

  @override
  void initState() {
    super.initState();
    _swipeProgress = 0.0; // Ensure the arrow starts at the beginning
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateError = null;
      });
    }
  }

  void _validateInputs() {
    String title = _titleController.text.trim();
    String amount = _amountController.text.trim();

    setState(() {
      _titleError = RegExp(r'^[a-zA-Z\s]+$').hasMatch(title)
          ? null
          : "Only characters are allowed";
      _amountError = RegExp(r'^\d+$').hasMatch(amount)
          ? null
          : "Only numbers are allowed";
      _dateError = _selectedDate != null ? null : "Select the date";
      _dropdownError = _selectedCommonExpense != null
          ? null
          : "Select a common expense";
    });

    if (_titleError == null &&
        _amountError == null &&
        _dateError == null &&
        _dropdownError == null) {
      _saveExpense();
    }
  }

  Future<void> _saveExpense() async {
    String title = _titleController.text.trim();
    String amount = _amountController.text.trim();
    String date = DateFormat.yMMMd().format(_selectedDate!);
    String commonExpense = _selectedCommonExpense!;

    Map<String, dynamic> expenseData = {
      'title': title,
      'amount': amount,
      'date': date,
      'commonExpense': commonExpense,
    };

    // Fetch username from SharedPreferences
    final username = await _getUsername();
    if (username != null) {
      expenseData['username'] = username;
    }

    // Add to the local list
    setState(() {
      _savedExpenses.add(expenseData.map((key, value) => MapEntry(key, value.toString())));
    });

    // Send to the backend
    await _sendExpenseToBackend(expenseData);

    _showSnackbar(
        'Expense Saved:\nTitle: $title, Amount: ₹$amount, Date: $date, Type: $commonExpense');
    _clearForm();
  }

  Future<void> _sendExpenseToBackend(Map<String, dynamic> expenseData) async {
    final String apiUrl = "https://profenx-backend.onrender.com/api/users/addExpense"; // Replace with your API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expenseData),
      );

      if (response.statusCode == 200) {
        _showSnackbar("Expense successfully sent to the backend.");
      } else {
        _showSnackbar("Failed to send expense. Try again.");
      }
    } catch (error) {
      _showSnackbar("Error sending expense: $error");
    }
  }

  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void _clearForm() {
    _titleController.clear();
    _amountController.clear();
    _selectedDate = null;
    _selectedCommonExpense = null;
    _titleError = null;
    _amountError = null;
    _dateError = null;
    _dropdownError = null;
  }

  void _cancelExpense() {
    _clearForm();
    _showSnackbar('Form cleared');
  }

  void _deleteExpense(int index) {
    setState(() {
      _savedExpenses.removeAt(index);
    });
    _showSnackbar('Expense deleted');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToSip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvestmentPage()),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _swipeProgress += details.delta.dx / (MediaQuery.of(context).size.width - 80); // Adjusted to account for button size
      if (_swipeProgress < 0) _swipeProgress = 0; // Prevent negative progress
      if (_swipeProgress > 1) {
        _swipeProgress = 1; // Prevent exceeding max progress
        _navigateToSip();
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_swipeProgress < 1) {
      // Reset swipe progress if not fully swiped
      setState(() {
        _swipeProgress = 0; // Reset to start position
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                errorText: _titleError,
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expense Amount',
                errorText: _amountError,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCommonExpense,
              items: _commonExpenses
                  .map((expense) => DropdownMenuItem<String>(
                value: expense,
                child: Text(expense),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCommonExpense = value;
                  _dropdownError = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Common Expense',
                errorText: _dropdownError,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? 'Date: ${DateFormat.yMMMd().format(_selectedDate!)}'
                        : 'No Date Selected',
                    style: TextStyle(
                      fontSize: 16,
                      color: _dateError != null ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            if (_dateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _dateError!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateInputs,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Save Expense'),
            ),
            TextButton(
              onPressed: _cancelExpense,
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _savedExpenses.length,
                itemBuilder: (context, index) {
                  final expense = _savedExpenses[index];
                  return Dismissible(
                    key: ValueKey(expense),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteExpense(index);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(expense['title']!),
                        subtitle: Text('Amount: ₹${expense['amount']}\nDate: ${expense['date']}\nType: ${expense['commonExpense']}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: _swipeProgress == 1 ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _swipeProgress * (MediaQuery.of(context).size.width - 80), // Position the arrow button
                      child: Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_forward, color: Colors.green),
                        ),
                      ),
                    ),
                    Center(
                      child: const Text(
                        'Spent Too much!!! Start SIP Instant',
                        style: TextStyle(color: Colors.green, fontSize: 16),
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

