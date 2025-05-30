import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/appointment_detail.dart';
import 'package:m2health/models/appointment.dart';
import 'package:intl/intl.dart';
import 'package:m2health/views/book_appointment.dart';

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
        // automaticallyImplyLeading: false,
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
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
            Tab(text: 'Missed'),
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
        final profile = appointment.profileServiceData;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAppointmentPage(
                  appointmentData: {
                    'id': appointment.id,
                    'user_id': appointment.userId,
                    'type': appointment.type,
                    'status': appointment.status,
                    'date': appointment.date,
                    'hour': appointment.hour,
                    'summary': appointment.summary,
                    'pay_total': appointment.payTotal,
                    'profile_services_data': appointment.profileServiceData,
                  },
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profile['avatar']),
                        radius: 30,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text('${appointment.type} |'),
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
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: status == 'Completed'
                                        ? Colors.green
                                        : status == 'Cancelled' ||
                                                status == 'Missed'
                                            ? Colors.red
                                            : const Color(0xFFE59500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${DateFormat('EEEE').format(DateTime.parse(appointment.date))}, ${DateFormat('dd MMMM yyyy').format(DateTime.parse(appointment.date))} | ${appointment.hour}',
                          ),
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
                                  side: const BorderSide(
                                      color: Colors.transparent),
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
                                final appointmentId = appointment.id;
                                context
                                    .read<AppointmentCubit>()
                                    .deleteAppointment(appointmentId);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cancel Bookings',
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
                                  final appointmentId =
                                      appointment.id; // Get the appointment ID
                                  final profile =
                                      appointment.profileServiceData;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookAppointmentPage(
                                        pharmacist: profile,
                                        appointmentId:
                                            appointmentId, // Pass the appointment ID
                                        initialDate: DateTime.parse(
                                            appointment.date), // Pre-fill date
                                        initialTime: DateFormat('HH:mm').parse(
                                            appointment.hour), // Pre-fill time
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.transparent),
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
                                final appointmentId = appointment.id;

                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          const Icon(Icons.warning_outlined,
                                              size: 50, color: Colors.red),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Are you sure to cancel this booking?',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'You can rebook it later from the canceled appointment menu.',
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close dialog
                                                },
                                                child: const Text('No'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Close dialog and cancel the appointment
                                                  Navigator.of(context).pop();
                                                  context
                                                      .read<AppointmentCubit>()
                                                      .cancelAppointment(
                                                          appointmentId);
                                                },
                                                child:
                                                    const Text('Yes, Cancel'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
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
                                  final appointmentId =
                                      appointment.id; // Get the appointment ID
                                  final profile =
                                      appointment.profileServiceData;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookAppointmentPage(
                                        pharmacist: profile,
                                        appointmentId:
                                            appointmentId, // Pass the appointment ID
                                        initialDate: DateTime.parse(
                                            appointment.date), // Pre-fill date
                                        initialTime: DateFormat('HH:mm').parse(
                                            appointment.hour), // Pre-fill time
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.transparent),
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
          ),
        );
      },
    );
  }
}
