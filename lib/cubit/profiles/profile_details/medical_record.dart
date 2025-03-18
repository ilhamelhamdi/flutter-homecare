import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MedicalRecordsPage extends StatefulWidget {
  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  List<Map<String, dynamic>> records = [];
  int? _editingIndex;
  bool _isAddingNewRecord = false;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _diseaseHistoryController =
      TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _specialConsiderationController =
      TextEditingController();
  final TextEditingController _treatmentInfoController =
      TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _fetchMedicalRecords();
  }

  Future<void> _fetchMedicalRecords() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().get(
        Const.API_MEDICAL_RECORDS,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          records = List<Map<String, dynamic>>.from(response.data['data']);
        });
      } else {
        throw Exception('Failed to fetch medical records');
      }
    } catch (e) {
      print('Error fetching medical records: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitRecord() async {
    // Validate mandatory fields first
    if (_titleController.text.trim().isEmpty ||
        _diseaseNameController.text.trim().isEmpty ||
        _diseaseHistoryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title, Disease Name and Disease History are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);
      final filePath = _selectedFile?.path.replaceAll(r'\', '/');

      // Only include non-empty fields in the form data
      Map<String, dynamic> formFields = {
        'title': _titleController.text,
        'disease_name': _diseaseNameController.text,
        'disease_history': _diseaseHistoryController.text,
      };

      // Add optional fields only if they have content
      if (_symptomsController.text.isNotEmpty) {
        formFields['symptoms'] = _symptomsController.text;
      }

      if (_specialConsiderationController.text.isNotEmpty) {
        formFields['special_consideration'] =
            _specialConsiderationController.text;
      }

      if (_treatmentInfoController.text.isNotEmpty) {
        formFields['treatment_info'] = _treatmentInfoController.text;
      }

      // Add file if selected
      if (_selectedFile != null) {
        formFields['file_url'] = await MultipartFile.fromFile(
          filePath!,
          filename: _selectedFile!.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(formFields);

      final response = await Dio().post(
        Const.API_MEDICAL_RECORDS,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Medical record submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchMedicalRecords();
        _clearForm();
      } else {
        throw Exception('Failed to submit medical record');
      }
    } catch (e) {
      print('Error submitting medical record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting medical record: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteRecord(int recordId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().delete(
        '${Const.API_MEDICAL_RECORDS}/$recordId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Medical record deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchMedicalRecords();
      } else {
        throw Exception('Failed to delete medical record');
      }
    } catch (e) {
      print('Error deleting medical record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting medical record: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _diseaseNameController.clear();
    _diseaseHistoryController.clear();
    _symptomsController.clear();
    _specialConsiderationController.clear();
    _treatmentInfoController.clear();
    _selectedFile = null;
    _isAddingNewRecord = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: records.length + (_isAddingNewRecord ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isAddingNewRecord && index == records.length) {
                        return _buildForm();
                      }
                      final record = records[index];
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.black,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(record['title']),
                          subtitle:
                              Text('Last updated: ${record['updated_at']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicalRecordDetailPage(record: record),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteRecord(record['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isAddingNewRecord = true;
                      });
                    },
                    child: Text('Add Medical Record'),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _isAddingNewRecord
          ? BottomAppBar(
              child: ElevatedButton(
                onPressed: _submitRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca, // Warna tosca
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            )
          : null,
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Patient Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter record title',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _diseaseNameController,
              decoration: const InputDecoration(
                labelText: 'Disease Name *',
                hintText: 'Enter disease name',
              ),
            ),
            const SizedBox(height: 8),
            const Text('Disease History Description *'),
            TextField(
              controller: _diseaseHistoryController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter disease history (required)',
              ),
            ),
            const SizedBox(height: 8),
            const Text('Symptoms (Optional)'),
            TextField(
              controller: _symptomsController,
              maxLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            const Text('Special Consideration (Optional)'),
            TextField(
              controller: _specialConsiderationController,
              maxLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            const Text('Treatment Information (Optional)'),
            TextField(
              controller: _treatmentInfoController,
              maxLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('File (PDF/Image) (Optional)'),
                ElevatedButton(
                  onPressed: _pickFile,
                  child: const Text('Pick File'),
                ),
              ],
            ),
            if (_selectedFile != null)
              Text('Selected file: ${_selectedFile!.path.split('/').last}'),
            const SizedBox(height: 8),
            const Text(
              '* Required fields',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Current Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Disease name: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      record['disease_name'] ?? 'Not specified',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Disease history: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      record['disease_history'] ?? 'Not specified',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              // Only show symptoms if not null
              if (record['symptoms'] != null) ...[
                const SizedBox(height: 20),
                Text(
                  'My Symptoms of ${record['disease_name']} include:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  record['symptoms'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ],

              // Only show special consideration if not null
              if (record['special_consideration'] != null) ...[
                const SizedBox(height: 20),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient With\nSpecial\nConsideration: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        'Kidney Disease',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],

              // Only show treatment info if not null
              if (record['treatment_info'] != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'Treatment Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  record['treatment_info'] ?? 'None provided',
                  style: const TextStyle(fontSize: 16),
                ),
              ],

              // Show file URL if available
              if (record['file_url'] != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'File URL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FileViewerScreen(url: record['file_url']),
                      ),
                    );
                  },
                  child: Text(
                    record['file_url'],
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
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

class FileViewerScreen extends StatefulWidget {
  final String? path; // For local files
  final String? url; // For remote files

  FileViewerScreen({this.path, this.url});

  @override
  _FileViewerScreenState createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  late Future<Uint8List> _fileBytesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      // Download file from URL
      _fileBytesFuture = _downloadFile(widget.url!);
    } else if (widget.path != null) {
      // Load file from local path
      _fileBytesFuture = _loadLocalFile(widget.path!);
    } else {
      throw Exception("No file source provided.");
    }
  }

  Future<Uint8List> _downloadFile(String url) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  Future<Uint8List> _loadLocalFile(String path) async {
    File file = File(path);
    return await file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Preview'),
      ),
      body: FutureBuilder<Uint8List>(
        future: _fileBytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final fileBytes = snapshot.data!;
              if (widget.url != null && widget.url!.endsWith('.pdf') ||
                  widget.path != null && widget.path!.endsWith('.pdf')) {
                return SfPdfViewer.memory(fileBytes);
              } else {
                return Center(
                  child: Image.memory(fileBytes),
                );
              }
            } else {
              return Center(child: Text('Failed to load file'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
