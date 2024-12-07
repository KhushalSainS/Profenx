import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

// Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignedUp = prefs.getBool('isSignedUp') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isSignedUp ? const SignInPage() : const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF00C6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your logo image here
              Image.asset(
                'android/assets/images/logo.png', // Update with your logo path
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

// Sign In Page
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFF00C6FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Logo at the top
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        'android/assets/images/logo.png', // Update with your logo path
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(labelText: "Email", icon: Icons.email),
                    const SizedBox(height: 10),
                    _buildTextField(labelText: "Password", icon: Icons.lock, obscureText: true),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildElevatedButton(
                      label: "Sign In",
                      onPressed: () {
                        // Sign-in logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Sign Up Page
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Create Account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(labelText: "Name", icon: Icons.person),
            const SizedBox(height: 10),
            _buildTextField(labelText: "Email", icon: Icons.email),
            const SizedBox(height: 10),
            _buildTextField(labelText: "OTP", icon: Icons.numbers),
            const SizedBox(height: 10),
            _buildTextField(labelText: "Password", icon: Icons.lock, obscureText: true),
            const SizedBox(height: 20),
            _buildElevatedButton(
              label: "Sign Up",
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isSignedUp', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Forgot Password Page
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(labelText: "Email", icon: Icons.email),
            const SizedBox(height: 10),
            _buildTextField(labelText: "OTP", icon: Icons.numbers),
            const SizedBox(height: 10),
            _buildTextField(labelText: "New Password", icon: Icons.lock, obscureText: true),
            const SizedBox(height: 10),
            _buildTextField(labelText: "Confirm Password", icon: Icons.lock, obscureText: true),
            const SizedBox(height: 20),
            _buildElevatedButton(
              label: "Reset Password",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Home Page with Expense Tracking
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController monthlyExpenseController = TextEditingController();
  TextEditingController dailyExpenseController = TextEditingController();
  String monthlyExpense = '';
  String dailyExpense = '';
  bool showInputs = false;
  bool showNextButton = false;

  Map<String, bool> selectedCategories = {
    'Food': false,
    'Travel': false,
    'Cinema': false,
    'Leisure': false,
    'Shopping': false,
    'Groceries': false,
    'Health': false,
    'Entertainment': false,
    'Education': false,
    'Utilities': false,
    'Rent': false,
    'Savings': false,
    'Gifts': false,
    'Charity': false,
    'Miscellaneous': false,
  };

  void showNumberInputError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Input'),
        content: Text('Only numbers are accepted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void saveExpenses() {
    setState(() {
      monthlyExpense = monthlyExpenseController.text;
      dailyExpense = dailyExpenseController.text;
      showInputs = true;
      showNextButton = true;
    });
  }

  void nextStep() {
    print('Monthly Expense: $monthlyExpense');
    print('Daily Expense: $dailyExpense');
    print('Selected Categories: ${selectedCategories.entries.where((entry) => entry.value).map((e) => e.key).toList()}');
    // You can navigate to another screen or perform actions here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profenx', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Monthly and Daily Expenses
            if (showInputs) ...[
              Text('Your Expense Details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Monthly Expense: ₹$monthlyExpense', style: TextStyle(fontSize: 18)),
              Text('Daily Expense: ₹$dailyExpense', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
            ],

            // Categories Section
            Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: selectedCategories.keys.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategories[category] = !selectedCategories[category]!;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: selectedCategories[category]! ? Colors.yellow : Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (selectedCategories[category]!)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text('X', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30),

            // Monthly Expense Input
            Text('Estimated Monthly Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: monthlyExpenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter Monthly Expense Amount',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && int.tryParse(value) == null) {
                  showNumberInputError();
                  monthlyExpenseController.clear();
                }
              },
            ),
            SizedBox(height: 20),

            // Daily Expense Input
            Text('Estimated Daily Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: dailyExpenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter Daily Expense Amount',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && int.tryParse(value) == null) {
                  showNumberInputError();
                  dailyExpenseController.clear();
                }
              },
            ),

            SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: saveExpenses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ),

            // Next Button
            if (showNextButton)
              Center(
                child: ElevatedButton(
                  onPressed: nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text('Next', style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
Widget _buildTextField({
  required String labelText,
  IconData? icon,
  bool obscureText = false,
}) {
  return TextField(
    obscureText: obscureText,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
    ),
  );
}

Widget _buildElevatedButton({
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
  );
}