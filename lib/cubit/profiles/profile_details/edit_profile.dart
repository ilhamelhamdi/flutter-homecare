import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/models/profile.dart';
import 'package:m2health/cubit/profiles/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  EditProfilePage({required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _gender;
  late int _age;
  late double _weight;
  late double _height;
  late String _contactNumber;
  late String _homeAddress;
  late String _drugAllergy;

  @override
  void initState() {
    super.initState();
    _gender = widget.profile.gender;
    _age = widget.profile.age ?? 0;
    _weight = widget.profile.weight ?? 0.0;
    _height = widget.profile.height ?? 0.0;
    _contactNumber = widget.profile.phoneNumber ?? '';
    _homeAddress = widget.profile.homeAddress ?? '';
    // _drugAllergy = widget.profile.drugAllergy ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  initialValue: _age.toString(),
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _age = int.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: DropdownButtonFormField<String>(
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
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  initialValue: _weight.toString(),
                  decoration: InputDecoration(
                    labelText: 'Weight (KG)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _weight = double.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 352,
                height: 56,
                child: TextFormField(
                  initialValue: _height.toString(),
                  decoration: InputDecoration(
                    labelText: 'Height (CM)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _height = double.parse(value!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  initialValue: _contactNumber,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _contactNumber = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 352,
                height: 56,
                child: TextFormField(
                  initialValue: _homeAddress,
                  decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) {
                    _homeAddress = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Container(
              //   width: 352,
              //   height: 156,
              //   child: TextFormField(
              //     initialValue: _drugAllergy,
              //     decoration: InputDecoration(
              //       labelText: 'Drug Allergy Statuses',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onSaved: (value) {
              //       _drugAllergy = value!;
              //     },
              //   ),
              // ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

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
                  avatar: widget.profile.avatar, // Keep existing avatar
                  createdAt: widget.profile.createdAt,
                  updatedAt: DateTime.now().toString(),
                  // gender: _gender,
                  // drugAllergy: _drugAllergy,
                );

                context.read<ProfileCubit>().updateProfile(updatedProfile);

                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40E0D0), // Warna biru tosca
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
