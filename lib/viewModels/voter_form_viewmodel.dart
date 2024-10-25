import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database/location_service.dart';
import '../services/database/voter_service.dart';
import '../models/voter.dart';

class VoterFormViewModel {
  final formKey = GlobalKey<FormState>();
  final nikController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final _voterService = VoterService();
  final _locationService = LocationService();

  String? selectedGender;
  DateTime? selectedDate;
  String? imagePath;
  double? latitude;
  double? longitude;
  bool isLoading = false;

  String? validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    if (value.length != 16) {
      return 'NIK harus 16 digit';
    }
    return null;
  }

  String? validateRequired(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field tidak boleh kosong';
    }
    return null;
  }

  Future<bool> getLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        return true;
      }
      return false;
    } catch (e) {
      print('Error getting location: $e');
      return false;
    }
  }

// Di VoterFormViewModel
  Future<bool> submitForm() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;

    try {
      await getLocation();

      final voter = Voter(
        nik: nikController.text,
        name: nameController.text,
        phone: phoneController.text,
        gender: selectedGender ?? '',
        registrationDate: selectedDate ?? DateTime.now(),
        address: addressController.text,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      print('Saving voter data: ${voter.toMap()}'); // Tambahkan ini

      final result = await _voterService.insert(voter);
      print('Save result: $result'); // Tambahkan ini

      resetForm();
      return true;
    } catch (e) {
      print('Error saving voter: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      imagePath = image.path;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate = picked;
    }
  }

  void setGender(String gender) {
    selectedGender = gender;
  }

  void resetForm() {
    nikController.clear();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    selectedGender = null;
    selectedDate = null;
    imagePath = null;
    latitude = null;
    longitude = null;
  }

  void dispose() {
    nikController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
