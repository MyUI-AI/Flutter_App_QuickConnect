import 'package:flutter/material.dart';
import '../models/resident.dart'; // Import the UserModel

class DashboardPage extends StatelessWidget {
  final ResidentModel resident;

  DashboardPage({required this.resident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${resident.name}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(resident.profilePic, height: 100, width: 100),
            SizedBox(height: 20),
            Text("Name: ${resident.name}"),
            Text("Phone: ${resident.phoneNumber}"),
            Text("Apartment: ${resident.apartmentNumber}"),
          ],
        ),
      ),
    );
  }
}
