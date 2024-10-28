import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/constants/colors.dart';
import '../widgets/button_menu_item.dart';
import 'information_screen.dart';
import 'voter_list_screen.dart';
import 'voterform_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routePath = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, padding, 16.0, padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo_kpu.png",
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 24),
                  ButtonMenuItem(
                    icon: Icons.info_outline,
                    title: 'Informasi Pemilihan Umum',
                    onTap: () {
                      Navigator.pushNamed(context, InformationScreen.routePath);
                    },
                  ),
                  const SizedBox(height: 30),
                  ButtonMenuItem(
                    icon: Icons.edit_document,
                    title: 'Form Entri Data',
                    onTap: () {
                      Navigator.pushNamed(context, VoterFormScreen.routePath);
                    },
                  ),
                  const SizedBox(height: 30),
                  ButtonMenuItem(
                    icon: Icons.list_alt,
                    title: 'Lihat Data',
                    onTap: () {
                      Navigator.pushNamed(context, VoterListScreen.routePath);
                    },
                  ),
                  const SizedBox(height: 30),
                  ButtonMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content:
                              const Text('Apakah Anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
