import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PharmagenomicsProfilePage extends StatefulWidget {
  @override
  _PharmagenomicsProfilePageState createState() =>
      _PharmagenomicsProfilePageState();
}

class _PharmagenomicsProfilePageState extends State<PharmagenomicsProfilePage> {
  final List<Map<String, String>> _data = [
    {'gene': 'Gene1', 'genotype': 'Genotype1', 'phenotype': 'Phenotype1'},
    {'gene': 'Gene2', 'genotype': 'Genotype2', 'phenotype': 'Phenotype2'},
    {'gene': 'Gene3', 'genotype': 'Genotype3', 'phenotype': 'Phenotype3'},
    {'gene': 'Gene4', 'genotype': 'Genotype4', 'phenotype': 'Phenotype4'},
  ];

  String? _pdfFileName;

  void _editProfile(Map<String, String> profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPharmagenomicsProfilePage(profile: profile),
      ),
    );
  }

  void _addNewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPharmagenomicsProfilePage(
          onAdd: (newProfile) {
            setState(() {
              _data.add(newProfile);
            });
          },
        ),
      ),
    );
  }

  void _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFileName = result.files.single.name;
      });
    }
  }

  void _removePdf() {
    setState(() {
      _pdfFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmagenomics Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final profile = _data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileRow('Gene', profile['gene']!),
                          const SizedBox(height: 8),
                          _buildProfileRow('Genotype', profile['genotype']!),
                          const SizedBox(height: 8),
                          _buildProfileRow('Phenotype', profile['phenotype']!),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => _editProfile(profile),
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full PDF Report',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _pdfFileName ?? 'No PDF uploaded',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: _pickPdf,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: _removePdf,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProfile,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class EditPharmagenomicsProfilePage extends StatefulWidget {
  final Map<String, String> profile;

  EditPharmagenomicsProfilePage({required this.profile});

  @override
  _EditPharmagenomicsProfilePageState createState() =>
      _EditPharmagenomicsProfilePageState();
}

class _EditPharmagenomicsProfilePageState
    extends State<EditPharmagenomicsProfilePage> {
  late TextEditingController _geneController;
  late TextEditingController _genotypeController;
  late TextEditingController _phenotypeController;

  @override
  void initState() {
    super.initState();
    _geneController = TextEditingController(text: widget.profile['gene']);
    _genotypeController =
        TextEditingController(text: widget.profile['genotype']);
    _phenotypeController =
        TextEditingController(text: widget.profile['phenotype']);
  }

  @override
  void dispose() {
    _geneController.dispose();
    _genotypeController.dispose();
    _phenotypeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      widget.profile['gene'] = _geneController.text;
      widget.profile['genotype'] = _genotypeController.text;
      widget.profile['phenotype'] = _phenotypeController.text;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pharmagenomics Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField('Gene', _geneController),
            const SizedBox(height: 16),
            _buildInputField('Genotype', _genotypeController),
            const SizedBox(height: 16),
            _buildInputField('Phenotype', _phenotypeController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class AddPharmagenomicsProfilePage extends StatefulWidget {
  final Function(Map<String, String>) onAdd;

  AddPharmagenomicsProfilePage({required this.onAdd});

  @override
  _AddPharmagenomicsProfilePageState createState() =>
      _AddPharmagenomicsProfilePageState();
}

class _AddPharmagenomicsProfilePageState
    extends State<AddPharmagenomicsProfilePage> {
  final TextEditingController _geneController = TextEditingController();
  final TextEditingController _genotypeController = TextEditingController();
  final TextEditingController _phenotypeController = TextEditingController();
  final TextEditingController _medicationGuidanceController =
      TextEditingController();

  void _addProfile() {
    final newProfile = {
      'gene': _geneController.text,
      'genotype': _genotypeController.text,
      'phenotype': _phenotypeController.text,
    };
    widget.onAdd(newProfile);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _geneController.dispose();
    _genotypeController.dispose();
    _phenotypeController.dispose();
    _medicationGuidanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Pharmagenomics Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _geneController,
              decoration: const InputDecoration(labelText: 'Gene'),
            ),
            TextField(
              controller: _genotypeController,
              decoration: const InputDecoration(labelText: 'Genotype'),
            ),
            TextField(
              controller: _phenotypeController,
              decoration: const InputDecoration(labelText: 'Phenotype'),
            ),
            TextField(
              controller: _medicationGuidanceController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Medication Guidance',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addProfile,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
