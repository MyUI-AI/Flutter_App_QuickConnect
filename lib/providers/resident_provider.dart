import 'package:flutter/material.dart';
import '../models/resident.dart';
import '../repositories/resident_repository.dart';

class ResidentProvider extends ChangeNotifier {
  final ResidentRepository _residentRepository;
  List<ResidentModel> _residents = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor
  ResidentProvider(this._residentRepository);

  // Getter for residents
  List<ResidentModel> get residents => _residents;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for error message
  String? get errorMessage => _errorMessage;

  // Fetch residents by apartment number
  Future<void> fetchResidentsByApartment(String apartmentNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      _residents = await _residentRepository.getResidentsByApartment(apartmentNumber);
      _errorMessage = null; // Reset error if successful
    } catch (e) {
      _errorMessage = 'Failed to fetch residents: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
