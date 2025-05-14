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
              // Title Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Title: ${personalCase['title']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Description Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Description: ${personalCase['description']}'),
                ),
              ),

              // Mobility Status Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Mobility Status: ${personalCase['mobility_status']}'),
                ),
              ),

              // Add-On Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Add-On: ${personalCase['add_on']}'),
                ),
              ),

              // Estimated Budget Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Estimated Budget: \$${personalCase['estimated_budget']}',
                  ),
                ),
              ),

              // Created At Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Created At: ${personalCase['created_at']}'),
                ),
              ),

              // Updated At Card
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Updated At: ${personalCase['updated_at']}'),
                ),
              ),

              // Related Health Record Section
              if (relatedHealthRecord != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Related Health Record:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${relatedHealthRecord['title']}'),
                        Text(
                            'Disease Name: ${relatedHealthRecord['disease_name']}'),
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
                    ),
                  ),
                ),
              ],

              // Images Grid
              if (personalCase['images'] != null &&
                  personalCase['images'].isNotEmpty)
                const SizedBox(height: 16),
              const Text(
                'Images:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 images per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: personalCase['images'].length,
                itemBuilder: (context, index) {
                  final imageUrl = personalCase['images'][index];
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                },
              ),
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
