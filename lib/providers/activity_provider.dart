import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];
  String? _errorMessage;

  List<Activity> get activities => _activities;
  String? get errorMessage => _errorMessage;

  Future<void> fetchActivities() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('activities').get();
      _activities = snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch activities: $e';
      notifyListeners();
    }
  }

  // Method to register for an activity
  bool registerForActivity(Activity activity) {
    bool success = activity.incrementCount();
    if (success) {
      // You may want to update the Firestore record here to reflect the new count
      _updateActivityCount(activity);
    }
    notifyListeners();
    return success;
  }

  Future<void> _updateActivityCount(Activity activity) async {
    try {
      await FirebaseFirestore.instance.collection('activities').doc(activity.name).update({
        'count': activity.count,
      });
    } catch (e) {
      print("Failed to update activity count: $e");
    }
  }
}
