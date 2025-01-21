import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Image Demo',
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
            // login name input box
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // password input box
            TextField(
              controller: passwordController,
              obscureText: true, // hide content
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // login button
            ElevatedButton(
              onPressed: () {
                String password = passwordController.text;

                setState(() {
                  if (password == 'QWERTY123') {
                    // change picture to bulb
                    imageSource = 'images/light-bulb.jpg';
                  } else {
                    // change picture to stop sign
                    imageSource = 'images/stop-sign.jpg';
                  }
                });

                print('Password: $password');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            // dynamic picture
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
