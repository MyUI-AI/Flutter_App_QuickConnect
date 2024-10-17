import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentModel {
  final String? id;
  final String name;
  final String apartmentNumber;
  final String phoneNumber;
  final String? profilePic;

  ResidentModel({
    this.id,
    required this.name,
    required this.apartmentNumber,
    required this.phoneNumber,
    this.profilePic,
  });

  // Factory constructor to create a ResidentModel from Firestore document
  factory ResidentModel.fromFirestore(Map<String, dynamic> json, String id) {
    return ResidentModel(
      id: id,
      name: json['name'] ?? '',
      apartmentNumber: json['apartmentNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePic: json['profilePic'],
    );
  }

  // Method to convert ResidentModel to Firestore data format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'apartmentNumber': apartmentNumber,
      'phoneNumber': phoneNumber,
      if (profilePic != null) 'profilePic': profilePic,
    };
  }
}
