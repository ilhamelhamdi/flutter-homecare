import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/views/details/detail_pharma.dart';
import 'package:m2health/views/payment.dart';
import 'dart:io';

class AddIssuePage extends StatefulWidget {
  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  String _mobilityStatus = 'bedbound';
  String _selectedStatus = 'Select Status';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _images = [];

  void _submitData() {
    final issue = Issue(
      id: 0,
      userId: 1,
      title: _titleController.text,
      description: _descriptionController.text,
      images: _images,
      mobilityStatus: _mobilityStatus,
      relatedHealthRecord: _selectedStatus,
      addOn: '',
      estimatedBudget: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Images: ${_images.join(', ')}');
    print('Mobility Status: $_mobilityStatus');
    print('Related Health Record: $_selectedStatus');

    context.read<PersonalCubit>().addIssue(issue);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPharma(
          issue: issue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Case Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your mobility status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Bedbound'),
                  value: 'bedbound',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Wheelchair bound'),
                  value: 'wheelchair bound',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Walking Aid'),
                  value: 'Walking Aid',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Mobile Without Aid'),
                  value: 'Mobile Without Aid',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a related health record',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 362,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  items: <String>[
                    'Select Status',
                    'Status 1',
                    'Status 2',
                    'Status 3'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 352,
              height: 58,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Add Issue',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
