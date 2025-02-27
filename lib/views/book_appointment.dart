import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'details/detail_appointment.dart';
import 'package:m2health/const.dart';
import 'package:m2health/widgets/time_slot_grid_view.dart';
import 'package:m2health/models/appointment.dart';
import 'package:dio/dio.dart';
import 'package:m2health/utils.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> pharmacist;

  const BookAppointmentPage({Key? key, required this.pharmacist})
      : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime selectTime = DateTime.now(); // Add this line

  Future<void> _createAppointment() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final profileServiceData = jsonEncode(widget.pharmacist);

      final requestData = {
        'user_id': 1, // Replace with actual user ID
        'type': 'Pharmacist',
        'status': 'Upcoming',
        'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
        'hour': DateFormat('HH:mm').format(selectTime),
        'summary': 'Summary',
        'pay_total': 100,
        'profile_service_data': profileServiceData,
      };

      print("Tipe data profile_service_data: ${widget.pharmacist.runtimeType}");

      // Check for null values in requestData
      requestData.forEach((key, value) {
        if (value == null) {
          throw Exception('Request data contains null value for key: $key');
        }
      });

      print('Request Data: $requestData');

      final response = await Dio().post(
        'http://localhost:3333/v1/appointments',
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['data'] != null) {
          final appointment = Appointment.fromJson(responseData['data']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailAppointmentPage(appointment: appointment),
            ),
          );
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      print('Error: $e');
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
            )),
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
                color: Color(0xFF9AE1FF)
                    .withOpacity(0.3), // Set the background color to #9AE1FF
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius to 16
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
          onPressed: _createAppointment,
          child: Text(
            'Next',
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
