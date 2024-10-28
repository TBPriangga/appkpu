import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpuapp/views/screens/edit_form_screen.dart';
import 'package:kpuapp/views/screens/information_screen.dart';
import 'package:kpuapp/views/screens/voter_list_screen.dart';
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
        '/voter-list': (context) => const VoterListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit-voter') {
          final args = settings.arguments as Map<String, dynamic>;
          final voter = args['voter'];
          return MaterialPageRoute(
            builder: (context) => EditVoterScreen(voter: voter),
          );
        }
        return null;
      },
    );
  }
}
