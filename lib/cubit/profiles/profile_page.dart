import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/profiles/profile_cubit.dart';
import 'package:m2health/cubit/profiles/profile_details/edit_profile.dart';
import 'package:m2health/cubit/profiles/profile_state.dart';
import 'package:m2health/cubit/profiles/profile_details/medical_record.dart';
import 'package:m2health/cubit/profiles/profile_details/pharmagenomical.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/appointment.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(Dio())..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Health Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              context.read<ProfileCubit>().fetchProfile();
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/icons/ic_avatar.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.profile.username,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Last updated:',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                state.profile.updatedAt,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Health Records',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.medical_services,
                                  color: Color(0xFF35C5CF),
                                ),
                                title: const Text('Medical Records'),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MedicalRecordsPage()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.biotech,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('Lab Reports'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Handle Lab Reports tap
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.radio,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('Radiology Reports'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Handle Radiology Reports tap
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.health_and_safety,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('Health Screening'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Handle Health Screening tap
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.local_pharmacy,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('Pharmagenomics Profile'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PharmagenomicsProfilePage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.local_pharmacy,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('Wellness Genomics Profile'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Handle Pharma Profile tap
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Appointment',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ListTile(
                                leading: const Icon(Icons.calendar_today,
                                    color: Color(0xFF35C5CF)),
                                title: const Text('All My Appointments'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                        profile: state.profile)),
                              );
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                                'Age: ${state.profile.age ?? 'N/A'} | Weight: ${state.profile.weight ?? 'N/A'} KG | Height: ${state.profile.height ?? 'N/A'} cm'),
                            const SizedBox(height: 8),
                            Text(
                                'Phone Number: ${state.profile.phoneNumber ?? 'N/A'}'),
                            const SizedBox(height: 8),
                            Text(
                                'Home Address (Primary): ${state.profile.homeAddress}'),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Utils.clearSp();
                            debugPrint('Data telah dibersihkan');
                            GoRouter.of(context).go(AppRoutes.signIn);
                          },
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No profile data found'));
              }
            },
          ),
        ),
      ),
    );
  }
}
