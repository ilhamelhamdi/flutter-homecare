import 'dart:io';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/profile_details/medical_record.dart';
import 'package:m2health/cubit/profiles/profile_details/pharmagenomical.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/views/appointment.dart';
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PharmagenomicsProfilePage(),
                          ),
                        );
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
