import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String name;
  String? description;
  String? activityImage;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final int capacity;
  int count; // Track the current number of registrations
  bool signedUp; // Track sign-up status

  Activity({
    required this.name,
    this.description,
    this.activityImage,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.capacity,
    this.count = 0, // Initialize with 0 users
    this.signedUp = false, // Initialize with false
  });

  // Increment count only if capacity allows
  bool incrementCount() {
    if (count < capacity) {
      count++;
      return true; // Successfully signed up
    }
    return false; // Capacity full
  }

  // Factory constructor to create an Activity from Firestore document
  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Activity(
      name: data['name'] ?? 'Unnamed Activity', // Provide a default name if null
      description: data['description'], // Nullable field
      activityImage: data['activityImage'] ?? 'default_image_url.png', // Fallback for null image URL
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      location: data['location'] ?? 'Unknown location', // Fallback for null location
      capacity: data['capacity'] ?? 0, // Default to 0 if null
      count: data['count'] ?? 0, // Default to 0 if null
      signedUp: data['signedUp'] ?? false, // Default to false if null
    );
  }

  // Convert Activity instance to Firestore representation
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'activityImage': activityImage,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'location': location,
      'capacity': capacity,
      'count': count,
      'signedUp': signedUp, // Include signedUp in Firestore representation
    };
  }
}
