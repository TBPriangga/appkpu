import 'package:flutter/material.dart';
import '../../app/constants/colors.dart';

class InformationScreen extends StatelessWidget {
  static const String routePath = '/information';

  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xffB43F3F),
        title: const Text(
          'Informasi Pemilihan Umum',
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(
                title: 'Tentang Pemilu',
                content:
                    'Pemilihan Umum (Pemilu) adalah sarana kedaulatan rakyat untuk memilih '
                    'Presiden dan Wakil Presiden, anggota Dewan Perwakilan Rakyat (DPR), '
                    'Dewan Perwakilan Daerah (DPD), dan Dewan Perwakilan Rakyat Daerah (DPRD) '
                    'yang dilaksanakan secara langsung, umum, bebas, rahasia, jujur, dan adil.',
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                title: 'Syarat Pemilih',
                content: '1. Warga Negara Indonesia\n'
                    '2. Berusia minimal 17 tahun atau sudah/pernah menikah\n'
                    '3. Tidak sedang dicabut hak pilihnya\n'
                    '4. Terdaftar sebagai pemilih\n'
                    '5. Bukan anggota TNI/POLRI aktif',
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                title: 'Tahapan Pemilu',
                content: '1. Pendaftaran Pemilih\n'
                    '2. Pencalonan\n'
                    '3. Kampanye\n'
                    '4. Masa Tenang\n'
                    '5. Pemungutan Suara\n'
                    '6. Penghitungan Suara\n'
                    '7. Penetapan Hasil',
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                title: 'Dokumen yang Diperlukan',
                content: '1. KTP Elektronik\n'
                    '2. Kartu Keluarga\n'
                    '3. Surat Keterangan dari Dinas Kependudukan (jika diperlukan)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffB43F3F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
