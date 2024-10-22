import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_connect_application/views/dashboard_page.dart';
import '../providers/resident_provider.dart';
import '../models/resident.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_connect_application/views/dashboard_page.dart';
import '../providers/resident_provider.dart';
import '../models/resident.dart';

class NameSelectionPage extends StatelessWidget {
  final String apartmentNumber;

  NameSelectionPage({required this.apartmentNumber});

  @override
  Widget build(BuildContext context) {
    ResidentProvider residentProvider = Provider.of<ResidentProvider>(context);

    // Fetch residents based on apartment number when the page is built
    residentProvider.fetchResidentsByApartment(apartmentNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Resident'), foregroundColor: Colors.white,
        backgroundColor: Color(0xFFff6357), // Set AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the ListView
        child: residentProvider.residentList.isEmpty // Check for residents
            ? Center(
          child: Text(
            'No residents found.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        )
            : ListView.builder(
          itemCount: residentProvider.residentList.length, // List of residents
          itemBuilder: (context, index) {
            ResidentModel resident = residentProvider.residentList[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
              elevation: 4, // Shadow effect
              child: ListTile(
                title: Text(
                  resident.name,
                  style: TextStyle(fontWeight: FontWeight.bold), // Bold text
                ),
                subtitle: Text('Apartment: ${resident.apartmentNumber}'), // Add additional info
                trailing: Icon(Icons.arrow_forward, color: Color(0xFFff6357)), // Arrow icon
                onTap: () {
                  // Set the selected resident in the provider
                  residentProvider.setResident(resident);

                  // Navigate to home page or wherever after selection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(resident: resident),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
