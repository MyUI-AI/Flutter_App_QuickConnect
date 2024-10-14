import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retirement Home Kiosk',
      theme: ThemeData(
        primaryColor: Color(0xFF0044CC), // Dark Blue
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light Gray
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 18), // Dark Gray Text
        ),
      ),
      home: ScreenSaver(),
    );
  }
}

class ScreenSaver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Correct background color
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to login page when clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Company logo (replace with actual logo)
              Image.asset(
                'assets/company_logo.png', // Ensure this path is correct
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Tap to Enter',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _apartmentNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Textbox for apartment number
                TextFormField(
                  controller: _apartmentNumberController,
                  decoration: InputDecoration(
                    labelText: 'Enter Apartment Number',
                    hintText: 'A123', // 1 letter + 3 digits format
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your apartment number';
                    }
                    if (!RegExp(r'^[A-Za-z]\d{3}$').hasMatch(value)) {
                      return 'Invalid format. Example: A123';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Login button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String aptNumber = _apartmentNumberController.text;
                      // For demonstration, show the entered apartment number
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Apartment Number: $aptNumber'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0044CC), // Dark Blue
                    foregroundColor: Colors.white, // White text
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
