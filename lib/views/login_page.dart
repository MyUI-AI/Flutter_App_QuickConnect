import 'package:flutter/material.dart';
import 'name_selection_page.dart'; // Import the UserSelectionPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _apartmentNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically focus on the text field when the page loads
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Allow scrolling for smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/images/MyUI_Logo.png',
                    height: 100,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity, // Use full width
                        child: TextFormField(
                          controller: _apartmentNumberController,
                          decoration: InputDecoration(
                            labelText: 'Enter Apartment Number',
                            hintText: 'A123',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text, // Show keyboard suitable for text input
                          textInputAction: TextInputAction.done, // Change keyboard action to "Done"
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
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity, // Use full width
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String aptNumber = _apartmentNumberController.text;

                              // Navigate to UserSelectionPage with the apartment number
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NameSelectionPage(
                                    apartmentNumber: aptNumber,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 50),
                            backgroundColor: Color(0xFFff6357),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Implement "Forgot Password" functionality if needed
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Forgot Password?'),
                                content: Text('Please contact support.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apartmentNumberController.dispose(); // Dispose the controller
    super.dispose();
  }
}
