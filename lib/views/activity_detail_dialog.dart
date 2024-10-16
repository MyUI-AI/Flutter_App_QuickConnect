import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityDetailDialog extends StatelessWidget {
  final Activity activity;

  const ActivityDetailDialog({required this.activity});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(activity.name, style: const TextStyle(fontSize: 24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.activityImage != null)
            Image.network(
              activity.activityImage!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 10),
          Text('Description: ${activity.description}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Date: ${activity.date}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Time: ${activity.time}', style: const TextStyle(fontSize: 18)),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed up successfully!')),
            );
          },
          child: const Text('Sign Up'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
