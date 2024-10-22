import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/text_size_provider.dart';
import 'activities_page.dart';
import '../models/resident.dart';

class DashboardPage extends StatelessWidget {
  final ResidentModel resident;

  DashboardPage({required this.resident});

  @override
  Widget build(BuildContext context) {
    // Use the resident's text size for the TextSizeProvider
    Provider.of<TextSizeProvider>(context, listen: false).updateTextSize(resident.textSize);

    // Access the TextSizeProvider to get the minimum text size
    double minTextSize = Provider.of<TextSizeProvider>(context).minTextSize;

    // Show SnackBar with minimum text size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Minimum Text Size: ${minTextSize.toString()}"),
          duration: Duration(seconds: 2),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, ${resident.name}",
          style: TextStyle(fontSize: Provider.of<TextSizeProvider>(context).getRelativeTextSize(1.75)),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, size: Provider.of<TextSizeProvider>(context).getRelativeTextSize(2)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logging out...')),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get the available screen width
          double screenWidth = constraints.maxWidth;

          // Dynamically calculate tile size based on screen width
          double tileSize = screenWidth * 0.35;  // Adjust this ratio as needed
          double textSize = Provider.of<TextSizeProvider>(context).minTextSize;
          double iconSize = textSize * 1.5;

          return Padding(
            padding: EdgeInsets.all(Provider.of<TextSizeProvider>(context).getRelativeTextSize(0.875)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashboardTile(
                      title: 'Activities',
                      icon: Icons.directions_run,
                      tileSize: tileSize,
                      textSize: textSize,
                      iconSize: iconSize,
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
                      tileSize: tileSize,
                      textSize: textSize,
                      iconSize: iconSize,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigating to Meals...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom widget for a Dashboard Tile
class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final double tileSize;  // Accept dynamic tile size
  final double textSize;  // Accept dynamic text size
  final double iconSize;  // Accept dynamic icon size
  final VoidCallback onTap;

  DashboardTile({
    required this.title,
    required this.icon,
    required this.tileSize,
    required this.textSize,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileSize,  // Set dynamic tile size
        height: tileSize,
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
            Icon(icon, size: iconSize, color: Colors.white),  // Adjust icon size dynamically
            SizedBox(height: tileSize * 0.1),  // Adjust spacing dynamically
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,  // Adjust text size dynamically
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
