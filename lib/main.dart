import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        builder: (context) => isSignedUp ? SignInPage() : SignUpPage(),
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
  SignInPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    _buildTextField(labelText: "Email", icon: Icons.email, controller: _emailController),
                    const SizedBox(height: 10),
                    _buildTextField(labelText: "Password", icon: Icons.lock, obscureText: true, controller: _passwordController),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
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
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        _signIn(context, email, password);
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
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

  Future<void> _signIn(BuildContext context, String email, String password) async {
    final url = Uri.parse('https://profenx-backend.onrender.com/api/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', email);
      await prefs.setString('backend_url', 'https://profenx-backend.onrender.com/api');
      print("sign-up passed");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign-in Failed'),
          content: Text('Invalid username or password. Please try again.'),
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
  }
}

// Sign Up Page
class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      "Sign Up",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(labelText: "Email", icon: Icons.email, controller: _emailController),
                    const SizedBox(height: 10),
                    _buildTextField(labelText: "Password", icon: Icons.lock, obscureText: true, controller: _passwordController),
                    const SizedBox(height: 20),
                    _buildElevatedButton(
                      label: "Sign Up",
                      onPressed: () {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        _signUp(context, email, password);
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Sign In",
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

  Future<void> _signUp(BuildContext context, String email, String password) async {
    final url = Uri.parse('https://profenx-backend.onrender.com/api/users/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedUp', true);
      await prefs.setString('username', email);
      await prefs.setString('backend_url', 'https://profenx-backend.onrender.com/api');
      print("sign-up passed");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign-up Failed'),
          content: Text('Failed to create account. Please try again.'),
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
  }
}

// Forgot Password Page
class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
            _buildTextField(labelText: "Email", icon: Icons.email, controller: _emailController),
            const SizedBox(height: 10),
            _buildTextField(labelText: "OTP", icon: Icons.numbers, controller: _otpController),
            const SizedBox(height: 10),
            _buildTextField(labelText: "New Password", icon: Icons.lock, obscureText: true, controller: _newPasswordController),
            const SizedBox(height: 10),
            _buildTextField(labelText: "Confirm Password", icon: Icons.lock, obscureText: true, controller: _confirmPasswordController),
            const SizedBox(height: 20),
            _buildElevatedButton(
              label: "Reset Password",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
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
  bool isNextButton = false;  // To toggle Save/Next button

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

  void saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('monthlyExpense', monthlyExpenseController.text);
    await prefs.setString('dailyExpense', dailyExpenseController.text);

    setState(() {
      monthlyExpense = monthlyExpenseController.text;
      dailyExpense = dailyExpenseController.text;
      showInputs = true;
      isNextButton = true;  // Change the button to Next after saving
    });
  }

  Future<void> nextStep() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('username') ?? '';
    final monthlyExpense = prefs.getString('monthlyExpense') ?? '';
    final dailyExpense = prefs.getString('dailyExpense') ?? '';

    final url = Uri.parse('https://profenx-backend.onrender.com/api/users/addExpected');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': email,
        'dailyExpense':dailyExpense,
        'monthlyExpense':monthlyExpense
      }),
    );

    if (response.statusCode == 200) {
      print('Expected added successfully');
      // Perform any navigation or action here
    } else {
      // Handle error
      print(response);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Failed to add expected'),
          content: Text('Please try again.'),
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
            if (showInputs) ...[
              Text('Your Expense Details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Monthly Expense: ₹$monthlyExpense', style: TextStyle(fontSize: 18)),
              Text('Daily Expense: ₹$dailyExpense', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
            ],

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

            // Save/Next Button
            Center(
              child: ElevatedButton(
                onPressed: isNextButton ? nextStep : saveExpenses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isNextButton ? 'Next' : 'Save', style: TextStyle(fontSize: 18)),
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
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
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