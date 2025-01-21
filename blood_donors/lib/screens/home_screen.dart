import 'package:flutter/cupertino.dart';
import 'donation_form_screen.dart';
import 'donor_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Blood Donation App'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton.filled(
              child: const Text('Donate Blood'),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const DonationFormScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('View Donors'),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => DonorListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

