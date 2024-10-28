import 'package:flutter/material.dart';
import 'package:kpuapp/app/constants/colors.dart';
import '../../viewmodels/voter_list_viewmodel.dart';
import '../widgets/voter_card.dart';

class VoterListScreen extends StatefulWidget {
  static const String routePath = '/voter-list';

  const VoterListScreen({super.key});

  @override
  State<VoterListScreen> createState() => _VoterListScreenState();
}

class _VoterListScreenState extends State<VoterListScreen> {
  late final VoterListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = VoterListViewModel();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadVoters();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Data Pemilih',
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xffB43F3F),
                ),
              ),
            )
          : _viewModel.voters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data pemilih',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _viewModel.voters.length,
                    itemBuilder: (context, index) {
                      final voter = _viewModel.voters[index];
                      return VoterCard(
                        voter: voter,
                        onDelete: () async {
                          if (voter.id != null) {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah Anda yakin ingin menghapus data ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Ya'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _viewModel.deleteVoter(voter.id!);
                              setState(() {});
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data berhasil dihapus'),
                                    backgroundColor: AppColors.success40,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
