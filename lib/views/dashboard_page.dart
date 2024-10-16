import 'package:flutter/material.dart';
import 'package:quick_connect_application/views/activities_page.dart';
import '../models/resident.dart'; // Import the ResidentModel

class DashboardPage extends StatelessWidget {
  final ResidentModel resident;

  DashboardPage({required this.resident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, ${resident.name}",
          style: TextStyle(fontSize: 28), // Larger font size for accessibility
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: 50), // Logout button
            onPressed: () {
              // Handle logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logging out...')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(14.0), // Add some padding around the tiles
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row with two tiles: Activities and Meals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Activities Tile
                DashboardTile(
                  title: 'Activities',
                  icon: Icons.directions_run,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivitiesPage()));
                    // Navigate to Activities Screen (implement separately)
                  },
                ),
                // Meals Tile
                DashboardTile(
                  title: 'Meals',
                  icon: Icons.restaurant_menu,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Navigating to Meals...')),
                    );
                    // Navigate to Meals Screen (implement separately)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for a Dashboard Tile
class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Color(0xFFff6357), // Background color of the tile
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white), // Icon inside the tile
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24, // Larger font size for accessibility
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
