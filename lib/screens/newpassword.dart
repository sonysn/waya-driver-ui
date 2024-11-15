import 'package:flutter/material.dart';
import 'package:qunot_driver/api/auth.dart';
import 'package:qunot_driver/colorscheme.dart';

import 'package:qunot_driver/screens/loginpage.dart';

class NewPasswordPage extends StatefulWidget {
  final String code;
  final String emailorPhone;
  const NewPasswordPage(
      {Key? key, required this.code, required this.emailorPhone})
      : super(key: key);

  @override
  State<NewPasswordPage> createState() => NewPasswordPageState();
}

class NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _nav() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetPassword() async {
    // Implement the logic to reset the password
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Check if the passwords match and perform the password reset action
    if (newPassword == confirmPassword) {
      // Perform the password reset action
      final response = await resetPasswordFromForgotPassword(
          emailOrphoneNumber: widget.emailorPhone,
          userToken: widget.code,
          newPassword: newPassword);
      switch (response.statusCode) {
        case 200:
          _showSnackBar('Password Reset Successful');
          _nav();
          break;
        case 401:
          _showSnackBar('Invalid Token');
          break;
        case 404:
          _showSnackBar('User Not Found');
          break;
        case 500:
          _showSnackBar('Something went wrong');
          break;
        default:
          _showSnackBar('Something went wrong');
      }
      print('Password Reset Successful');
    } else {
      // Passwords do not match, show an error message
      print('Passwords do not match');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        backgroundColor:
            customPurple, // Set the app bar background color to custom purple
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Set New Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customPurple,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          customPurple, // Set the border color to custom purple when focused
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          customPurple, // Set the border color to custom purple when focused
                      width: 2,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the forgot password page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Set New Password',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
