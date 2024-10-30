import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resident_provider.dart';
import '../providers/text_size_provider.dart'; // Import your TextSizeProvider
import 'name_selection_page.dart'; // Import the NameSelectionPage
import 'dashboard_page.dart'; // Import the DashboardPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _apartmentNumberController = TextEditingController();
  String? _errorMessage;

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
          child: SingleChildScrollView(
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
                        constraints: BoxConstraints(maxWidth: 300), // Limit the width of the text field
                        child: TextFormField(
                          controller: _apartmentNumberController,
                          decoration: InputDecoration(
                            labelText: 'Enter Apartment Number',
                            hintText: 'A123',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.text,
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
                        constraints: BoxConstraints(maxWidth: 300), // Limit the width of the button
                        child: ElevatedButton(
                          onPressed: _login, // Call the _login method
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 50), // Set a minimum size for the button
                            backgroundColor: Color(0xFFff6357),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String aptNumber = _apartmentNumberController.text;

      // Fetch the resident based on apartment number
      await Provider.of<ResidentProvider>(context, listen: false)
          .fetchResidentsByApartment(aptNumber);

      // Access the resident provider state
      ResidentProvider residentProvider = Provider.of<ResidentProvider>(context, listen: false);

      if (residentProvider.errorMessage != null) {
        setState(() {
          _errorMessage = residentProvider.errorMessage;
        });
      } else {
        // Fetch textSize from Firebase
        double fetchedTextSize = await fetchTextSizeFromFirebase();

        // Update provider with the fetched text size
        Provider.of<TextSizeProvider>(context, listen: false).updateTextSize(fetchedTextSize);

        // Handle different cases
        if (residentProvider.resident != null) {
          // Only one resident, navigate directly to DashboardPage with the resident data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(resident: residentProvider.resident!), // Pass the resident
            ),
          );
        } else {
          // Multiple residents, navigate to NameSelectionPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NameSelectionPage(apartmentNumber: aptNumber), // Pass the apartment number
            ),
          );
        }
      }
    }
  }

  Future<double> fetchTextSizeFromFirebase() async {
    // Implement your logic to fetch text size from Firebase
    try {
      final document = await FirebaseFirestore.instance.collection('settings').doc('textSize').get();
      return document.data()?['size'] ?? 16.0; // Default size if not found
    } catch (e) {
      print("Error fetching text size: $e");
      return 16.0; // Return a default value in case of error
    }
  }

  @override
  void dispose() {
    _apartmentNumberController.dispose(); // Dispose the controller
    super.dispose();
  }
}
