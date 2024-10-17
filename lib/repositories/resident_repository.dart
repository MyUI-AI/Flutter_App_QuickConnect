import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resident.dart';

class ResidentRepository {
  final FirebaseFirestore _firestore;

  ResidentRepository(this._firestore);

  // Fetch residents by apartment number from Firestore
  Future<List<ResidentModel>> getResidentsByApartment(String apartmentNumber) async {
    final snapshot = await _firestore
        .collection('residents')
        .where('apartmentNumber', isEqualTo: apartmentNumber)
        .get();

    return snapshot.docs
        .map((doc) => ResidentModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
