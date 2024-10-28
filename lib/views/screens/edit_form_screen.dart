import 'package:flutter/material.dart';
import 'package:kpuapp/app/constants/colors.dart';
import '../../models/voter.dart';
import '../../viewmodels/edit_voter_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gender_selector.dart';

class EditVoterScreen extends StatefulWidget {
  static const String routePath = '/edit-voter';

  final Voter voter;

  const EditVoterScreen({
    Key? key,
    required this.voter,
  }) : super(key: key);

  @override
  State<EditVoterScreen> createState() => _EditVoterScreenState();
}

class _EditVoterScreenState extends State<EditVoterScreen> {
  late final EditVoterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EditVoterViewModel();
    _viewModel.initData(widget.voter);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Edit Data Pemilih',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _viewModel.formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'NIK',
                controller: _viewModel.nikController,
                validator: _viewModel.validateNIK,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: 'Nama Lengkap',
                controller: _viewModel.nameController,
                validator: (value) =>
                    _viewModel.validateRequired(value, 'Nama'),
              ),
              CustomTextField(
                label: 'Nomor Handphone',
                controller: _viewModel.phoneController,
                validator: (value) =>
                    _viewModel.validateRequired(value, 'Nomor HP'),
                keyboardType: TextInputType.phone,
              ),
              GenderSelector(
                selectedGender: _viewModel.selectedGender,
                onGenderSelected: (gender) {
                  setState(() {
                    _viewModel.selectedGender = gender;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Alamat',
                controller: _viewModel.addressController,
                validator: (value) =>
                    _viewModel.validateRequired(value, 'Alamat'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          final success =
                              await _viewModel.updateVoter(widget.voter);
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data berhasil diperbarui'),
                                  backgroundColor: AppColors.success40,
                                ),
                              );
                              Navigator.pop(context,
                                  true); // true menandakan data berhasil diupdate
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal memperbarui data'),
                                  backgroundColor: AppColors.error40,
                                ),
                              );
                            }
                          }
                        },
                  child: _viewModel.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
