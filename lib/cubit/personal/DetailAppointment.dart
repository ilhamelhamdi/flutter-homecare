import 'package:flutter/material.dart';
import 'package:m2health/models/appointment.dart';

class DetailAppointmentPage extends StatelessWidget {
  final Appointment appointment;

  DetailAppointmentPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary: ${appointment.summary}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Date: ${appointment.date}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Status: ${appointment.status}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Total Payment: \$${appointment.payTotal}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
