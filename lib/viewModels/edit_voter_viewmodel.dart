import 'package:flutter/material.dart';
import '../models/voter.dart';
import '../services/database/voter_service.dart';

class EditVoterViewModel {
  final _voterService = VoterService();
  final formKey = GlobalKey<FormState>();

  final nikController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? selectedGender;
  bool isLoading = false;

  void initData(Voter voter) {
    nikController.text = voter.nik;
    nameController.text = voter.name;
    phoneController.text = voter.phone;
    addressController.text = voter.address;
    selectedGender = voter.gender;
  }

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

  Future<bool> updateVoter(Voter voter) async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;

    try {
      final updatedVoter = Voter(
        id: voter.id,
        nik: nikController.text,
        name: nameController.text,
        phone: phoneController.text,
        gender: selectedGender ?? voter.gender,
        registrationDate: voter.registrationDate,
        address: addressController.text,
        imagePath: voter.imagePath,
        latitude: voter.latitude,
        longitude: voter.longitude,
      );

      await _voterService.update(updatedVoter);
      return true;
    } catch (e) {
      print('Error updating voter: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    nikController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
