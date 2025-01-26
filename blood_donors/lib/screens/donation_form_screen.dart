import 'package:flutter/cupertino.dart';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  DonationFormScreenState createState() => DonationFormScreenState();
}

class DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bloodType = 'A+';
  String _phoneNumber = '';
  String _email = '';
  String _address = '';
  DateTime _donationDate = DateTime.now();

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

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
                placeholder: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
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
              CupertinoTextFormFieldRow(
                placeholder: 'Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              CupertinoButton(
                child: Text('Donation Date: ${_donationDate.toLocal()}'.split(' ')[0]),
                onPressed: () async {
                  final DateTime? picked = await showCupertinoModalPopup<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: CupertinoColors.white,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _donationDate,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              _donationDate = newDate;
                            });
                          },
                        ),
                      );
                    },
                  );
                  if (picked != null && picked != _donationDate) {
                    setState(() {
                      _donationDate = picked;
                    });
                  }
                },
              ),
              CupertinoButton(
                child: Text('Blood Type: $_bloodType'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: const Text('Select Blood Type'),
                        actions: _bloodTypes.map((String bloodType) {
                          return CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _bloodType = bloodType;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(bloodType),
                          );
                        }).toList(),
                      );
                    },
                  );
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