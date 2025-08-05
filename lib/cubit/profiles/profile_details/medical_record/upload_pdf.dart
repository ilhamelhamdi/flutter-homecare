import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'dart:io';
import 'dart:typed_data';

class UploadPDFPage extends StatefulWidget {
  @override
  _UploadPDFPageState createState() => _UploadPDFPageState();
}

class _UploadPDFPageState extends State<UploadPDFPage> {
  List<File> _pdfFiles = [];
  List<Map<String, dynamic>> _uploadedFiles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUploadedFiles();
  }

  Future<void> _fetchUploadedFiles() async {
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
          _uploadedFiles =
              List<Map<String, dynamic>>.from(response.data['data']);
        });
      } else {
        throw Exception('Failed to fetch uploaded files');
      }
    } catch (e) {
      print('Error fetching uploaded files: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfFiles.add(File(result.files.single.path!));
      });
    }
  }

  Future<void> _uploadPDF(File file) async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);

      // Convert the file path to a format that Dio can handle
      final filePath = file.path.replaceAll(r'\', '/');

      FormData formData = FormData.fromMap({
        'title': 'Medical Record Title',
        'disease_name': 'Disease Name',
        'disease_history': 'Disease History',
        'symptoms': 'Symptoms',
        'special_consideration': 'Special Consideration',
        'treatment_info': '0',
        'file_url': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      print('Uploading PDF with data: ${formData.fields}');
      print('File being uploaded: $filePath');

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

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _pdfFiles.remove(file);
          _fetchUploadedFiles(); // Refresh the list of uploaded files
        });

        // Check if file_url is present in the response
        if (response.data['data'] != null &&
            response.data['data']['file_url'] != null) {
          print('File URL: ${response.data['data']['file_url']}');
          // Store the file URL in medical records
          await _storeFileUrl(response.data['data']['file_url']);
        } else {
          print('File URL is null');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File URL is null'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found. Please check the URL.');
      } else {
        throw Exception(
          'Failed to upload PDF. Status: ${response.statusCode}, Message: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      print('DioError Type: ${e.type}');
      print('DioError Message: ${e.message}');
      print('DioError Response: ${e.response?.data}');

      String errorMessage = 'Error uploading PDF: ';

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage += 'Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage += 'Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage += 'Receive timeout';
          break;
        case DioExceptionType.badResponse:
          errorMessage +=
              'Server returned ${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Unknown error'}';
          break;
        case DioExceptionType.connectionError:
          errorMessage += 'Connection error';
          break;
        default:
          errorMessage += e.message ?? 'Unknown error occurred';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('General Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deletePDF(String fileId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().delete(
        '${Const.API_MEDICAL_RECORDS}/$fileId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchUploadedFiles(); // Refresh the list of uploaded files
      } else {
        throw Exception('Failed to delete PDF');
      }
    } catch (e) {
      print('Error deleting PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting PDF: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _storeFileUrl(String fileUrl) async {
    // Implement the logic to store the file URL in medical records
    // This could involve making another API call to save the file URL
    print('Storing file URL: $fileUrl');
  }

  void _previewPDF(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(path: file.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _pdfFiles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_pdfFiles[index].path.split('/').last),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.preview),
                              onPressed: () => _previewPDF(_pdfFiles[index]),
                            ),
                            IconButton(
                              icon: Icon(Icons.upload),
                              onPressed: () => _uploadPDF(_pdfFiles[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _pickPDF,
                    child: Text('Add PDF'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Uploaded PDFs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _uploadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _uploadedFiles[index];
                      return ListTile(
                        title: Text(file['title']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.preview),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PDFScreen(url: file['file_url']),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deletePDF(file['id']),
                            ),
                          ],
                        ),
                      );
                    },
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
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path; // For local files
  final String? url; // For remote files

  PDFScreen({this.path, this.url});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late Future<Uint8List> _pdfBytesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      // Download PDF from URL
      _pdfBytesFuture = _downloadPDF(widget.url!);
    } else if (widget.path != null) {
      // Load PDF from local file
      _pdfBytesFuture = _loadLocalPDF(widget.path!);
    } else {
      throw Exception("No PDF source provided.");
    }
  }

  Future<Uint8List> _downloadPDF(String url) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  Future<Uint8List> _loadLocalPDF(String path) async {
    File file = File(path);
    return await file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: FutureBuilder<Uint8List>(
        future: _pdfBytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SfPdfViewer.memory(snapshot.data!);
            } else {
              return Center(child: Text('Failed to load PDF'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
