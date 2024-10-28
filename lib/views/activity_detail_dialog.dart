import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityDetailDialog extends StatelessWidget {
  final Activity activity;
  final double minTextSize;

  const ActivityDetailDialog({
    Key? key,
    required this.activity,
    required this.minTextSize,
  }) : super(key: key);

  void _signUp(BuildContext context) {
    // Check if there is capacity to sign up
    if (activity.count != null && activity.count! >= activity.capacity) {
      // Show a message if no seats are left
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No seats left for ${activity.name}.'),
          duration: const Duration(seconds: 2),
        ),
      );
      return; // Exit the function if no capacity
    }

    // Increment count and close the dialog
    activity.incrementCount();
    print('Signed up for ${activity.name}. New count: ${activity.count}');
    Navigator.of(context).pop(); // Close dialog after signing up
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center( // Center the title
        child: Text(
          activity.name,
          style: TextStyle(fontSize: minTextSize * 1.5),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Centering the image with a size based on textSize
            Center(
              child: Container(
                width: minTextSize * 8, // Adjust size based on textSize
                height: minTextSize * 8, // Adjust size based on textSize
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: activity.activityImage != null && activity.activityImage!.isNotEmpty
                      ? Image.network(
                    activity.activityImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.grey);
                    },
                  )
                      : Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: minTextSize * 1.5),
            Text(
              activity.description ?? 'No description available.',
              style: TextStyle(fontSize: minTextSize),
            ),
            SizedBox(height: minTextSize * 1.5),
            Text(
              'Time: ${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')} - ${activity.endTime.hour}:${activity.endTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: minTextSize),
            ),
            SizedBox(height: minTextSize * 1.5),
            Text(
              'Location: ${activity.location ?? 'Not specified'}',
              style: TextStyle(fontSize: minTextSize),
            ),
            SizedBox(height: minTextSize * 1.5),
            Text(
              'Capacity: ${activity.capacity}, Registered: ${activity.count ?? 0}',
              style: TextStyle(fontSize: minTextSize),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: minTextSize),
              ),
            ),
            SizedBox(width: minTextSize), // Space between buttons
            TextButton(
              onPressed: () => _signUp(context), // Call sign-up logic
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: minTextSize, color: Colors.white), // Text color white
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFfe6357), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
