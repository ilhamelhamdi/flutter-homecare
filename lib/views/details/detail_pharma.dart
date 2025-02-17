import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import '../search/search_pharmacist.dart';
import 'package:m2health/widgets/image_preview.dart';
import 'dart:io';

class PaymentPharma extends StatefulWidget {
  final Issue issue;

  PaymentPharma({required this.issue});

  @override
  _PaymentPharmaState createState() => _PaymentPharmaState();
}

class _PaymentPharmaState extends State<PaymentPharma> {
  List<bool> _selectedServices = List<bool>.generate(5, (index) => false);

  List<String> serviceTitles = [
    'Analyze patient physiological data,\ninitial drug treatment plan, and patient treatment response',
    'Analyze specific treatment problems:\npoor response to treatment;poor\npatient medication compliance;\ndrug side effect; drug interactions',
    'Drug therapy adjustment made to\nphysicians by the pharmacist when\napropriate',
    'Diet History & Evaluations',
    'Follow-up the therapy and ensure\npositive outcomes and reduces adverse effects',
  ];

  double _estimatedBudget = 145.0; // Initial estimated budget

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
    final userId = await Utils.getSpString(Const.USER_ID);

    final data = {
      "id": widget.issue.id,
      "user_id": userId,
      "title": widget.issue.title,
      "description": widget.issue.description,
      "images": widget.issue.images.join(','),
      "mobility_status": widget.issue.mobilityStatus,
      "related_health_record": widget.issue.relatedHealthRecord,
      "add_on": _selectedServices
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => serviceTitles[entry.key])
          .join(', '),
      "estimated_budget": _estimatedBudget,
      "created_at": widget.issue.createdAt.toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };

    print('Data to be submitted: $data');

    try {
      final response = await Dio().post(
        '${Const.API_PERSONAL_CASES}',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPharmacistPage(),
          ),
        );
      } else {
        // Handle error
        print('Failed to submit data');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < serviceTitles.length; i++)
              Card(
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
                        fontSize: 12,
                        fontWeight: FontWeight.bold), // Set the font size
                    overflow:
                        TextOverflow.visible, // Ensure the text is fully shown
                  ),
                  trailing: const Icon(Icons.info_outline_rounded,
                      color: Colors.grey),
                ),
              ),
            const Spacer(),
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
