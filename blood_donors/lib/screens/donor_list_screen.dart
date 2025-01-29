import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; // for rootBundle

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({super.key});

  @override
  _DonorListScreenState createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  List<Map<String, dynamic>> _donors = [];
  List<Map<String, dynamic>> _filteredDonors = [];

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    try {
      final jsonString = await rootBundle.loadString('lib/screens/list.json');
      final data = jsonDecode(jsonString);
      if (data != null && data['blood_donors'] != null) {
        // Flatten nested structure as needed
        final donorsMap = data['blood_donors'] as Map<String, dynamic>;
        final allDonors = <Map<String, dynamic>>[];
        donorsMap.forEach((key, value) {
          if (value is List) {
            for (var donor in value) {
              allDonors.add({
                'name': donor['name'] ?? '',
                'bloodType': donor['blood_group'] ?? '',
                'contact': donor['contact_number'] ?? ''
              });
            }
          }
        });
        setState(() {
          _donors = allDonors;
          _filteredDonors = List.from(allDonors);
        });
      }
    } catch (e) {
      // Handle parsing or file errors
      setState(() {
        _donors = [];
        _filteredDonors = [];
      });
      // You could show an error dialog here if desired
    }
  }

  void _filterDonors(String query) {
    query = query.toLowerCase();
    setState(() {
      _filteredDonors = _donors.where((donor) {
        final name = donor['name']?.toLowerCase() ?? '';
        final bloodType = donor['bloodType']?.toLowerCase() ?? '';
        return name.contains(query) || bloodType.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Donor List'),
      ),
      child: Column(
        children: [
          CupertinoSearchTextField(
            placeholder: 'Search by name or blood type',
            onChanged: _filterDonors,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDonors.length,
              itemBuilder: (context, index) {
                return CupertinoListTile(
                  title: Text(_filteredDonors[index]['name'] ?? ''),
                  subtitle: Text(
                    'Blood Type: ${_filteredDonors[index]['bloodType']}'
                    '\nContact: ${_filteredDonors[index]['contact']}',
                  ),
                  leading: const Icon(CupertinoIcons.person),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
