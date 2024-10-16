// ignore_for_file: unused_field

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

  // Getter for users
  List<ResidentModel> get residents => _residents;

  // Fetch users by apartment number
  Future<void> fetchResidentsByApartment(String apartmentNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      _residents =
          await _residentRepository.getResidentsByApartment(apartmentNumber);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch users';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
