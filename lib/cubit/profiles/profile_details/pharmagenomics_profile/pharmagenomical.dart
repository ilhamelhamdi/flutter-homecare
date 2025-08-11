import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource_impl.dart';
import 'package:m2health/cubit/pharmacogenomics/data/repositories/pharmacogenomics_repository_impl.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/crud_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_state.dart';
import 'package:m2health/cubit/profiles/profile_details/pharmagenomics_profile/pharmagenomical_detail.dart';

class PharmagenomicsProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // This is a simplified DI. In a real app, use get_it or a proper DI solution.
        final Dio dio = Dio();
        final PharmacogenomicsRemoteDataSource remoteDataSource =
            PharmacogenomicsRemoteDataSourceImpl(dio: dio);
        final PharmacogenomicsRepository repository =
            PharmacogenomicsRepositoryImpl(remoteDataSource: remoteDataSource);
        return PharmacogenomicsCubit(
          getPharmacogenomics: GetPharmacogenomics(repository),
          createPharmacogenomic: CreatePharmacogenomic(repository),
          updatePharmacogenomic: UpdatePharmacogenomic(repository),
          deletePharmacogenomic: DeletePharmacogenomic(repository),
        )..fetchPharmacogenomics();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pharmagenomic Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:
                    BlocBuilder<PharmacogenomicsCubit, PharmacogenomicsState>(
                  builder: (context, state) {
                    if (state is PharmacogenomicsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PharmacogenomicsLoaded) {
                      if (state.pharmacogenomics.isEmpty) {
                        return const Center(child: Text('No records found.'));
                      }
                      return ListView.builder(
                        itemCount: state.pharmacogenomics.length,
                        itemBuilder: (context, index) {
                          final profile = state.pharmacogenomics[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                profile.title,
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value:
                                          context.read<PharmacogenomicsCubit>(),
                                      child: PharmagenomicsDetailPage(
                                          pharmacogenomics: profile),
                                    ),
                                  ),
                                ).then((_) => context
                                    .read<PharmacogenomicsCubit>()
                                    .fetchPharmacogenomics());
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is PharmacogenomicsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                        child: Text('Press button to fetch data.'));
                  },
                ),
              ),
              const SizedBox(height: 16),
              _UploadSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadSection extends StatefulWidget {
  @override
  __UploadSectionState createState() => __UploadSectionState();
}

class __UploadSectionState extends State<_UploadSection> {
  final TextEditingController _titleController = TextEditingController();
  File? _pickedFile;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload New Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child:
                  Text(_pickedFile?.path.split('/').last ?? 'No file selected'),
            ),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Choose File'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _pickedFile != null) {
                context.read<PharmacogenomicsCubit>().create(
                      _titleController.text,
                      null, // description is optional
                      _pickedFile,
                    );
                _titleController.clear();
                setState(() {
                  _pickedFile = null;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Please provide a title and select a file.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
