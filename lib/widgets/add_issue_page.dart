import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/details/pharma_add_on.dart';
import 'dart:io';

class AddIssuePage extends StatefulWidget {
  final Issue? issue;

  AddIssuePage({this.issue});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  late String _mobilityStatus;
  late String _selectedStatus;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<File> _images;

  final List<String> _statusOptions = [
    'Select Status',
    'Status 1',
    'Status 2',
    'Status 3'
  ];

  @override
  void initState() {
    super.initState();
    _mobilityStatus = widget.issue?.mobilityStatus ?? 'bedbound';
    _selectedStatus = _statusOptions.contains(widget.issue?.relatedHealthRecord)
        ? widget.issue!.relatedHealthRecord
        : 'Select Status';
    _titleController = TextEditingController(text: widget.issue?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.issue?.description ?? '');
    _images =
        []; // Initialize with empty list or load existing images if needed
  }

  Future<void> _submitData() async {
    final issue = Issue(
      id: 0,
      userId: 1,
      title: _titleController.text,
      description: _descriptionController.text,
      images: [], // Placeholder, will be updated after upload
      mobilityStatus: _mobilityStatus,
      relatedHealthRecord: _selectedStatus,
      addOn: '',
      estimatedBudget: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Images: ${_images.map((image) => image.path).join(', ')}');
    print('Mobility Status: $_mobilityStatus');
    print('Related Health Record: $_selectedStatus');

    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final formData = FormData.fromMap({
        'id': issue.id,
        'user_id': issue.userId,
        'title': issue.title,
        'description': issue.description,
        'mobility_status': issue.mobilityStatus,
        'related_health_record': issue.relatedHealthRecord,
        'add_on': issue.addOn,
        'estimated_budget': issue.estimatedBudget,
        'created_at': issue.createdAt.toIso8601String(),
        'updated_at': issue.updatedAt.toIso8601String(),
        'images': _images.isNotEmpty
            ? await Future.wait(_images.map((image) async {
                return await MultipartFile.fromFile(image.path,
                    filename: image.path.split('/').last);
              }))
            : null,
      });

      final response = await Dio().post(
        Const.API_PERSONAL_CASES,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Issue added successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPharma(
              issue: issue,
            ),
          ),
        );
      } else {
        print('Failed to add issue: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }

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
                  title: const Text('Walk'),
                  value: 'walk',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Stand'),
                  value: 'stand',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Chair'),
                  value: 'chair',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Bed'),
                  value: 'bed',
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
                  items: _statusOptions.map((String value) {
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
