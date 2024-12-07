import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API requests
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'expense_form.dart'; // Assuming you have a separate file for the ExpenseForm widget
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(const AnalyticsPageApp());

class AnalyticsPageApp extends StatelessWidget {
  const AnalyticsPageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnalyticsPage(),
    );
  }
}

// Rotating Charts Widget
class RotatingCharts extends StatefulWidget {
  const RotatingCharts({Key? key}) : super(key: key);

  @override
  _RotatingChartsState createState() => _RotatingChartsState();
}

class _RotatingChartsState extends State<RotatingCharts> {
  int _currentIndex = 0;

  final List<Widget> _charts = [
    const LineChartSample(),
    const PieChartSample(),
    const BarChartSample(),
  ];

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  void _startRotation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _charts.length;
        });
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _charts[_currentIndex],
      ),
    );
  }
}

// Line Chart
class LineChartSample extends StatelessWidget {
  const LineChartSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.purpleAccent,
            spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 2),
              const FlSpot(2, 1.5),
              const FlSpot(3, 2.8),
              const FlSpot(4, 2.2),
              const FlSpot(5, 3),
            ],
          ),
        ],
      ),
    );
  }
}

// Pie Chart
class PieChartSample extends StatelessWidget {
  const PieChartSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Colors.blue, title: '40%'),
          PieChartSectionData(value: 30, color: Colors.red, title: '30%'),
          PieChartSectionData(value: 20, color: Colors.yellow, title: '20%'),
          PieChartSectionData(value: 10, color: Colors.green, title: '10%'),
        ],
      ),
    );
  }
}

// Bar Chart
class BarChartSample extends StatelessWidget {
  const BarChartSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.blue)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 7, color: Colors.red)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3, color: Colors.green)]),
        ],
      ),
    );
  }
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, List<Map<String, dynamic>>> expensesByMonth = {};
  String? expandedMonth;
  String? selectedYear;
  String? username;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  /// Fetch expenses from the API and segregate them by month
  Future<void> _fetchExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');

    const String apiUrl = 'https://profenx-backend.onrender.com/api/users/expenses';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'username': username ?? ''}, // Pass username in headers
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body); // Decode as a Map
        final List<dynamic> data = jsonData['expenses']; // Access the 'expenses' list

        setState(() {
          expensesByMonth = {
            for (var month in months)
              month: data
                  .where((expense) {
                final expenseDate = DateTime.parse(expense['Date']); // Use 'Date' key
                return expenseDate.month == months.indexOf(month) + 1 &&
                    expenseDate.year.toString() == selectedYear;
              })
                  .map((expense) => Map<String, dynamic>.from(expense))
                  .toList(),
          };
        });
      } else {
        print('Failed to load expenses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF00C6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expense Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ExpenseFormPage()),
                      );
                    },
                    child: const Text(
                      "Add Expense",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SmallYearDropdown(),
              RotatingCharts(),
              const SizedBox(height: 20),
              ...months.map((month) {
                final isExpanded = expandedMonth == month;
                final expenses = expensesByMonth[month] ?? [];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      expandedMonth = isExpanded ? null : month;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              month,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Column(
                          children: expenses.isNotEmpty
                              ? expenses.map((expense) {
                            return ListTile(
                              title: Text(expense['title']),
                              subtitle: Text(
                                  'Amount: \$${expense['amount']} - ${expense['date']}'),
                            );
                          }).toList()
                              : [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No expenses for this month.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallYearDropdown extends StatefulWidget {
  const SmallYearDropdown({Key? key}) : super(key: key);

  @override
  _SmallYearDropdownState createState() => _SmallYearDropdownState();
}

class _SmallYearDropdownState extends State<SmallYearDropdown> {
  String? selectedYear; // Variable to hold the selected year

  @override
  void initState() {
    super.initState();
    // Set the default value to the current year
    selectedYear = DateFormat('yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String?>(
        hint: const Text('Select Year'),
        value: selectedYear, // Set the currently selected year
        items: ['2021', '2022', '2023', '2024', selectedYear!]
            .toSet()
            .map((String year) {
          return DropdownMenuItem<String?>(
            value: year,
            child: Text(year),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedYear = value; // Update the selected year when changed
            // You can also call a function here to fetch expenses based on the new year
          });
        },
      ),
    );
  }
}