import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> donor;

  const DonorDetailsScreen({super.key, required this.donor});

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (context.mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: const Text('Could not initiate phone call. Please try again.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: ${e.toString()}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Donor Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Blood Type Card
                _buildBloodTypeCard(),
                const SizedBox(height: 20),

                // Donor Information Section
                CupertinoListSection.insetGrouped(
                  header: const Text('DONOR INFORMATION'),
                  children: [
                    _buildInfoTile(
                        'Serial Number', donor['sr_no']?.toString() ?? 'N/A'),
                    _buildInfoTile('Name', donor['Name'] ?? 'N/A'),
                    _buildInfoTile('Contact', donor['contact_number'] ?? 'N/A'),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton.filled(
                        onPressed: () =>
                            _makePhoneCall(context, donor['contact_number']),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.phone_fill),
                            SizedBox(width: 8),
                            Text('Call Donor'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      color: CupertinoColors.systemGrey5,
                      child: const Icon(
                        CupertinoIcons.share,
                        color: CupertinoColors.systemBlue,
                      ),
                      onPressed: () {
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBloodTypeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: CupertinoColors.systemRed.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            donor['blood_group'] ?? 'N/A',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemRed,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Blood Group',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return CupertinoListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: CupertinoColors.systemGrey,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
