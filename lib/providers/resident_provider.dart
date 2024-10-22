import 'package:flutter/material.dart';
import '../models/resident.dart';
import '../repositories/resident_repository.dart';

class ResidentProvider extends ChangeNotifier {
  final ResidentRepository residentRepository;
  ResidentModel? _resident; // Single resident
  bool _isLoading = false;
  String? _errorMessage;
  double _textSize = 16.0; // Default text size
  List<ResidentModel> _residents = []; // List to store residents

  ResidentProvider({required this.residentRepository});

  ResidentModel? get resident => _resident;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get textSize => _textSize;

  // Getter for the residents list
  List<ResidentModel> get residentList => _residents;

  Future<void> fetchResidentsByApartment(String apartmentNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      _residents = await residentRepository.getResidentsByApartment(apartmentNumber); // Fetch residents
      if (_residents.isNotEmpty) {
        if (_residents.length == 1) {
          // If there's only one resident, select them automatically
          _resident = _residents.first;
          _textSize = _resident?.textSize ?? 16.0;
        }
        _errorMessage = null;
      } else {
        _errorMessage = 'No residents found for this apartment number';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch residents: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setResident(ResidentModel resident) {
    _resident = resident;
    _textSize = resident.textSize ?? 16.0;
    notifyListeners();
  }
}
