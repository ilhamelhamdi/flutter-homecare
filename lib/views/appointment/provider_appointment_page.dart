import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/cubit/appointment/provider_appointment_cubit.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:m2health/const.dart';

class ProviderAppointmentPage extends StatefulWidget {
  final String providerType;

  const ProviderAppointmentPage({Key? key, required this.providerType})
      : super(key: key);

  @override
  _ProviderAppointmentPageState createState() =>
      _ProviderAppointmentPageState();
}

class _ProviderAppointmentPageState extends State<ProviderAppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context
        .read<ProviderAppointmentCubit>()
        .fetchProviderAppointments(widget.providerType);
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
        title: Text(
          '${widget.providerType.toUpperCase()} Appointments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<ProviderAppointmentCubit>()
                  .fetchProviderAppointments(widget.providerType);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF40E0D0),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: BlocBuilder<ProviderAppointmentCubit, ProviderAppointmentState>(
        builder: (context, state) {
          if (state is ProviderAppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProviderAppointmentLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildProviderAppointmentList(state.appointments, 'pending'),
                _buildProviderAppointmentList(state.appointments, 'accepted'),
                _buildProviderAppointmentList(state.appointments, 'completed'),
                _buildProviderAppointmentList(state.appointments, 'rejected'),
              ],
            );
          } else if (state is ProviderAppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProviderAppointmentCubit>()
                          .fetchProviderAppointments(widget.providerType);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No appointments found'));
        },
      ),
    );
  }

  Widget _buildProviderAppointmentList(
      List<ProviderAppointment> appointments, String status) {
    final filteredAppointments = appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == status.toLowerCase())
        .toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No ${status.toLowerCase()} appointments found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ProviderAppointmentCubit>()
            .fetchProviderAppointments(widget.providerType);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          return _buildProviderAppointmentCard(appointment, status);
        },
      ),
    );
  }

  Widget _buildProviderAppointmentCard(
      ProviderAppointment appointment, String status) {
    final patientData = appointment.patientData;

    return GestureDetector(
      onTap: () => _showAppointmentDetail(appointment),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (patientData['avatar'] != null &&
                            patientData['avatar'].toString().isNotEmpty)
                        ? NetworkImage(patientData['avatar'])
                        : null,
                    child: (patientData['avatar'] == null ||
                            patientData['avatar'].toString().isEmpty)
                        ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientData['name'] ?? 'Unknown Patient',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              appointment.type,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(' | ', style: TextStyle(color: Colors.grey)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(appointment.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                appointment.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(appointment.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              '${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.parse(appointment.date))}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              appointment.hour,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (appointment.summary.isNotEmpty) ...[
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        appointment.summary,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${appointment.payTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                  if (status.toLowerCase() == 'pending')
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _rejectAppointment(appointment.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: Size(80, 36),
                          ),
                          child: Text('Reject'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _acceptAppointment(appointment.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF35C5CF),
                            foregroundColor: Colors.white,
                            minimumSize: Size(80, 36),
                          ),
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  if (status.toLowerCase() == 'accepted')
                    ElevatedButton(
                      onPressed: () => _completeAppointment(appointment.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Mark Complete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'accepted':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  void _acceptAppointment(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accept Appointment'),
          content: Text('Are you sure you want to accept this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<ProviderAppointmentCubit>()
                    .acceptAppointment(appointmentId);
              },
              child: Text('Accept', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _rejectAppointment(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject Appointment'),
          content: Text('Are you sure you want to reject this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<ProviderAppointmentCubit>()
                    .rejectAppointment(appointmentId);
              },
              child: Text('Reject', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _completeAppointment(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Appointment'),
          content: Text('Mark this appointment as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<ProviderAppointmentCubit>()
                    .completeAppointment(appointmentId);
              },
              child: Text('Complete', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentDetail(ProviderAppointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Appointment Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Patient',
                            appointment.patientData['name'] ?? 'Unknown'),
                        _buildDetailRow('Type', appointment.type),
                        _buildDetailRow('Status', appointment.status),
                        _buildDetailRow(
                            'Date',
                            DateFormat('EEEE, dd MMMM yyyy')
                                .format(DateTime.parse(appointment.date))),
                        _buildDetailRow('Time', appointment.hour),
                        _buildDetailRow('Total',
                            '\$${appointment.payTotal.toStringAsFixed(2)}'),
                        if (appointment.summary.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Text(
                            'Summary:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(appointment.summary),
                          ),
                        ],
                        SizedBox(height: 20),
                        if (appointment.status.toLowerCase() == 'pending') ...[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _rejectAppointment(appointment.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text('Reject'),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _acceptAppointment(appointment.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF35C5CF),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text('Accept'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (appointment.status.toLowerCase() == 'accepted') ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _completeAppointment(appointment.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text('Mark as Complete'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
