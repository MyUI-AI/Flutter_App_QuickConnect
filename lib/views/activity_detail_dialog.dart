import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../models/activity.dart';
import '../providers/text_size_provider.dart'; // Import your TextSizeProvider

class ActivityDetailDialog extends StatelessWidget {
  final Activity activity;

  const ActivityDetailDialog({required this.activity});

  @override
  Widget build(BuildContext context) {
    double textSize = Provider.of<TextSizeProvider>(context).minTextSize; // Get minTextSize from the provider

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        activity.name,
        style: TextStyle(fontSize: textSize * 1.5), // Use dynamic text size for title
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.activityImage.isNotEmpty) // Check if the image URL is not empty
            Image.network(
              activity.activityImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFfffafa), // Placeholder color
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.black), // Placeholder icon
            ),
          const SizedBox(height: 10),
          Text(
            'Description: ${activity.description}',
            style: TextStyle(fontSize: textSize), // Use dynamic text size for description
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${activity.date}',
            style: TextStyle(fontSize: textSize), // Use dynamic text size for date
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${activity.time}',
            style: TextStyle(fontSize: textSize), // Use dynamic text size for time
          ),
        ],
      ),
      actions: [
        Center( // Centering the buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Notify the user of the sign-up
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Signed up for ${activity.name} at ${activity.time}!',
                        style: TextStyle(fontSize: textSize), // Use dynamic text size for Snackbar
                      ),
                      duration: const Duration(seconds: 2), // Duration of the Snackbar
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFfe6357), // Sign up button color
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: textSize), // Use dynamic text size for button
                ),
              ),
              const SizedBox(width: 10), // Add spacing between buttons
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: const Color(0xFFfe6357), fontSize: textSize), // Use dynamic text size for cancel text
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
