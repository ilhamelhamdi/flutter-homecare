import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/models/profile.dart';
import 'package:m2health/cubit/profiles/profile_cubit.dart';
import 'package:m2health/cubit/profiles/profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  EditProfilePage({required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  late String _gender;
  late int _age;
  late double _weight;
  late double _height;
  late String _contactNumber;
  late String _homeAddress;
  bool _isUpdating = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _gender =
        (widget.profile.gender == 'Male' || widget.profile.gender == 'Female')
            ? widget.profile.gender
            : 'Male';
    _age = widget.profile.age;
    _weight = widget.profile.weight;
    _height = widget.profile.height;
    _contactNumber = widget.profile.phoneNumber;
    _homeAddress = widget.profile.homeAddress;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isUpdating = true;
      });

      final updatedProfile = Profile(
        id: widget.profile.id,
        userId: widget.profile.userId,
        email: widget.profile.email,
        username: widget.profile.username,
        age: _age,
        weight: _weight,
        height: _height,
        phoneNumber: _contactNumber,
        homeAddress: _homeAddress,
        gender: _gender,
        avatar: widget.profile.avatar,
        createdAt: widget.profile.createdAt,
        updatedAt: DateTime.now().toString(),
      );

      context
          .read<ProfileCubit>()
          .updateProfileWithImage(updatedProfile, _selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          setState(() {
            _isUpdating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          setState(() {
            _isUpdating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update profile: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Profile Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(58),
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : widget.profile.avatar.isNotEmpty
                                  ? Image.network(
                                      widget.profile.avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF40E0D0),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedImage != null)
                  Center(
                    child: TextButton(
                      onPressed: _removeImage,
                      child: const Text(
                        'Remove Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                TextFormField(
                  initialValue: _age.toString(),
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _age = int.tryParse(value ?? '') ?? _age;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _weight.toString(),
                  decoration: InputDecoration(
                    labelText: 'Weight (KG)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _weight = double.tryParse(value ?? '') ?? _weight;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _height.toString(),
                  decoration: InputDecoration(
                    labelText: 'Height (CM)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _height = double.tryParse(value ?? '') ?? _height;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _contactNumber,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _contactNumber = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _homeAddress,
                  decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) {
                    _homeAddress = value ?? '';
                  },
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isUpdating ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40E0D0),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isUpdating
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}
