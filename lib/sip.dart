import 'dart:math';  // Required for the pow method
import 'package:flutter/material.dart';

void main() {
  runApp(InvestmentFormApp());
}

class InvestmentFormApp extends StatelessWidget {
  const InvestmentFormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InvestmentPage(),
    );
  }
}

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final TextEditingController _monthlyInvestmentController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double profit = 0;
  double monthlyInvestmentValue = 0;
  double numberOfYearsValue = 0;
  double percentageProfit = 0;
  double totalAmount = 0;
  double baseInvestment = 0;

  void _submitData() {
    String monthlyInvestment = _monthlyInvestmentController.text;
    String numberOfYears = _yearsController.text;

    if (monthlyInvestment.isNotEmpty && numberOfYears.isNotEmpty) {
      double? monthlyInvestmentParsed = double.tryParse(monthlyInvestment);
      double? numberOfYearsParsed = double.tryParse(numberOfYears);

      if (monthlyInvestmentParsed == null || numberOfYearsParsed == null) {
        _showErrorDialog('Invalid input', 'Please enter valid numbers in both fields.');
        return;
      }

      setState(() {
        monthlyInvestmentValue = monthlyInvestmentParsed;
        numberOfYearsValue = numberOfYearsParsed;

        int months = (numberOfYearsValue * 12).toInt();

        double annualInterestRate = 11 / 100;
        double monthlyInterestRate = annualInterestRate / 12;

        // Calculate future value using SIP formula
        double futureValue = monthlyInvestmentValue *
            ((pow(1 + monthlyInterestRate, months)) - 1) /
            monthlyInterestRate *
            (1 + monthlyInterestRate);

        double totalInvestment = monthlyInvestmentValue * months;
        profit = futureValue - totalInvestment;

        // Calculate total amount (investment + profit)
        totalAmount = totalInvestment + profit;

        // Calculate percentage profit
        percentageProfit = (profit / totalInvestment) * 100;

        // Calculate base investment using the formula: monthlyInvestment * numberOfYears * 12
        baseInvestment = monthlyInvestmentValue * numberOfYearsValue * 12;
      });
    } else {
      _showErrorDialog('Missing Input', 'Please fill in all fields.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIP Investment'),
        backgroundColor: Color(0xFF00C6FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter Monthly Investment (₹):",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _monthlyInvestmentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Enter Number of Years:",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _yearsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter duration",
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 32),

            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.black,
              ),
              child: Text('Submit Data'),
            ),

            // Display Investment Summary Below the Button
            if (monthlyInvestmentValue > 0 && numberOfYearsValue > 0)
              Column(
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Investment Summary:',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Base Investment: ₹${baseInvestment.toStringAsFixed(2)}'),
                  Text('Profit: ₹${profit.toStringAsFixed(2)}'),
                  Text('Total (Investment + Profit): ₹${totalAmount.toStringAsFixed(2)}'),
                  Text(
                    'Profit Percentage: ${percentageProfit.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}