import '../models/resident.dart';
import '../services/firestore_service.dart';

class ResidentRepository {
  final FirestoreService _firestoreService;

  ResidentRepository(this._firestoreService);

  Future<List<ResidentModel>> getResidentsByApartment(String apartmentNumber) {
    return _firestoreService.getResidentsByApartment(apartmentNumber);
  }
}
