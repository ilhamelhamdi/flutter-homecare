import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'details/detail_appointment.dart';
import 'package:m2health/const.dart';
import 'package:m2health/widgets/time_slot_grid_view.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> pharmacist;
  final int? appointmentId; // Optional appointment ID for rescheduling
  final DateTime? initialDate; // Optional initial date for rescheduling
  final DateTime? initialTime; // Optional initial time for rescheduling

  const BookAppointmentPage({
    Key? key,
    required this.pharmacist,
    this.appointmentId,
    this.initialDate,
    this.initialTime,
  }) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime selectTime;

  @override
  void initState() {
    super.initState();
    // Use initial values if provided, otherwise default to now
    _selectedDay = widget.initialDate ?? DateTime.now();
    _focusedDay = widget.initialDate ?? DateTime.now();
    selectTime = widget.initialTime ?? DateTime.now();
  }

  Future<void> _submitAppointment() async {
    final appointmentData = {
      'user_id': 1, // Replace with actual user ID
      'type': widget.pharmacist['role'],
      'status': 'Upcoming',
      'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
      'hour': DateFormat('HH:mm').format(selectTime),
      'summary': 'Summary',
      'pay_total': 100,
      'profile_services_data': widget.pharmacist,
    };

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      if (widget.appointmentId != null) {
        // Update existing appointment
        final response = await Dio().put(
          '${Const.API_APPOINTMENT}/${widget.appointmentId}',
          data: appointmentData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          print('Appointment rescheduled successfully');
          Navigator.pop(context); // Go back to the previous page
        } else {
          throw Exception('Failed to reschedule appointment');
        }
      } else {
        // Create a new appointment
        final response = await Dio().post(
          Const.API_APPOINTMENT,
          data: appointmentData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          print('Appointment created successfully');
          final appointmentData = {
            'user_id': 1, // Replace with actual user ID
            'type': widget.pharmacist['role'],
            'status': 'Upcoming',
            'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
            'hour': DateFormat('HH:mm').format(selectTime),
            'summary': 'Summary',
            'pay_total': 100,
            'profile_services_data': widget.pharmacist,
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAppointmentPage(
                appointmentData: appointmentData,
              ),
            ),
          );
        } else {
          throw Exception('Failed to create appointment');
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pharmacist = widget.pharmacist;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9AE1FF).withOpacity(0.33),
                      Color(0xFF9DCEFF).withOpacity(0.33),
                    ],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(pharmacist['avatar']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacist['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(pharmacist['role']),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.teal),
                              SizedBox(width: 4),
                              Text(pharmacist['maps_location']),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF9AE1FF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: Colors.black),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Const.tosca,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Const.tosca.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Const.tosca,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  defaultTextStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Hour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeSlot(
                  startTime: DateTime(2023, 1, 1, 9, 0),
                  endTime: DateTime(2023, 1, 1, 18, 0),
                  selectedTime: selectTime,
                  onTimeSelected: (time) {
                    setState(() {
                      selectTime = time;
                    });
                  },
                ),
                SizedBox(height: 16),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitAppointment,
          child: Text(
            widget.appointmentId != null ? 'Reschedule' : 'Next',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF35C5CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
