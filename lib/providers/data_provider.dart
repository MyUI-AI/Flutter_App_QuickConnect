import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _data = [];
  List<String> get data => _data;

  Future<void> fetchData() async {
    try {
      final snapshot = await _firestore.collection('your_collection').get();
      _data = snapshot.docs.map((doc) => doc['field_name'] as String).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> addData(String newData) async {
    try {
      await _firestore.collection('your_collection').add({'field_name': newData});
      await fetchData(); // Refresh data after adding
    } catch (e) {
      print('Error adding data: $e');
    }
  }
}
