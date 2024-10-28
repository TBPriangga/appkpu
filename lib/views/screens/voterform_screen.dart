import 'package:flutter/material.dart';
import '../../viewmodels/voter_form_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gender_selector.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/image_picker_field.dart';

class VoterFormScreen extends StatefulWidget {
  static const String routePath = '/voter-form';

  const VoterFormScreen({super.key});

  @override
  State<VoterFormScreen> createState() => _VoterFormScreenState();
}

class _VoterFormScreenState extends State<VoterFormScreen> {
  late final VoterFormViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = VoterFormViewModel();
    // Get location when screen opens
    _viewModel.getLocation();
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
        backgroundColor: const Color(0xffB43F3F),
        title: const Text(
          'Form Entri Data',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                        _viewModel.setGender(gender);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    DatePickerField(
                      selectedDate: _viewModel.selectedDate,
                      onTap: () async {
                        await _viewModel.selectDate(context);
                        setState(() {});
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
                    ImagePickerField(
                      imagePath: _viewModel.imagePath,
                      onTap: () async {
                        await _viewModel.pickImage();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    // Lokasi GPS indicator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xffB43F3F),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Lokasi GPS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const Spacer(),
                          if (_viewModel.latitude != null &&
                              _viewModel.longitude != null)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xff25745A),
                            )
                          else
                            InkWell(
                              onTap: () async {
                                await _viewModel.getLocation();
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffB43F3F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _viewModel.isLoading
                            ? null
                            : () async {
                                // Cek apakah ada field yang kosong
                                final emptyFields = _viewModel.getEmptyFields();

                                if (emptyFields.length > 3) {
                                  // Jika lebih dari 3 field kosong
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Peringatan'),
                                      content: const Text('Data belum diisi'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                } else if (emptyFields.isNotEmpty) {
                                  // Tampilkan snackbar dengan field yang kosong
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Form berikut belum diisi: ${emptyFields.join(", ")}',
                                      ),
                                      backgroundColor: const Color(0xffB43F3F),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }

                                setState(() => _viewModel.isLoading = true);

                                final success = await _viewModel.submitForm();

                                if (mounted) {
                                  setState(() => _viewModel.isLoading = false);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data berhasil disimpan'),
                                        backgroundColor: Color(0xff25745A),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal menyimpan data'),
                                        backgroundColor: Color(0xffB43F3F),
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
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          if (_viewModel.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xffB43F3F),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
