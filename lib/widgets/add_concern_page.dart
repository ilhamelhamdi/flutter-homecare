import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/widgets/image_preview.dart';
import 'add_summary_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add an Issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10), // Adjust the vertical padding as needed
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<PersonalCubit>(),
                    child: AddSummaryPage(
                      issueTitle: _issueTitleController.text,
                      description: _descriptionController.text,
                      images: _images,
                    ),
                  ),
                ),
              );
            },
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
