//Material
import 'package:flutter/material.dart';

//Database
import '../database/main_database.dart';

//Layouts
import 'register_page.dart';
import 'main_page.dart';

//States
import '../state/main_state.dart';
import '../state/subject_list_state.dart';

//External packges
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Database
  final DatabaseService _instance = DatabaseService.instance;

  //TextEditingControlers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  bool rememberUser = false;
  @override
  Widget build(BuildContext context) {
    //States
    final mainState = Provider.of<MainState>(context);
    final subjectState = Provider.of<SubjectListState>(context, listen: false);


    void logIn() async {
      //User data
      int userId = (await _instance.logInUser(
          _userNameController.text, _userPasswordController.text));
      String userName = _userNameController.text;

      if (userId != -1) {
        //Update state with user data

        //Main State
        mainState.userId = userId;
        mainState.userName = userName;

        //Subject State
        subjectState.userId = userId;

        //Remeber user
        mainState.rememberUser = rememberUser;

        //Clear Data on the controllers
        _userNameController.text = "";
        _userPasswordController.text = "";

        //Transition
        const duration = Duration(milliseconds: 500);
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: duration,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MainPage();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        //Else inform user that log in failed
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }

    return Scaffold(
      body: Center(
        // SizedBox gives the card a fixed size
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
                // Make the column scroll if content overflows (optional)
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Educator',
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
                  const SizedBox(height: 24),
                  // The "Remember me" checkbox
                  CheckboxListTile(
                    title: const Text("Remember me"),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: rememberUser,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberUser = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: logIn,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Register button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                    },
                    child: const Text('Register'),
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
