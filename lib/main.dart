import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
    });
  }

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', loginController.text);
    await prefs.setString('password', passwordController.text);
  }

  void _handleLogin() {
    if (passwordController.text == 'QWERTY123') {
      _saveCredentials();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(username: loginController.text),
        ),
      );
    } else {
      setState(() {
        imageSource = 'images/stop-sign.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
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

class ProfilePage extends StatefulWidget {
  final String username;
  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      emailController.text = prefs.getString('email') ?? '';
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('email', emailController.text);
  }

  void _launchPhone() async {
    final Uri url = Uri.parse('tel:${phoneController.text}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchSMS() async {
    final Uri url = Uri.parse('sms:${phoneController.text}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchEmail() async {
    final Uri url = Uri.parse('mailto:${emailController.text}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome Back, ${widget.username}!', style: TextStyle(fontSize: 20)),
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone Number')),
                ),
                IconButton(icon: Icon(Icons.call), onPressed: _launchPhone),
                IconButton(icon: Icon(Icons.message), onPressed: _launchSMS),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email Address')),
                ),
                IconButton(icon: Icon(Icons.email), onPressed: _launchEmail),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}
