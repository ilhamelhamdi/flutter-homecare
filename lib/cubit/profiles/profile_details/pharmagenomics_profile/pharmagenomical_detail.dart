import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:file_picker/file_picker.dart';

class PharmagenomicsDetailPage extends StatelessWidget {
  final Pharmacogenomics pharmacogenomics;

  const PharmagenomicsDetailPage({Key? key, required this.pharmacogenomics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pharmacogenomics.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, pharmacogenomics),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, pharmacogenomics.id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('ID', pharmacogenomics.id.toString()),
                const SizedBox(height: 8),
                _buildDetailRow('Title', pharmacogenomics.title),
                const SizedBox(height: 8),
                _buildDetailRow(
                    'Description', pharmacogenomics.description ?? 'N/A'),
                const Divider(height: 20, color: Colors.grey),
                const Text(
                  'File',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (pharmacogenomics.fileUrl != null)
                  InkWell(
                    onTap: () {
                      // TODO: Implement file viewing/downloading
                    },
                    child: Text(
                      pharmacogenomics.fileUrl!.split('/').last,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  )
                else
                  const Text('No file attached',
                      style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, Pharmacogenomics item) {
    final TextEditingController titleController =
        TextEditingController(text: item.title);
    final TextEditingController descriptionController =
        TextEditingController(text: item.description);
    File? pickedFile;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      pickedFile = File(result.files.single.path!);
                    }
                  },
                  child: const Text('Change File (Optional)'),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PharmacogenomicsCubit>().update(
                      item.id,
                      titleController.text,
                      descriptionController.text,
                      pickedFile,
                    );
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PharmacogenomicsCubit>().delete(id);
                Navigator.pop(dialogContext);
                Navigator.pop(context); // Go back to the list page
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
