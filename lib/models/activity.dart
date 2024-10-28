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
  bool signedUp; // Add this property to track sign-up status

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

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Activity(
      name: data['name'] ?? '',
      description: data['description'],
      activityImage: data['activityImage'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      capacity: data['capacity'] ?? 0,
      count: data['count'] ?? 0,
      signedUp: data['signedUp'] ?? false, // Initialize signedUp from Firestore
    );
  }

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
