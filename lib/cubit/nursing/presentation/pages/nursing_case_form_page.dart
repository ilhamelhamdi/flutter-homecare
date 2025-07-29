// // lib/features/nursing/presentation/pages/nursing_case_form_page.dart
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/const.dart';
// import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case_bloc.dart';
// import 'package:m2health/utils.dart';

// class NursingCaseForm extends StatefulWidget {
//   @override
//   _NursingCaseFormState createState() => _NursingCaseFormState();
// }

// class _NursingCaseFormState extends State<NursingCaseForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _medicalRequirementsController = TextEditingController();
//   String _mobilityStatus = 'ambulatory';
//   String _careType = 'basic';
//   List<File> _images = [];
//   int? _selectedRecordId;
//   List<Map<String, dynamic>> _medicalRecords = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchMedicalRecords();
//   }

//   Future<void> _fetchMedicalRecords() async {
//     // Fetch medical records using existing API
//     try {
//       final token = await Utils.getSpString(Const.TOKEN);
//       final response = await Dio().get(
//         '${Const.API_MEDICAL_RECORDS}',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _medicalRecords =
//               List<Map<String, dynamic>>.from(response.data['data']);
//         });
//       }
//     } catch (e) {
//       print('Error fetching medical records: $e');
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (_selectedRecordId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please select a medical record')),
//         );
//         return;
//       }

//       context.read<NursingCaseBloc>().add(
//             CreateNursingCase(
//               title: _titleController.text,
//               description: _descriptionController.text,
//               mobilityStatus: _mobilityStatus,
//               careType: _careType,
//               medicalRequirements: _medicalRequirementsController.text,
//               relatedHealthRecordId: _selectedRecordId!,
//               images: _images,
//             ),
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           TextFormField(
//             controller: _titleController,
//             decoration: InputDecoration(labelText: 'Case Title'),
//             validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//           ),
//           TextFormField(
//             controller: _descriptionController,
//             decoration: InputDecoration(labelText: 'Description'),
//             maxLines: 3,
//             validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//           ),
//           // Mobility status radio buttons
//           _buildMobilitySection(),
//           // Care type dropdown
//           _buildCareTypeSection(),
//           // Medical requirements field
//           TextFormField(
//             controller: _medicalRequirementsController,
//             decoration: InputDecoration(labelText: 'Medical Requirements'),
//             maxLines: 2,
//           ),
//           // Medical record selection
//           _buildMedicalRecordSection(),
//           // Image upload section
//           _buildImageSection(),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _submitForm,
//             child: Text('Create Nursing Case'),
//           ),
//         ],
//       ),
//     );
//   }
// }
