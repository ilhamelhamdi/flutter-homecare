import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/models/appointment.dart';
import 'package:dio/dio.dart';

class AppointmentPage extends StatefulWidget {
  static const String route = '/appointment';
  AppointmentPage({Key? key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<AppointmentCubit>().fetchAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Appointment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Handle search action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Handle filter action
                  },
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF40E0D0), // Warna tosca
          tabs: [
            const Tab(text: 'Upcoming'),
            const Tab(text: 'Completed'),
            const Tab(text: 'Cancelled'),
            const Tab(text: 'Missed'),
          ],
        ),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AppointmentLoaded) {
            return Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildAppointmentList(state.appointments, 'Upcoming'),
                      buildAppointmentList(state.appointments, 'Completed'),
                      buildAppointmentList(state.appointments, 'Cancelled'),
                      buildAppointmentList(state.appointments, 'Missed'),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is AppointmentError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No appointments found'));
          }
        },
      ),
      // bottomNavigationBar: CustomBottomAppBar(),
    );
  }

  Widget buildAppointmentList(List<Appointment> appointments, String status) {
    final filteredAppointments = appointments
        .where((appointment) => appointment.status == status)
        .toList();

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/images_budi.png'), // Dummy avatar image
                      radius: 30,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dr. Budi Sanjaya',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text('Radiologist |'),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'Completed'
                                    ? const Color(0x1A18B23C)
                                    : status == 'Cancelled' ||
                                            status == 'Missed'
                                        ? const Color(0x1AED3443)
                                        : const Color(0x1AE59500),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(status,
                                  style: TextStyle(
                                    color: status == 'Completed'
                                        ? Colors.green
                                        : status == 'Cancelled' ||
                                                status == 'Missed'
                                            ? Colors.red
                                            : const Color(0xFFE59500),
                                  )),
                            ),
                          ],
                        ),
                        Text('${appointment.date} | ${appointment.hour}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (status == 'Completed')
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle rating
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Const.tosca),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Rating',
                                style: TextStyle(
                                  color: Const.tosca,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF40E0D0), // Tosca color
                                  Color(0xFF35C5CF),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle book again
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Book Again',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (status == 'Cancelled')
                      Container(
                        width: 350,
                        height: 41,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF40E0D0), // Tosca color
                              Color(0xFF35C5CF),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle book again
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.transparent),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book Again',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    if (status == 'Missed')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Handle cancel booking
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel Booking',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF35C5CF),
                                  Color(0xFF9DCEFF),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle reschedule
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Reschedule',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (status == 'Upcoming')
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Handle cancel booking
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel Booking',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF35C5CF),
                                  Color(0xFF9DCEFF),
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle reschedule
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Reschedule',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
