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
