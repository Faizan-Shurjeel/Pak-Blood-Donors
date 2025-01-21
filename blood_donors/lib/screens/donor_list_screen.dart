import 'package:flutter/cupertino.dart';

class DonorListScreen extends StatelessWidget {
  final List<Map<String, String>> donors = [
    {'name': 'John Doe', 'bloodType': 'A+'},
    {'name': 'Jane Smith', 'bloodType': 'O-'},
    {'name': 'Bob Johnson', 'bloodType': 'B+'},
  ];

  DonorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Donor List'),
      ),
      child: ListView.builder(
        itemCount: donors.length,
        itemBuilder: (context, index) {
          return CupertinoListTile(
            title: Text(donors[index]['name']!),
            subtitle: Text('Blood Type: ${donors[index]['bloodType']}'),
            leading: const Icon(CupertinoIcons.person),
          );
        },
      ),
    );
  }
}
