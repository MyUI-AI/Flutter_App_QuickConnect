import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

import 'firebase_options.dart'; // Import the generated firebase_options.dart file
import 'repositories/resident_repository.dart'; // Import the ResidentRepository
import 'providers/resident_provider.dart'; // Import the ResidentProvider
import 'providers/text_size_provider.dart'; // Import the TextSizeProvider
import 'views/screen_saver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle initialization error
    print("Firebase initialization error: $e");
    return;
  }

  final firestore = FirebaseFirestore.instance;
  final residentRepository = ResidentRepository(firestore: firestore); // Create the repository

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ResidentProvider(residentRepository: residentRepository), // Pass the repository
        ),
        ChangeNotifierProvider(
          create: (context) => TextSizeProvider(16.0), // Initialize TextSizeProvider with a default size
        ),
        // Add any other providers here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retirement Home Kiosk',
      theme: ThemeData(
        primaryColor: Color(0xFFff6357), // Primary color for the button
      ),
      home: ScreenSaver(), // Start with the ScreenSaver
    );
  }
}



//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Retirement Home Kiosk',
//      theme: ThemeData(
//        primaryColor: Color(0xFFff6357),
//      ),
      // Directly load the DashboardPage with a hardcoded resident
//      home: DashboardPage(
//        resident: ResidentModel(
//          name: 'Shravani Konda',
//          phoneNumber: '123-456-7890',
//          apartmentNumber: 'A123',
          // Replace with a real image URL
//        ),
//      ),
//    );
//  }
//}


// class ScreenSaver extends StatefulWidget {
//   @override
//   _ScreenSaverState createState() => _ScreenSaverState();
// }

// class _ScreenSaverState extends State<ScreenSaver>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true); // Loop the animation
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: GestureDetector(
//         onTap: () {
//           // Navigate to login page when clicked
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         },
//         child: Center(
//           child: ScaleTransition(
//             scale: Tween<double>(begin: 1.0, end: 1.2).animate(
//               CurvedAnimation(
//                 parent: _controller,
//                 curve: Curves.easeInOut,
//               ),
//             ),
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 180), // Increase this value to move the logo higher
//               child: Image.asset(
//                 'assets/images/MyUI_logo.png',
//                 height: 100, // Adjust height as needed
//               ),
//             ),

//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _apartmentNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Background color of the entire screen
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo at the top center
//               Container(
//                 margin: const EdgeInsets.only(bottom: 20), // Space between logo and text field
//                 child: Image.asset(
//                   'assets/images/MyUI_logo.png',
//                   height: 100, // Adjust height as needed
//                 ),
//               ),
//               // Form for apartment number
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Textbox for apartment number
//                     Container(
//                       width: 300, // Set width to fit the text
//                       child: TextFormField(
//                         controller: _apartmentNumberController,
//                         decoration: InputDecoration(
//                           labelText: 'Enter Apartment Number',
//                           hintText: 'A123', // Placeholder for the input
//                           border: OutlineInputBorder(),
//                           labelStyle: TextStyle(color: Colors.black), // Label text color
//                           hintStyle: TextStyle(color: Colors.grey), // Hint text color
//                           filled: true,
//                           fillColor: Colors.white, // Background color for text box
//                         ),
//                         style: TextStyle(color: Colors.black), // Input text color
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your apartment number';
//                           }
//                           if (!RegExp(r'^[A-Za-z]\d{3}$').hasMatch(value)) {
//                             return 'Invalid format. Example: A123';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     // Submit button
//                     Container(
//                       width: 300, // Set width to fit the text
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             String aptNumber = _apartmentNumberController.text;
//                             // Handle authentication logic here
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Attempting to log in with $aptNumber'),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(0, 50), // Minimum size for the button height
//                           backgroundColor: Color(0xFFff6357), // Button color
//                           textStyle: TextStyle(fontSize: 18), // Text style
//                         ),
//                         child: Text(
//                           'Submit',
//                           style: TextStyle(color: Colors.white), // Submit button text color
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
