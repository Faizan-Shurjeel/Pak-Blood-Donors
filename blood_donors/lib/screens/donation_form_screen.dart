import 'package:flutter/cupertino.dart';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  DonationFormScreenState createState() => DonationFormScreenState();
}

class DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bloodType = '';
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Donate Blood'),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              CupertinoTextFormFieldRow(
                placeholder: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              CupertinoTextFormFieldRow(
                placeholder: 'Blood Type',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your blood type';
                  }
                  if (!RegExp(r'^(A|B|AB|O)[+-]$').hasMatch(value)) {
                    return 'Please enter a valid blood type (e.g., A+, O-)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bloodType = value!;
                },
              ),
              CupertinoTextFormFieldRow(
                placeholder: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Here you would typically send this data to a server
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text('Processing Data'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
