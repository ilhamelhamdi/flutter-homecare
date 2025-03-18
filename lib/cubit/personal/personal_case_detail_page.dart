import 'package:flutter/material.dart';

class PersonalCaseDetailPage extends StatelessWidget {
  final Map<String, dynamic> personalCase;

  const PersonalCaseDetailPage({Key? key, required this.personalCase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final relatedHealthRecord = personalCase['relatedHealthRecord'];

    return Scaffold(
      appBar: AppBar(
        title: Text(personalCase['title'] ?? 'Personal Case Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: ${personalCase['title']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Description: ${personalCase['description']}'),
              const SizedBox(height: 8),
              Text('Mobility Status: ${personalCase['mobility_status']}'),
              const SizedBox(height: 8),
              Text('Add-On: ${personalCase['add_on']}'),
              const SizedBox(height: 8),
              Text('Estimated Budget: \$${personalCase['estimated_budget']}'),
              const SizedBox(height: 8),
              Text('Created At: ${personalCase['created_at']}'),
              const SizedBox(height: 8),
              Text('Updated At: ${personalCase['updated_at']}'),
              const SizedBox(height: 16),
              if (relatedHealthRecord != null) ...[
                const Text(
                  'Related Health Record:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Title: ${relatedHealthRecord['title']}'),
                Text('Disease Name: ${relatedHealthRecord['disease_name']}'),
                Text(
                    'Disease History: ${relatedHealthRecord['disease_history']}'),
                Text('Symptoms: ${relatedHealthRecord['symptoms']}'),
                Text(
                    'Special Consideration: ${relatedHealthRecord['special_consideration']}'),
                Text(
                    'Treatment Info: ${relatedHealthRecord['treatment_info']}'),
                const SizedBox(height: 8),
                if (relatedHealthRecord['file_url'] != null)
                  GestureDetector(
                    onTap: () {
                      // Handle file viewing
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewerScreen(
                            url: relatedHealthRecord['file_url'],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View File',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FileViewerScreen extends StatelessWidget {
  final String url;

  const FileViewerScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Viewer'),
      ),
      body: Center(
        child: Text('Display file from: $url'),
      ),
    );
  }
}
