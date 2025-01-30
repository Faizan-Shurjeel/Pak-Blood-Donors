import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'donor_details_screen.dart';

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({super.key});

  @override
  _DonorListScreenState createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  Future<List<Map<String, dynamic>>>? _donorsFuture;

  @override
  void initState() {
    super.initState();
    _donorsFuture = _loadDonors();
  }

  Future<List<Map<String, dynamic>>> _loadDonors() async {
    try {
      final response =
          await Supabase.instance.client.from('blood_donors').select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading donors: $e');
      // Optionally show an error dialog
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Failed to load donors: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return [];
    }
  }

  void _filterDonors(String query, List<Map<String, dynamic>> donors) {
    query = query.toLowerCase();
    setState(() {
      _filteredDonors = donors.where((donor) {
        final Name = donor['Name']?.toLowerCase() ?? '';
        final blood_group = donor['blood_group']?.toLowerCase() ?? '';
        final contact_number = donor['contact_number']?.toLowerCase() ?? '';
        return Name.contains(query) ||
            blood_group.contains(query) ||
            contact_number.contains(query);
      }).toList();
    });
  }

  List<Map<String, dynamic>> _filteredDonors = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Donor List'),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _donorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No donors found'),
            );
          } else {
            final donors = snapshot.data!;
            _filteredDonors = List.from(donors);
            return Column(
              children: [
                CupertinoSearchTextField(
                  placeholder: 'Search by Name or blood type',
                  onChanged: (query) => _filterDonors(query, donors),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredDonors.length,
                    itemBuilder: (context, index) {
                      return CupertinoListTile(
                        title: Text(_filteredDonors[index]['Name'] ?? ''),
                        subtitle: Text(
                          'Blood Type: ${_filteredDonors[index]['blood_group']}',
                        ),
                        leading: const Icon(CupertinoIcons.person),
                        trailing: const Icon(CupertinoIcons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DonorDetailsScreen(
                                donor: _filteredDonors[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
