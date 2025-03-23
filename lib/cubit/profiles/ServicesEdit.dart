import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

class ServiceTitlesEditPage extends StatefulWidget {
  @override
  _ServiceTitlesEditPageState createState() => _ServiceTitlesEditPageState();
}

class _ServiceTitlesEditPageState extends State<ServiceTitlesEditPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> pharmaServices = [];
  List<Map<String, dynamic>> nurseServices = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchServiceTitles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchServiceTitles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Fetch Pharmacist service titles
      final pharmaResponse = await Dio().get(
        '${Const.URL_API}/service-titles/pharma',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Fetch Nurse service titles
      final nurseResponse = await Dio().get(
        '${Const.URL_API}/service-titles/nurse',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (pharmaResponse.statusCode == 200 && nurseResponse.statusCode == 200) {
        setState(() {
          // If backend returns data, use it, otherwise use default values
          if (pharmaResponse.data['data'] != null &&
              pharmaResponse.data['data'].isNotEmpty) {
            pharmaServices =
                List<Map<String, dynamic>>.from(pharmaResponse.data['data']);
          } else {
            // Default pharma services
            pharmaServices = [
              {
                'id': 1,
                'title':
                    'Analyze patient physiological data,\ninitial drug treatment plan, and patient treatment response',
                'price': 10.0
              },
              {
                'id': 2,
                'title':
                    'Analyze specific treatment problems:\npoor response to treatment;poor\npatient medication compliance;\ndrug side effect; drug interactions',
                'price': 10.0
              },
              {
                'id': 3,
                'title':
                    'Drug therapy adjustment made to\nphysicians by the pharmacist when\nappropriate',
                'price': 10.0
              },
              {'id': 4, 'title': 'Diet History & Evaluations', 'price': 10.0},
              {
                'id': 5,
                'title':
                    'Follow-up the therapy and ensure\npositive outcomes and reduces adverse effects',
                'price': 10.0
              },
            ];
          }

          if (nurseResponse.data['data'] != null &&
              nurseResponse.data['data'].isNotEmpty) {
            nurseServices =
                List<Map<String, dynamic>>.from(nurseResponse.data['data']);
          } else {
            // Default nurse services
            nurseServices = [
              {'id': 1, 'title': 'Medical Escort', 'price': 10.0},
              {'id': 2, 'title': 'Inject', 'price': 10.0},
              {'id': 3, 'title': 'Blood Glucose Check', 'price': 10.0},
              {'id': 4, 'title': 'Medication Administration', 'price': 10.0},
              {'id': 5, 'title': 'NGT Feeding', 'price': 10.0},
              {'id': 6, 'title': 'Oral Suctioning', 'price': 10.0},
              {'id': 7, 'title': 'PEG Feeding', 'price': 10.0},
              {'id': 8, 'title': 'Stoma Bag Drainage', 'price': 10.0},
              {'id': 9, 'title': 'Tracheostomy Suctioning', 'price': 10.0},
              {'id': 10, 'title': 'Urine Bag Drainage', 'price': 10.0},
            ];
          }

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load service titles';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _saveServiceTitles(String serviceType) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final serviceData =
          serviceType == 'pharma' ? pharmaServices : nurseServices;

      // Add service_type to each item
      final servicesWithType = serviceData
          .map((service) => {...service, 'service_type': serviceType})
          .toList();

      final response = await Dio().put(
        '${Const.URL_API}/service-titles/$serviceType',
        data: {'services': servicesWithType}, // Ensure correct structure
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Update the UI with the latest data from the backend
        final updatedServices =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          if (serviceType == 'pharma') {
            pharmaServices = updatedServices;
          } else {
            nurseServices = updatedServices;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$serviceType service titles updated successfully'),
          ),
        );
      } else {
        throw Exception('Failed to update service titles');
      }
    } catch (e) {
      print('Error updating service titles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating service titles: $e')),
      );
    }
  }

  // void _addNewService(String serviceType) {
  //   setState(() {
  //     if (serviceType == 'pharma') {
  //       pharmaServices.add({
  //         'id': pharmaServices.isEmpty ? 1 : pharmaServices.last['id'] + 1,
  //         'title': '',
  //         'price': 10.0,
  //       });
  //     } else {
  //       nurseServices.add({
  //         'id': nurseServices.isEmpty ? 1 : nurseServices.last['id'] + 1,
  //         'title': '',
  //         'price': 10.0,
  //       });
  //     }
  //   });
  // }

  void _addNewService(String serviceType) {
    setState(() {
      if (serviceType == 'pharma') {
        pharmaServices.add({
          'title': '', // Default empty title
          'price': 10.0, // Default price
        });
      } else {
        nurseServices.add({
          'title': '', // Default empty title
          'price': 10.0, // Default price
        });
      }
    });
  }

  void _removeService(String serviceType, int index) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final serviceData =
          serviceType == 'pharma' ? pharmaServices : nurseServices;

      // Check if the service has an ID (i.e., it exists on the server)
      final serviceId = serviceData[index]['id'];
      if (serviceId != null) {
        // Send DELETE request to the backend
        final response = await Dio().delete(
          '${Const.URL_API}/service-titles/$serviceId', // Correct URL
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          // Remove the service from the local list
          setState(() {
            serviceData.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Service removed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Failed to remove service');
        }
      } else {
        // If the service doesn't have an ID, just remove it locally
        setState(() {
          serviceData.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Service removed locally'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error removing service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Service Titles',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pharmacist Services'),
            Tab(text: 'Nurse Services'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Pharmacist Services Tab
                    _buildServiceList(
                      'pharma',
                      pharmaServices,
                      (index, value) {
                        setState(() {
                          pharmaServices[index]['title'] = value;
                        });
                      },
                      (index, value) {
                        setState(() {
                          pharmaServices[index]['price'] =
                              double.tryParse(value) ?? 10.0;
                        });
                      },
                    ),

                    // Nurse Services Tab
                    _buildServiceList(
                      'nurse',
                      nurseServices,
                      (index, value) {
                        setState(() {
                          nurseServices[index]['title'] = value;
                        });
                      },
                      (index, value) {
                        setState(() {
                          nurseServices[index]['price'] =
                              double.tryParse(value) ?? 10.0;
                        });
                      },
                    ),
                  ],
                ),
    );
  }

  Widget _buildServiceList(
    String serviceType,
    List<Map<String, dynamic>> services,
    Function(int, String) onTitleChanged,
    Function(int, String) onPriceChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: services[index]['title'],
                            decoration: const InputDecoration(
                              labelText: 'Service Title',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: null,
                            onChanged: (value) => onTitleChanged(index, value),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: services[index]['price'].toString(),
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixText: '\$',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => onPriceChanged(index, value),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeService(serviceType, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _addNewService(serviceType),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35C5CF),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _saveServiceTitles(serviceType),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
