import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/voter.dart';
import '../screens/edit_form_screen.dart';

class VoterCard extends StatelessWidget {
  final Voter voter;
  final VoidCallback onDelete;
  final VoidCallback? onRefresh;

  const VoterCard({
    super.key,
    required this.voter,
    required this.onDelete,
    this.onRefresh,
  });

  void _showImagePreview(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Image preview
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            // Close button
            Positioned(
              top: 40,
              right: 16,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (voter.imagePath != null)
                  InkWell(
                    onTap: () => _showImagePreview(context, voter.imagePath!),
                    child: Hero(
                      tag: 'voter_image_${voter.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(voter.imagePath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voter.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('NIK: ${voter.nik}'),
                      Text('No. HP: ${voter.phone}'),
                      Text('Jenis Kelamin: ${voter.gender}'),
                      Text(
                        'Tanggal: ${DateFormat('dd/MM/yyyy').format(voter.registrationDate)}',
                      ),
                      Text('Alamat: ${voter.address}'),
                      if (voter.latitude != null &&
                          voter.longitude != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Color(0xffB43F3F),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Koordinat: ${voter.latitude!.toStringAsFixed(6)}, ${voter.longitude!.toStringAsFixed(6)}',
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditVoterScreen(voter: voter),
                      ),
                    );

                    if (result == true) {
                      // Refresh data list jika update berhasil
                      onRefresh?.call();
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xff25745A),
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xff25745A),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xffB43F3F),
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Color(0xffB43F3F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
