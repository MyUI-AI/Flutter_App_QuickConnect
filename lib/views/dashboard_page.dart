import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/text_size_provider.dart';
import '../providers/resident_provider.dart'; // Import the ResidentProvider
import 'activities_page.dart';
import 'login_page.dart';
import '../models/resident.dart';

class DashboardPage extends StatelessWidget {
  final ResidentModel resident;

  DashboardPage({required this.resident});

  @override
  Widget build(BuildContext context) {
    // Access the TextSizeProvider to get the minimum text size
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    double minTextSize = textSizeProvider.minTextSize;

    // Use post-frame callback to update text size if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (minTextSize != resident.textSize) {
        textSizeProvider.updateTextSize(resident.textSize);
      }
    });

    // Update the logout function
    void _logout() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final residentProvider = Provider.of<ResidentProvider>(context, listen: false);
                  residentProvider.clearResident(); // Clear resident data on logout

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
                child: Text('Logout'),
              ),
            ],
          );
        },
      );
    }

    // Define the tile titles
    final List<String> tileTitles = ['Activities', 'Meals'];
    // Calculate the longest title length
    final String longestTitle = tileTitles.reduce((a, b) => a.length > b.length ? a : b);
    double tileSize = (longestTitle.length * minTextSize * 0.6) + (minTextSize * 3); // Dynamic tile size

    return WillPopScope(
      onWillPop: () async {
        _logout(); // Call logout on back button press
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Flexible(
            child: Text(
              "Welcome, ${resident.name}",
              style: TextStyle(fontSize: textSizeProvider.getRelativeTextSize(1.2)),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Prevent text overflow
            ),
          ),
          backgroundColor: const Color(0xFFfe6357),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.logout, size: textSizeProvider.minTextSize),
              onPressed: _logout,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.all(textSizeProvider.getRelativeTextSize(0.875)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashboardTile(
                      title: 'Activities',
                      icon: Icons.directions_run,
                      textSize: minTextSize,
                      tileSize: tileSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ActivitiesPage()),
                        );
                      },
                    ),
                    DashboardTile(
                      title: 'Meals',
                      icon: Icons.restaurant_menu,
                      textSize: minTextSize,
                      tileSize: tileSize,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigating to Meals...')),
                        );
                      },
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

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final double textSize;
  final double tileSize;
  final VoidCallback onTap;

  DashboardTile({
    required this.title,
    required this.icon,
    required this.textSize,
    required this.tileSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileSize,
        height: tileSize, // Set height equal to width for square shape
        decoration: BoxDecoration(
          color: Color(0xFFfe6357),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: textSize * 1.5, color: Colors.white),
            SizedBox(height: textSize * 0.5),
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
