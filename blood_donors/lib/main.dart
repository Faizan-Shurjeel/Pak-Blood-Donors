import 'package:flutter/cupertino.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BloodDonationApp());
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
/*Best Results at: https://www.pakblood.com/ */
