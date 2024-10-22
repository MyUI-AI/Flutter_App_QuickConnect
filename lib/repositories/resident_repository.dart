import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resident.dart';

class ResidentRepository {
  final FirebaseFirestore _firestore;

  // Constructor accepting a Firestore instance
  ResidentRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<List<ResidentModel>> getResidentsByApartment(String apartmentNumber) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('residents')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return ResidentModel(
            id: doc.id,
            name: doc['name'] ?? '',
            apartmentNumber: doc['apartmentNumber'] ?? '',
            phoneNumber: doc['phoneNumber'] ?? '', // Ensure phoneNumber is passed
            profilePic: doc['profilePic'],
            textSize: doc['textSize']?.toDouble() ?? 16.0, // Default to 16.0 if null
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching residents: $e');
    }
  }
}
