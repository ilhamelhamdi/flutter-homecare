import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:m2health/cubit/profiles/profile_details/pharmagenomics_profile/pharmagenomical_detail.dart';

class PharmagenomicsProfilePage extends StatefulWidget {
  @override
  _PharmagenomicsProfilePageState createState() =>
      _PharmagenomicsProfilePageState();
}

class _PharmagenomicsProfilePageState extends State<PharmagenomicsProfilePage> {
  final List<PharmagenomicsProfile> _profiles = [
    PharmagenomicsProfile(
        gene: 'Clopidogrel', genotype: 'Genotype1', phenotype: 'Phenotype1'),
    PharmagenomicsProfile(
        gene: 'Codeine', genotype: 'Genotype2', phenotype: 'Phenotype2'),
    PharmagenomicsProfile(
        gene: 'Warfarin', genotype: 'Genotype3', phenotype: 'Phenotype3'),
    PharmagenomicsProfile(
        gene: 'Simvastatin', genotype: 'Genotype4', phenotype: 'Phenotype4'),
    PharmagenomicsProfile(
        gene: 'Abacavir', genotype: 'Genotype5', phenotype: 'Phenotype5'),
  ];

  String? _uploadedFileName;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  void _removeFile() {
    setState(() {
      _uploadedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmagenomic Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Profiles
            Expanded(
              child: ListView.builder(
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  final profile = _profiles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        profile.gene,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneDetailPage(
                              gene: profile.gene,
                              genotype: profile.genotype,
                              phenotype: profile.phenotype,
                              medicationGuidance:
                                  'Sample medication guidance for ${profile.gene}', // Replace with actual data
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Upload Full Report Section
            const Text(
              'Upload Full Report',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _uploadedFileName ?? 'Choose File',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Choose File'),
                ),
              ],
            ),
            if (_uploadedFileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '$_uploadedFileName uploaded',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Model for Pharmagenomics Profile
class PharmagenomicsProfile {
  final String gene;
  final String genotype;
  final String phenotype;

  PharmagenomicsProfile({
    required this.gene,
    required this.genotype,
    required this.phenotype,
  });
}
