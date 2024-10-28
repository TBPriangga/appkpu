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

  bool isAllFieldFilled() {
    return nikController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        selectedGender != null &&
        selectedDate != null &&
        addressController.text.isNotEmpty &&
        imagePath != null;
  }

  List<String> getEmptyFields() {
    List<String> emptyFields = [];

    if (nikController.text.isEmpty) {
      emptyFields.add('NIK');
    }
    if (nameController.text.isEmpty) {
      emptyFields.add('Nama Lengkap');
    }
    if (phoneController.text.isEmpty) {
      emptyFields.add('Nomor HP');
    }
    if (selectedGender == null) {
      emptyFields.add('Jenis Kelamin');
    }
    if (selectedDate == null) {
      emptyFields.add('Tanggal');
    }
    if (addressController.text.isEmpty) {
      emptyFields.add('Alamat');
    }
    if (imagePath == null) {
      emptyFields.add('Foto');
    }

    return emptyFields;
  }

  String? validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK wajib diisi';
    }
    if (value.length != 16) {
      return 'NIK harus 16 digit';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'NIK hanya boleh berisi angka';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor HP hanya boleh berisi angka';
    }
    if (value.length < 10 || value.length > 13) {
      return 'Nomor HP harus 10-13 digit';
    }
    return null;
  }

  String? validateRequired(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field wajib diisi';
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

  Future<bool> submitForm() async {
    // Validasi semua field terlebih dahulu
    final emptyFields = getEmptyFields();
    if (emptyFields.isNotEmpty) {
      return false;
    }

    if (!formKey.currentState!.validate()) {
      return false;
    }

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

      await _voterService.insert(voter);
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
