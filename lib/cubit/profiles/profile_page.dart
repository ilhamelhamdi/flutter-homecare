import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
                SizedBox(width: 16),
                Column(
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
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Records',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.medical_services,
                        color: Color(0xFF35C5CF),
                      ),
                      title: Text('Medical Records'),
                      trailing: Icon(
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
                      leading: Icon(Icons.biotech, color: Color(0xFF35C5CF)),
                      title: Text('Lab Reports'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Lab Reports tap
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.radio, color: Color(0xFF35C5CF)),
                      title: Text('Radiology Reports'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Radiology Reports tap
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.health_and_safety,
                          color: Color(0xFF35C5CF)),
                      title: Text('Health Screening'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Health Screening tap
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.local_pharmacy, color: Color(0xFF35C5CF)),
                      title: Text('Pharma Profile'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Pharma Profile tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.calendar_today, color: Color(0xFF35C5CF)),
                      title: Text('All My Appointments'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {
                        // Handle All My Appointments tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit profile information
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Age: 35 | Weight: 55 KG | Height: 155 cm'),
            SizedBox(height: 8),
            Text('Phone Number: +6232433'),
            SizedBox(height: 8),
            Text('Home Address (Primary):'),
            Text('7 Nassim Road Lodge, Singapore'),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // Handle logout
              },
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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

  void _modifyRecord(int index) {
    // Handle modify record
  }

  void _removeRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shadowColor: Colors.grey,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(records[index]),
              subtitle: Text('Last updated: 08-09-2024'),
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Modify') {
                    _modifyRecord(index);
                  } else if (value == 'Remove') {
                    _removeRecord(index);
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
