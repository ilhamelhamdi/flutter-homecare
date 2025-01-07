import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_homecare/const.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'package:flutter_homecare/views/appointment.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Health Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/icons/ic_avatar.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anna Bella',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Last updated:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '14 June 2024',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Records',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.medical_services,
                        color: Color(0xFF35C5CF),
                      ),
                      title: const Text('Medical Records'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicalRecordsPage()),
                        );
                        // Handle Medical Records tap
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.biotech, color: Color(0xFF35C5CF)),
                      title: const Text('Lab Reports'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Lab Reports tap
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.radio, color: Color(0xFF35C5CF)),
                      title: const Text('Radiology Reports'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Radiology Reports tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.health_and_safety,
                          color: Color(0xFF35C5CF)),
                      title: const Text('Health Screening'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Health Screening tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_pharmacy,
                          color: Color(0xFF35C5CF)),
                      title: const Text('Pharmagenomics Profile'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Pharma Profile tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_pharmacy,
                          color: Color(0xFF35C5CF)),
                      title: const Text('Wellness Genomics Profile'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Pharma Profile tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today,
                          color: Color(0xFF35C5CF)),
                      title: const Text('All My Appointments'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Age: 35 | Weight: 55 KG | Height: 155 cm'),
                  SizedBox(height: 8),
                  Text('Phone Number: +6232433'),
                  SizedBox(height: 8),
                  Text('Home Address (Primary):'),
                  Text('7 Nassim Road Lodge, Singapore'),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Perform logout logic here (e.g., clearing user session)
                  GoRouter.of(context).go(AppRoutes.signIn);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalRecordsPage extends StatefulWidget {
  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  List<String> records = [
    'Arboviral Encephalitis',
    'Dengue Fever',
    'Malaria',
    'Tuberculosis',
    'Hepatitis B',
    'Influenza',
    'COVID-19'
  ];

  int? _editingIndex;
  TextEditingController _diseaseNameController = TextEditingController();
  TextEditingController _diseaseHistoryController = TextEditingController();
  List<bool> _specialConsiderations = List.generate(6, (_) => false);

  void _modifyRecord(int index) {
    setState(() {
      _editingIndex = index;
      _diseaseNameController.text = records[index];
      _diseaseHistoryController.clear();
      _specialConsiderations = List.generate(6, (_) => false);
    });
  }

  void _removeRecord(int index) {
    setState(() {
      records.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
      }
    });
  }

  void _submitModification() {
    setState(() {
      if (_editingIndex != null) {
        records[_editingIndex!] = _diseaseNameController.text;
        _editingIndex = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length + (_editingIndex != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (_editingIndex != null && index == _editingIndex! + 1) {
            return _buildModifyForm();
          }
          int recordIndex = _editingIndex != null && index > _editingIndex!
              ? index - 1
              : index;
          return Card(
            elevation: 4,
            shadowColor: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(records[recordIndex]),
              subtitle: const Text('Last updated: 08-09-2024'),
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Modify') {
                    _modifyRecord(recordIndex);
                  } else if (value == 'Remove') {
                    _removeRecord(recordIndex);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Modify', 'Remove'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new record
          _submitModification;
        },
        backgroundColor: Const.tosca,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: _editingIndex != null
          ? BottomAppBar(
              child: ElevatedButton(
                onPressed: _submitModification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca, // Warna tosca
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            )
          : null,
    );
  }

  Widget _buildModifyForm() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Patient Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            TextField(
              controller: _diseaseNameController,
              decoration: const InputDecoration(labelText: 'Disease Name'),
            ),
            const SizedBox(height: 8),
            const Text('Disease History Description'),
            TextField(
              controller: _diseaseHistoryController,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            const Text('Patient with Special Consideration'),
            Wrap(
              spacing: 8.0,
              children: List.generate(6, (index) {
                return FilterChip(
                  label: Text('Consideration ${index + 1}'),
                  selected: _specialConsiderations[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _specialConsiderations[index] = selected;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Treatment Information'),
                ElevatedButton(
                  onPressed: () {
                    // Handle add treatment information
                  },
                  child: const Text('+ Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  int _age = 0;
  double _weight = 0.0;
  double _height = 0.0;
  String _contactNumber = '';
  String _homeAddress = '';
  String _drugAllergy = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Information',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _age = int.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Weight (KG)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _weight = double.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Height (CM)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _height = double.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _contactNumber = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) {
                    _homeAddress = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 156,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Drug Allergy Statuses',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) {
                    _drugAllergy = value!;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40E0D0), // Warna biru tosca
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
