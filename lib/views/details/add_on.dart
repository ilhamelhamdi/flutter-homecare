import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import '../search/search_professional.dart';
import 'package:m2health/widgets/image_preview.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

class AddOn extends StatefulWidget {
  final Issue issue;
  final String serviceType; // Add serviceType parameter

  AddOn({required this.issue, required this.serviceType}); // Update constructor

  @override
  _AddOnState createState() => _AddOnState();
}

class _AddOnState extends State<AddOn> {
  late List<bool> _selectedServices;
  late List<String> serviceTitles;

  double _estimatedBudget = 145.0; // Initial estimated budget

  @override
  void initState() {
    super.initState();

    // Initialize services based on serviceType
    if (widget.serviceType == "Pharma") {
      serviceTitles = [
        'Analyze patient physiological data,\ninitial drug treatment plan, and patient treatment response',
        'Analyze specific treatment problems:\npoor response to treatment;poor\npatient medication compliance;\ndrug side effect; drug interactions',
        'Drug therapy adjustment made to\nphysicians by the pharmacist when\nappropriate',
        'Diet History & Evaluations',
        'Follow-up the therapy and ensure\npositive outcomes and reduces adverse effects',
      ];
    } else if (widget.serviceType == "Nurse") {
      serviceTitles = [
        'Medical Escort',
        'Inject',
        'Blood Glucose Check',
        'Medication Administration',
        'NGT Feeding',
        'Oral Suctioning',
        'PEG Feeding',
        'Stoma Bag Drainage',
        'Tracheostomy Suctioning',
        'Urine Bag Drainage',
      ];
    }

    // Initialize the selection state for services
    _selectedServices =
        List<bool>.generate(serviceTitles.length, (index) => false);
  }

  void _updateEstimatedBudget() {
    // Update the estimated budget based on selected services
    _estimatedBudget = 145.0; // Base budget
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        _estimatedBudget += 50.0; // Add 50 for each selected service
      }
    }
  }

  void _submitData() async {
    final token = await Utils.getSpString(Const.TOKEN);

    final data = {
      "add_on": _selectedServices
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => serviceTitles[entry.key])
          .join(', '),
      "estimated_budget": _estimatedBudget,
      "updated_at": DateTime.now().toIso8601String(),
    };

    print('Data to be submitted: $data');

    try {
      final response = await Dio().put(
        '${Const.API_PERSONAL_CASES}/${widget.issue.id}',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              serviceType: widget.serviceType,
            ),
          ),
        ); // Navigate back after successful submission
      } else {
        // Handle error
        print('Failed to submit data: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceType == "Pharma"
              ? 'Pharmacist Add-On Services'
              : 'Nursing Add-On Services',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: serviceTitles.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedServices[i] = !_selectedServices[i];
                            _updateEstimatedBudget();
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectedServices[i]
                                ? const Color(0xFF35C5CF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xFF35C5CF)),
                          ),
                          child: _selectedServices[i]
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      ),
                      title: Text(
                        serviceTitles[i],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                      ),
                      trailing: const Icon(Icons.info_outline_rounded,
                          color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimated Budget',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.info_outline_rounded, color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '\$$_estimatedBudget',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                  'Book Appointment',
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
