import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/pages/details/nursing_add_on.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_state.dart';
import 'package:m2health/utils.dart';

// import 'details/add_on.dart';

class NursingAddIssuePage extends StatefulWidget {
  final NursingIssue? issue;
  final String serviceType;

  NursingAddIssuePage({this.issue, required this.serviceType});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<NursingAddIssuePage> {
  late String _mobilityStatus;
  String? _selectedStatus;
  List<Map<String, dynamic>> _medicalRecords = [];

  @override
  void initState() {
    super.initState();
    _mobilityStatus = 'bedbound';
    context.read<NursingCaseBloc>().add(GetMedicalRecordsEvent());
  }

  Future<void> _submitData() async {
    final issue = widget.issue;
    if (issue == null) return;

    print('Mobility Status: $_mobilityStatus');
    print('Related Health Record: $_selectedStatus');

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Find the selected record and extract just its ID
      final selectedRecord = _medicalRecords
          .firstWhere((record) => record['title'] == _selectedStatus);
      final int recordId = selectedRecord['id'];

      final data = {
        'mobility_status': _mobilityStatus,
        'related_health_record_id': recordId, // Submit just the ID
      };

      print('Data to be submitted: $data');

      final url = '${Const.API_NURSING_PERSONAL_CASES}/${issue.id}';
      print('Request URL: $url');

      final response = await Dio().put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Issue updated successfully');
      } else {
        print('Failed to update issue: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOn(
          issue: issue,
          serviceType: widget.serviceType, // Pass the required serviceType
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request ${widget.serviceType} Service',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<NursingCaseBloc, NursingCaseState>(
        listener: (context, state) {
          if (state is NursingCaseLoaded) {
            // This is a temporary solution. The AddOn page should be refactored
            // to use the NursingCaseBloc.
            final tempIssue = NursingIssue(
              id: 0,
              title: '',
              description: '',
              images: [],
              mobilityStatus: '',
              relatedHealthRecord: {},
              addOn: '',
              estimatedBudget: 0.0,
              userId: 0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOn(
                  issue: tempIssue,
                  serviceType: widget.serviceType,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MedicalRecordsLoaded) {
            _medicalRecords = state.medicalRecords;
            if (_medicalRecords.isNotEmpty && _selectedStatus == null) {
              _selectedStatus = _medicalRecords.first['title'];
            }
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your mobility status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    if (state is MedicalRecordsLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state is MedicalRecordsError)
                      Text('Error: ${state.message}')
                    else if (_medicalRecords.isEmpty)
                      const Text('No medical records available')
                    else
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
                            items: _medicalRecords.map((record) {
                              return DropdownMenuItem<String>(
                                value: record['title'],
                                child: Text(record['title']),
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
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is NursingCaseLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
