import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resident_provider.dart'; // Import your UserProvider
import 'name_selection_page.dart'; // Import the NameSelectionPage

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
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/images/MyUI_logo.png', height: 100),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 300,
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
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String aptNumber = _apartmentNumberController.text;

                            // Use Provider to fetch residents based on apartment number
                            await Provider.of<ResidentProvider>(context,
                                    listen: false)
                                .fetchResidentsByApartment(aptNumber);

                            // Navigate to NameSelectionPage if residents are found
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NameSelectionPage(
                                    apartmentNumber: aptNumber),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
