import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';

class GeneDetailPage extends StatefulWidget {
  final int id;
  final String gene;
  final String genotype;
  final String phenotype;
  final String medicationGuidance;

  const GeneDetailPage({
    Key? key,
    required this.id,
    required this.gene,
    required this.genotype,
    required this.phenotype,
    required this.medicationGuidance,
  }) : super(key: key);

  @override
  _GeneDetailPageState createState() => _GeneDetailPageState();
}

class _GeneDetailPageState extends State<GeneDetailPage> {
  late String gene;
  late String genotype;
  late String phenotype;
  late String medicationGuidance;

  @override
  void initState() {
    super.initState();
    gene = widget.gene;
    genotype = widget.genotype;
    phenotype = widget.phenotype;
    medicationGuidance = widget.medicationGuidance;
  }

  void _editDetails() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController geneController =
            TextEditingController(text: gene);
        final TextEditingController genotypeController =
            TextEditingController(text: genotype);
        final TextEditingController phenotypeController =
            TextEditingController(text: phenotype);
        final TextEditingController guidanceController =
            TextEditingController(text: medicationGuidance);

        return AlertDialog(
          title: const Text('Edit Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: geneController,
                  decoration: const InputDecoration(labelText: 'Gene'),
                ),
                TextField(
                  controller: genotypeController,
                  decoration: const InputDecoration(labelText: 'Genotype'),
                ),
                TextField(
                  controller: phenotypeController,
                  decoration: const InputDecoration(labelText: 'Phenotype'),
                ),
                TextField(
                  controller: guidanceController,
                  decoration:
                      const InputDecoration(labelText: 'Medication Guidance'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            // TextButton(
            //   onPressed: () async {
            //     // Call Cubit update
            //     await context.read<PharmacogenomicsCubit>().update(
            //           widget.id,
            //           geneController.text,
            //           genotypeController.text,
            //           phenotypeController.text,
            //           guidanceController.text,
            //           null, // No file update in this dialog
            //         );
            //     setState(() {
            //       gene = geneController.text;
            //       genotype = genotypeController.text;
            //       phenotype = phenotypeController.text;
            //       medicationGuidance = guidanceController.text;
            //     });
            //     Navigator.pop(context);
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Details updated')),
            //     );
            //   },
            //   child: const Text('Save'),
            // ),
          ],
        );
      },
    );
  }

  void _deleteDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Details'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<PharmacogenomicsCubit>().delete(widget.id);
                Navigator.pop(context);
                Navigator.pop(context); // Go back to the previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Record deleted')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          gene,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            // Gene Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Gene', gene),
                        const SizedBox(height: 8),
                        _buildDetailRow('Genotype', genotype),
                        const SizedBox(height: 8),
                        _buildDetailRow('Phenotype', phenotype),
                        const Divider(height: 20, color: Colors.grey),
                        const Text(
                          'Medication Guidance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          medicationGuidance,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _editDetails,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _deleteDetails,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
