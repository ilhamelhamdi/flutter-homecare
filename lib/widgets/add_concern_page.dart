import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/personal/personal_page.dart';
import 'package:m2health/widgets/image_preview.dart';
import 'package:m2health/utils.dart'; // Assuming Utils contains the method to get the token
import 'dart:io';

class AddConcernPage extends StatefulWidget {
  @override
  _AddConcernPageState createState() => _AddConcernPageState();
}

class _AddConcernPageState extends State<AddConcernPage> {
  TextEditingController _issueTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<File> _images = [];

  void _addImage(File image) {
    setState(() {
      _images.add(image);
    });
  }

  Future<void> _submitData() async {
    final issueTitle = _issueTitleController.text;
    final description = _descriptionController.text;

    print('Issue Title: $issueTitle');
    print('Description: $description');
    print('Images: ${_images.map((image) => image.path).join(', ')}}');

    // Validate the data
    if (issueTitle.isEmpty || description.isEmpty) {
      print('Error: Issue title and description are required.');
      return;
    }

    // Upload images and get URLs
    List<String> imageUrls = [];
    if (_images.isNotEmpty) {
      for (File image in _images) {
        try {
          String fileName = image.path.split('/').last;
          FormData formData = FormData.fromMap({
            "file":
                await MultipartFile.fromFile(image.path, filename: fileName),
          });

          final token =
              await Utils.getSpString(Const.TOKEN); // Retrieve the token
          final response = await Dio().post(
            '${Const.API_PERSONAL_CASES}/upload',
            data: formData,
            options: Options(
              headers: {
                'Authorization':
                    'Bearer $token', // Include the token in the headers
              },
            ),
          );

          if (response.statusCode == 200) {
            imageUrls.add(response.data['url']);
          } else {
            print('Failed to upload image: ${response.statusMessage}');
          }
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }

    // Prepare the data to be sent to the API
    final data = {
      "user_id": 1,
      "title": issueTitle,
      "description": description,
      "images": imageUrls,
      "mobility_status": "wheel",
      "related_health_record": "Health Record",
      "add_on": "additional",
      "estimated_budget": 1000,
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };

    print('Data to be submitted: $data');

    try {
      final token = await Utils.getSpString(Const.TOKEN); // Retrieve the token
      final response = await Dio().post(
        '${Const.API_PERSONAL_CASES}',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Data submitted successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersonalPage()),
        );
      } else {
        print('Failed to submit data: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add an Issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tell us your concern',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 338,
              height: 50,
              child: TextField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  hintText: 'Issue Title',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 338,
              height: 129,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText:
                      'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 352,
          height: 58,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35C5CF),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

void showAddConcernPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider.value(
      value: context.read<PersonalCubit>(),
      child: AddConcernPage(),
    ),
  );
}
