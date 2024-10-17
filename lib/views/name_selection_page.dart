import 'package:flutter/material.dart';
import '../models/resident.dart';
import 'dashboard_page.dart'; // Import DashboardPage

class NameSelectionPage extends StatelessWidget {
  final String apartmentNumber;

  // Constructor accepts apartmentNumber
  NameSelectionPage({required this.apartmentNumber});

  @override
  Widget build(BuildContext context) {
    // Assuming you have a list of residents to display
    List<ResidentModel> residents = [
      ResidentModel(
        name: "John Doe",
        profilePic: "https://www.example.com/profile_pic1.jpg",
        apartmentNumber: 'A100',
        phoneNumber: "7685457682",
      ),
      ResidentModel(
        name: "Jane Smith",
        profilePic: "https://www.example.com/profile_pic2.jpg",
        apartmentNumber: 'A100',
        phoneNumber: "99065457682",
      ),
      // Add more residents here if necessary
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Your Name",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // AppBar text color
          ),
        ),
        backgroundColor: Color(0xFFff6357), // Custom color for AppBar
        elevation: 0,
      ),
      body: residents.isEmpty
          ? Center(
        child: Text(
          "No residents found for apartment $apartmentNumber",
          style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the GridView
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.75, // Adjusted for better appearance
          ),
          itemCount: residents.length,
          itemBuilder: (context, index) {
            var resident = residents[index];
            return GestureDetector(
              onTap: () {
                // Navigate to DashboardPage when resident is selected
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(resident: resident),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                elevation: 5, // Add elevation for shadow effect
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50), // Rounded profile image
                      child: Image.network(
                        resident.profilePic ?? '',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.grey[400], // Default icon color
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      resident.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFff6357), // Name color
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Apartment: ${resident.apartmentNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
