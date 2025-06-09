import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/appointment_detail.dart';
import 'package:m2health/cubit/appointment/appointment_manager.dart';
import 'package:m2health/models/appointment.dart';
import 'package:m2health/services/provider_service.dart';
import 'package:dio/dio.dart';
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
  late ProviderService _providerService;
  final Map<String, Map<String, dynamic>> _providerCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _providerService = ProviderService(Dio());
    context.read<AppointmentCubit>().fetchAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get provider data with fallback mechanism
  Future<Map<String, dynamic>?> _getProviderDataWithFallback(
      Appointment appointment) async {
    // Return existing data if it has essential information
    if (!appointment.needsProviderDataFallback) {
      return appointment.profileServiceData;
    }

    // Extract provider name from summary
    final providerName = appointment.extractProviderNameFromSummary();
    if (providerName == null) {
      return appointment.profileServiceData;
    }

    // Check cache first
    final cacheKey = '${providerName}_${appointment.getProviderType()}';
    if (_providerCache.containsKey(cacheKey)) {
      return _providerCache[cacheKey];
    }

    try {
      // Fetch provider data
      final providerData = await _providerService.getProviderByName(
        providerName: providerName,
        providerType: appointment.getProviderType(),
      );

      if (providerData != null) {
        // Cache the result
        _providerCache[cacheKey] = providerData;
        return providerData;
      }
    } catch (e) {
      print('Error fetching provider data: $e');
    }

    // Return original data as fallback
    return appointment.profileServiceData;
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
                IconButton(
                  icon: const Icon(Icons.medical_services),
                  onPressed: () async {
                    // Check if user is a provider and navigate to provider appointments
                    final isProvider = await AppointmentManager.isProvider();
                    if (isProvider) {
                      AppointmentManager.navigateToAppointmentPage(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'This feature is only available for healthcare providers'),
                        ),
                      );
                    }
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
                      buildAppointmentList(state.appointments, 'upcoming'),
                      buildAppointmentList(state.appointments, 'completed'),
                      buildAppointmentList(state.appointments, 'cancelled'),
                      buildAppointmentList(state.appointments, 'missed'),
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
    );
  }

  Widget buildAppointmentList(List<Appointment> appointments, String status) {
    List<Appointment> filteredAppointments;

    // Special handling for Upcoming tab to show both pending and accepted
    if (status == 'upcoming') {
      filteredAppointments = appointments
          .where((appointment) =>
              appointment.status.toLowerCase() == 'pending' ||
              appointment.status.toLowerCase() == 'accepted' ||
              appointment.status.toLowerCase() == 'upcoming')
          .toList();
    } else {
      filteredAppointments = appointments
          .where((appointment) =>
              appointment.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              status == 'upcoming'
                  ? 'No upcoming appointments found'
                  : 'No ${status.toLowerCase()} appointments found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment, status);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, String status) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getProviderDataWithFallback(appointment),
      builder: (context, snapshot) {
        Map<String, dynamic> profile;
        bool isLoading = false;

        if (snapshot.connectionState == ConnectionState.waiting &&
            appointment.needsProviderDataFallback) {
          isLoading = true;
          profile = appointment.profileServiceData;
        } else {
          profile = snapshot.data ?? appointment.profileServiceData;
        }

        return _buildAppointmentCardContent(
            appointment, profile, status, isLoading);
      },
    );
  }

  Widget _buildAppointmentCardContent(Appointment appointment,
      Map<String, dynamic> profile, String status, bool isLoading) {
    // Enhanced provider name extraction with multiple fallbacks
    String providerName = 'Unknown Provider';
    if (profile['name'] != null && profile['name'].toString().isNotEmpty) {
      providerName = profile['name'].toString();
    } else if (profile['username'] != null &&
        profile['username'].toString().isNotEmpty) {
      providerName = profile['username'].toString();
    } else if (profile['provider_name'] != null &&
        profile['provider_name'].toString().isNotEmpty) {
      providerName = profile['provider_name'].toString();
    } else if (profile['pharmacist_name'] != null &&
        profile['pharmacist_name'].toString().isNotEmpty) {
      providerName = profile['pharmacist_name'].toString();
    } else if (profile['nurse_name'] != null &&
        profile['nurse_name'].toString().isNotEmpty) {
      providerName = profile['nurse_name'].toString();
    } else {
      // If still no provider name, try to extract from summary
      final extractedName = appointment.extractProviderNameFromSummary();
      if (extractedName != null) {
        providerName = extractedName;
      }
    }

    // Enhanced avatar handling with multiple fallbacks
    String? avatarUrl;
    if (profile['avatar'] != null && profile['avatar'].toString().isNotEmpty) {
      avatarUrl = profile['avatar'].toString();
    } else if (profile['image'] != null &&
        profile['image'].toString().isNotEmpty) {
      avatarUrl = profile['image'].toString();
    } else if (profile['photo'] != null &&
        profile['photo'].toString().isNotEmpty) {
      avatarUrl = profile['photo'].toString();
    } else if (profile['profile_image'] != null &&
        profile['profile_image'].toString().isNotEmpty) {
      avatarUrl = profile['profile_image'].toString();
    }

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
                'profile_services_data': profile, // Use enhanced profile data
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
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? NetworkImage(avatarUrl)
                                : null,
                        child: (avatarUrl == null || avatarUrl.isEmpty)
                            ? Icon(Icons.person, size: 30, color: Colors.grey)
                            : null,
                      ),
                      // Show loading indicator if fetching provider data
                      if (isLoading)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF40E0D0),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            providerName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isLoading) ...[
                            const SizedBox(width: 5),
                            const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF40E0D0),
                                ),
                              ),
                            ),
                          ],
                        ],
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
                                  : status == 'Cancelled' || status == 'Missed'
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
                  if (appointment.status.toLowerCase() == 'completed')
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
                      ],
                    ),
                  if (appointment.status.toLowerCase() == 'cancelled')
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
                  if (appointment.status.toLowerCase() == 'missed')
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
                              final appointmentId = appointment.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookAppointmentPage(
                                    pharmacist:
                                        profile, // Use enhanced profile data
                                    appointmentId: appointmentId,
                                    initialDate:
                                        DateTime.parse(appointment.date),
                                    initialTime: DateFormat('HH:mm')
                                        .parse(appointment.hour),
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.transparent),
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
                  if (appointment.status.toLowerCase() == 'pending' ||
                      appointment.status.toLowerCase() == 'accepted' ||
                      appointment.status.toLowerCase() == 'upcoming')
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: const EdgeInsets.all(16.0),
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
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              context
                                                  .read<AppointmentCubit>()
                                                  .cancelAppointment(
                                                      appointmentId);
                                            },
                                            child: const Text('Yes, Cancel'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                              final appointmentId = appointment.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookAppointmentPage(
                                    pharmacist:
                                        profile, // Use enhanced profile data
                                    appointmentId: appointmentId,
                                    initialDate:
                                        DateTime.parse(appointment.date),
                                    initialTime: DateFormat('HH:mm')
                                        .parse(appointment.hour),
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.transparent),
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
  }
}
