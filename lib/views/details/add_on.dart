import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import '../search/search_professional.dart';

class AddOn extends StatefulWidget {
  final Issue issue;
  final String serviceType; // Add serviceType parameter

  AddOn({required this.issue, required this.serviceType}); // Update constructor

  @override
  _AddOnState createState() => _AddOnState();
}

class _AddOnState extends State<AddOn> {
  late List<bool> _selectedServices;
  late List<Map<String, dynamic>>
      serviceData; // Store full service data with prices

  double _estimatedBudget = 0.0; // Initial estimated budget

  @override
  void initState() {
    super.initState();
    _fetchServiceTitles();
  }

  Future<void> _fetchServiceTitles() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Determine endpoint based on service type
      final endpoint = widget.serviceType == "Pharma"
          ? '${Const.URL_API}/service-titles/pharma'
          : '${Const.URL_API}/service-titles/nurse';

      final response = await Dio().get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final servicesData =
            List<Map<String, dynamic>>.from(response.data['data']);

        setState(() {
          serviceData = servicesData; // Store full service data
          _selectedServices =
              List<bool>.generate(serviceData.length, (index) => false);
        });
      } else {
        // Fall back to default values if API fails
        _initializeDefaultServiceTitles();
      }
    } catch (e) {
      print('Error fetching service titles: $e');
      // Fall back to default values if API fails
      _initializeDefaultServiceTitles();
    }
  }

  void _initializeDefaultServiceTitles() {
    if (widget.serviceType == "Pharma") {
      serviceData = [
        {
          'id': 1,
          'title': 'Medication Review',
          'price': 15.0
        }, // Use 15.0 instead of 15
        {'id': 2, 'title': 'Prescription Consultation', 'price': 10.0},
        {'id': 3, 'title': 'Medication Management Plan', 'price': 25.0},
      ];
    } else if (widget.serviceType == "Nurse") {
      serviceData = [
        {'id': 1, 'title': 'Medical Escort', 'price': 20.0},
        {'id': 2, 'title': 'Inject', 'price': 15.0},
        {'id': 3, 'title': 'Blood Glucose Check', 'price': 10.0},
      ];
    }

    _selectedServices =
        List<bool>.generate(serviceData.length, (index) => false);
  }

  // void _updateEstimatedBudget() {
  //   // Update the estimated budget based on selected services
  //   _estimatedBudget = 0.0; // Reset budget
  //   for (int i = 0; i < _selectedServices.length; i++) {
  //     if (_selectedServices[i]) {
  //       _estimatedBudget +=
  //           serviceData[i]['price'] as double; // Use actual price
  //     }
  //   }
  // }

  void _updateEstimatedBudget() {
    // Reset budget
    _estimatedBudget = 0.0;

    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        // Safely cast price to double
        final price = serviceData[i]['price'];
        _estimatedBudget += (price is int ? price.toDouble() : price) as double;
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
          .map((entry) => serviceData[entry.key]['title'])
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
                itemCount: serviceData.length,
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
                        serviceData[i]['title'] as String,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                      ),
                      subtitle: Text(
                        '\$${serviceData[i]['price']}',
                        style: const TextStyle(
                          color: Color(0xFF35C5CF),
                          fontWeight: FontWeight.bold,
                        ),
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
