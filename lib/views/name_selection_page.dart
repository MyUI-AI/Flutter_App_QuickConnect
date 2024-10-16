import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resident.dart'; // Import your User model
import '../providers/resident_provider.dart'; // Import your UserProvider
import 'dashboard_page.dart'; // Import DashboardPage

class NameSelectionPage extends StatelessWidget {
  final String apartmentNumber;

  NameSelectionPage({required this.apartmentNumber});

  @override
  Widget build(BuildContext context) {
    // Access the list of residents from the UserProvider
    List<ResidentModel> residents =
        Provider.of<ResidentProvider>(context).residents;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Name"),
      ),
      body: residents.isEmpty
          ? Center(
              child: Text("No residents found for apartment $apartmentNumber"))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(resident.profilePic,
                            height: 80, width: 80),
                        SizedBox(height: 10),
                        Text(resident.name, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
