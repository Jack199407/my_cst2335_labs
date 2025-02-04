import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Storage Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String imageSource = 'images/question-mark.jpg';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from SharedPreferences
  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        _showSnackbar();
      }
    });
  }

  // Show a Snackbar with an Undo button
  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved login info loaded'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              loginController.clear();
              passwordController.clear();
            });
          },
        ),
      ),
    );
  }

  // Save username and password in SharedPreferences
  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', loginController.text);
    await prefs.setString('password', passwordController.text);
  }

  // Clear saved credentials from SharedPreferences
  void _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  // Show an AlertDialog asking the user if they want to save login info
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Login Info'),
        content: Text('Do you want to save your username and password for next time?'),
        actions: [
          TextButton(
            onPressed: () {
              _clearCredentials();
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _saveCredentials();
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  // Handle the login button click
  void _handleLogin() {
    String password = passwordController.text;

    setState(() {
      if (password == 'QWERTY123') {
        imageSource = 'images/light-bulb.jpg';
      } else {
        imageSource = 'images/stop-sign.jpg';
      }
    });

    print('Password: $password');

    // Show AlertDialog asking to save login info
    _showSaveDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Login input field
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Password input field
            TextField(
              controller: passwordController,
              obscureText: true, // Hide password content
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Login button
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            // Dynamic image based on password
            Image.asset(
              imageSource,
              height: 300,
              width: 300,
            ),
          ],
        ),
      ),
    );
  }
}
