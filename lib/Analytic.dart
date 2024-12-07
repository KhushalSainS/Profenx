import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense_form.dart'; // Import the second file

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

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'android/assets/images/logo.png', // Replace with your logo's path
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Analytics',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                        MaterialPageRoute(builder: (context) => ExpenseFormPage()),
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
              RotatingCharts(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SmallYearDropdown(),
                ],
              ),
              const SizedBox(height: 20),
              const MonthButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

// Rotating Charts Widget
class RotatingCharts extends StatefulWidget {
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


// Dropdown for Year Selection
class SmallYearDropdown extends StatefulWidget {
  const SmallYearDropdown({Key? key}) : super(key: key);

  @override
  _SmallYearDropdownState createState() => _SmallYearDropdownState();
}

class _SmallYearDropdownState extends State<SmallYearDropdown> {
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedYear,
      hint: const Text('Year', style: TextStyle(color: Colors.black)),
      items: const ['2023', '2024', '2025', '2026', '2027']
          .map((year) => DropdownMenuItem(value: year, child: Text(year)))
          .toList(),
      onChanged: (value) => setState(() => selectedYear = value),
    );
  }
}

// Month Buttons with "View Analytics" Button
class MonthButtons extends StatelessWidget {
  const MonthButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: months.map((month) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('View Analytics for $month')),
                    );
                  },
                  child: const Text(
                    'View Analytics',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
