import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpuapp/views/screens/information_screen.dart';
import 'package:kpuapp/views/screens/voterform_screen.dart';
import 'views/screens/home_page.dart';
import 'views/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientasi portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPU Data Pemilih',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routePath,
      routes: {
        SplashScreen.routePath: (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/information': (context) => const InformationScreen(),
        '/voter-form': (context) => const VoterFormScreen(),
      },
    );
  }
}
