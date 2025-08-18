import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/pharmagenomical_detail.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_state.dart';

class PharmagenomicsProfilePage extends StatefulWidget {
  @override
  _PharmagenomicsProfilePageState createState() =>
      _PharmagenomicsProfilePageState();
}

class _PharmagenomicsProfilePageState extends State<PharmagenomicsProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PharmacogenomicsCubit>().fetchPharmacogenomics();
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
            Expanded(
              child: BlocBuilder<PharmacogenomicsCubit, PharmacogenomicsState>(
                builder: (context, state) {
                  if (state is PharmacogenomicsLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is PharmacogenomicsLoaded) {
                    final items = state.pharmacogenomics;
                    if (items.isEmpty) {
                      return Center(child: Text('No pharmacogenomics data.'));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              item.gene,
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              'Genotype: ${item.genotype}\nPhenotype: ${item.phenotype}\nGuidance: ${item.medicationGuidance}\nFile: ${item.fullReportPath ?? '-'}',
                            ),
                            trailing: item.fullReportPath != null
                                ? Icon(Icons.file_present)
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GeneDetailPage(
                                    id: item.id,
                                    gene: item.gene,
                                    genotype: item.genotype,
                                    phenotype: item.phenotype,
                                    medicationGuidance: item.medicationGuidance,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  if (state is PharmacogenomicsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Center(child: Text('No pharmacogenomics data.'));
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Pharmacogenomics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    isScrollControlled: true,
                    builder: (ctx) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                        ),
                        child: _PharmacogenomicsFormModal(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmacogenomicsFormModal extends StatefulWidget {
  @override
  State<_PharmacogenomicsFormModal> createState() =>
      _PharmacogenomicsFormModalState();
}

class _PharmacogenomicsFormModalState
    extends State<_PharmacogenomicsFormModal> {
  final TextEditingController _geneController = TextEditingController();
  final TextEditingController _genotypeController = TextEditingController();
  final TextEditingController _phenotypeController = TextEditingController();
  final TextEditingController _medicationGuidanceController =
      TextEditingController();

  File? _selectedFile;
  String? _uploadedFileName;
  bool _loading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _uploadedFileName = null;
    });
  }

  Future<void> _saveReport() async {
    if (_geneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gene cannot be empty")),
      );
      return;
    }
    setState(() => _loading = true);

    final gene = _geneController.text;
    final genotype = _genotypeController.text;
    final phenotype = _phenotypeController.text;
    final medicationGuidance = _medicationGuidanceController.text;
    final fullReportPath = _selectedFile ?? File('');

    await context.read<PharmacogenomicsCubit>().create(
          gene,
          genotype,
          phenotype,
          medicationGuidance,
          fullReportPath,
        );

    await context.read<PharmacogenomicsCubit>().fetchPharmacogenomics();

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Report submitted")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
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
                child: const Text('Choose File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
              if (_uploadedFileName != null)
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _removeFile,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _geneController,
            decoration: const InputDecoration(
              hintText: 'Gene',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _genotypeController,
            decoration: const InputDecoration(
              hintText: 'Genotype',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phenotypeController,
            decoration: const InputDecoration(
              hintText: 'Phenotype',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _medicationGuidanceController,
            decoration: const InputDecoration(
              hintText: 'Medication Guidance',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _saveReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text(
                      'Save',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
