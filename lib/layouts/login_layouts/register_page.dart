//Material
import 'package:educator/dialogs/show_custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import '../../database/main_database.dart';
import '../../dialogs/show_custom_succesful_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Init text editing controllers

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPasswordConfirmController =
      TextEditingController();

  bool hasSpecialSymbol(String input) {
    final specialRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialRegex.hasMatch(input);
  }

  bool hasUppercase(String input) {
    final uppercaseRegex = RegExp(r'[A-Z]');
    return uppercaseRegex.hasMatch(input);
  }

  final DatabaseService _instance = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Match the same card size and style as your LoginPage
        child: SizedBox(
          width: 300,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Similar icon styling
                  const Icon(
                    Icons.person_add,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  // Page title
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Username field
                  TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  TextField(
                    controller: _userPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confirm password field
                  TextField(
                    controller: _userPasswordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_reset),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_userNameController.text == "") {
                          showCustomAlertDialog(
                              context: context,
                              title: 'Passwords Do Not Match',
                              message:
                                  'Please make sure your passwords are identical and try again.');
                          return;
                        } else if (_userPasswordController.text !=
                            _userPasswordConfirmController.text) {
                          showCustomAlertDialog(
                              context: context,
                              title: 'Username Cannot Be Empty',
                              message:
                                  'Please enter a username before proceeding.');
                          return;
                        } else if (!hasUppercase(
                                _userPasswordController.text) ||
                            !hasSpecialSymbol(_userPasswordController.text) ||
                            _userPasswordController.text.length < 8) {
                          showCustomAlertDialog(
                              context: context,
                              title: 'Invalid Password',
                              message: 'Your password must:\n'
                                  '• Be at least 8 characters long\n'
                                  '• Contain at least one uppercase letter\n'
                                  '• Contain at least one special character');
                        } else if (await _instance.registerUser(
                            _userNameController.text,
                            _userPasswordController.text)) {
                          //Clear data
                          _userNameController.text = "";
                          _userPasswordConfirmController.text = "";
                          _userPasswordController.text = "";
                          if (context.mounted) {
                            showSuccessfulRegistrationDialog(
                                context,
                                "Succesful registration!",
                                "You have been registerd succesfully!");
                          }
                        } else {
                          if (context.mounted) {
                          showCustomAlertDialog(
                              context: context,
                              title:
                                  "A user with this username already exists.",
                              message:
                                  'A user with this username already exists. Please choose another.');
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // "Back to Login" or "Cancel" button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to LoginPage
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
