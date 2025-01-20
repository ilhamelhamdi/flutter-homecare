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
        title: const Text('Pharmagenomics Profile'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final profile = _data[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gene: ${profile['gene']}'),
                        Text('Genotype: ${profile['genotype']}'),
                        Text('Phenotype: ${profile['phenotype']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editProfile(profile),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Full PDF Report',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _pdfFileName ?? 'No PDF uploaded',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _pickPdf();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _removePdf,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProfile,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
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
  late TextEditingController _medicationGuidanceController;

  @override
  void initState() {
    super.initState();
    _geneController = TextEditingController(text: widget.profile['gene']);
    _genotypeController =
        TextEditingController(text: widget.profile['genotype']);
    _phenotypeController =
        TextEditingController(text: widget.profile['phenotype']);
    _medicationGuidanceController =
        TextEditingController(text: 'Sample Medication Guidance');
  }

  @override
  void dispose() {
    _geneController.dispose();
    _genotypeController.dispose();
    _phenotypeController.dispose();
    _medicationGuidanceController.dispose();
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
              onPressed: _saveChanges,
              child: const Text('Save'),
            ),
          ],
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
