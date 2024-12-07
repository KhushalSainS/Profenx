import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class ExpenseFormPage extends StatefulWidget {
  @override
  _ExpenseFormPageState createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  String? _titleError;
  String? _amountError;
  String? _dateError;

  List<Map<String, String>> _savedExpenses = [];

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
    });

    if (_titleError == null && _amountError == null && _dateError == null) {
      _saveExpense();
    }
  }

  void _saveExpense() {
    String title = _titleController.text.trim();
    String amount = _amountController.text.trim();
    String date = DateFormat.yMMMd().format(_selectedDate!);

    setState(() {
      _savedExpenses.add({
        'title': title,
        'amount': amount,
        'date': date,
      });
    });

    _showSnackbar('Expense Saved:\nTitle: $title, Amount: ₹$amount, Date: $date');
    _clearForm();
  }

  void _clearForm() {
    _titleController.clear();
    _amountController.clear();
    _selectedDate = null;
    _titleError = null;
    _amountError = null;
    _dateError = null;
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteExpense(index);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(expense['title']!),
                        subtitle: Text('Amount: ₹${expense['amount']}'),
                        trailing: Text(expense['date']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
