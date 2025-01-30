import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CupertinoColors.systemRed,
  ));

  // Initialize Supabase
  await initializeSupabase();

  runApp(const BloodDonationApp());
}

Future<void> initializeSupabase() async {
  // Access the Supabase URL and Anon Key from the .env file
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Blood Donation App',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemRed,
      ),
      home: const HomeScreen(),
    );
  }
}
