import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resident.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ResidentModel>> getResidentsByApartment(
      String apartmentNumber) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('residents')
          .where('apartmentNumber', isEqualTo: apartmentNumber)
          .get();

      return snapshot.docs
          .map((doc) => ResidentModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}

//   // Get resident by ID
//   Future<ResidentModel?> getResidentById(String residentId) async {
//     DocumentSnapshot doc =
//         await _db.collection('residents').doc(residentId).get();
//     if (doc.exists) {
//       return ResidentModel.fromFirestore(
//           doc.data() as Map<String, dynamic>, doc.id);
//     }
//     return null;
//   }

//   // Update an existing user
//   Future<void> updateResident(ResidentModel resident) async {
//     await _db
//         .collection('residents')
//         .doc(resident.id)
//         .update(resident.toFirestore());
//   }

//   // Delete a resident
//   Future<void> deleteResident(String residentId) async {
//     await _db.collection('residents').doc(residentId).delete();
//   }
// }
