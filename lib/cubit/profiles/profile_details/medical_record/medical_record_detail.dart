import 'package:flutter/material.dart';

class MedicalRecordDetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const MedicalRecordDetailPage({Key? key, required this.record})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          record['title'] ?? 'Medical Record',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: 'Patient Current Status',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Disease Name', record['disease_name']),
                  _buildRow('Disease History', record['disease_history']),
                ],
              ),
            ),
            _buildCard(
              title: 'Symptoms',
              content: Text(record['symptoms'] ?? 'No symptoms provided'),
            ),
            _buildCard(
              title: 'Patient with Special Consideration',
              content: Text(record['special_consideration'] ?? 'None'),
            ),
            if (record['file_url'] != null)
              _buildCard(
                title: 'Records File',
                content: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Handle view file
                      },
                      child: const Text('View Only'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle download file
                      },
                      child: const Text('Download'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          value ?? 'Not specified',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
