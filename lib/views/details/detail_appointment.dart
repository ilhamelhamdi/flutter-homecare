import 'package:flutter/material.dart';
import 'package:m2health/models/appointment.dart';
import 'package:m2health/views/payment.dart';

class DetailAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  DetailAppointmentPage({required this.appointment});

  @override
  _DetailAppointmentPageState createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final profile = widget.appointment.profileServiceData;

    return Scaffold(
      appBar: AppBar(
        title: Text(profile['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                          image: NetworkImage(profile['name']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Text(profile.role),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(profile['maps_location']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.appointment.status,
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Schedule Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(widget.appointment.date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(widget.appointment.hour),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Patient Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Set a fixed width for the label
                    child: const Text('Full Name: '),
                  ),
                  const Flexible(
                    child: Text('John Doe'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Set a fixed width for the label
                    child: const Text('Age: '),
                  ),
                  const Flexible(
                    child: Text('30'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Set a fixed width for the label
                    child: const Text('Gender: '),
                  ),
                  const Flexible(
                    child: Text('Male'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100, // Set a fixed width for the label
                        child: const Text('Problem: '),
                      ),
                      Flexible(
                        child: Text(
                          _isExpanded
                              ? 'Chest Pain, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                              : 'Chest Pain, Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        ),
                      ),
                    ],
                  ),
                  if (!_isExpanded)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      child: const Text(
                        'View More',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100, // Set a fixed width for the label
                    child: const Text('Address: '),
                  ),
                  const Flexible(
                    child: Text('123 Main Street, Singapore'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Container(
                height: 200,
                child: const Center(
                  child: Text('Google Map Placeholder'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inject, Blood Glucose Check, Medication Administration, NGT Feeding',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'Estimated Budget',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline_rounded, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            const Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Inject'),
                    Spacer(),
                    Text('\$250'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Inject'),
                    Spacer(),
                    Text('\$250'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Inject'),
                    Spacer(),
                    Text('\$250'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text('Inject'),
                    Spacer(),
                    Text('\$250'),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.attach_money, color: Colors.green),
                    Text(
                      '\$250',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity, // Set the width to fill the parent
              height: 50, // Set a fixed height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Set the width to fill the parent
              height: 50, // Set a fixed height
              child: ElevatedButton(
                onPressed: () {
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
                              'Are you sure want to cancel this appointment?',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle the cancellation logic here
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes, Cancel'),
                                  style: ElevatedButton.styleFrom(
                                      // primary: Colors.red,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Set the background color to red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
