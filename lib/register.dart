//register
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 10.0),
            _buildTextField(_emailController, 'Email', inputType:TextInputType.emailAddress),
            const SizedBox(height: 10.0),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator() // Show a loading indicator while registering
                : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                      });

                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                if (_validateInputs(username, email, password)) {
                  await _auth.register(email, password, username);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(buttonLabel: '', qrCodeData: '', userId: '',)),
                  );
                }
              },
                  child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: inputType,
      obscureText: obscureText,
    );
  }

  bool _validateInputs(String username, String email, String password) {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    // You can add more specific validations here if needed
    return true;
  }

  void _showRegistrationFailedToast() {
    Fluttertoast.showToast(
      msg: 'Registration failed. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}