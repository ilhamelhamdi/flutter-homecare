import 'package:flutter/material.dart';
import 'package:flutter_homecare/views/payment.dart';

class DetailAppointmentPage extends StatelessWidget {
  final String pharmacistName;

  DetailAppointmentPage({required this.pharmacistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacistName),
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
                        color: Colors.grey,
                      ),
                      child: Icon(Icons.person, size: 40),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacistName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Staff Nurse at Cardiology Department'),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(width: 4),
                            Text('Royal Hospital, Singapore'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Upcoming',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Schedule Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 8),
                Text('Monday, March 17, 2024'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 8),
                Text('10:00 AM - 11:00 AM'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Patient Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text('Full Name'),
              subtitle: Text('John Doe'),
            ),
            ListTile(
              title: Text('Age'),
              subtitle: Text('30'),
            ),
            ListTile(
              title: Text('Gender'),
              subtitle: Text('Male'),
            ),
            ListTile(
              title: Text('Problem'),
              subtitle: Text('Chest Pain'),
            ),
            ListTile(
              title: Text('Address'),
              subtitle: Text('123 Main Street, Singapore'),
            ),
            SizedBox(height: 16),
            Card(
              child: Container(
                height: 200,
                child: Center(
                  child: Text('Google Map Placeholder'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text('• Inject'),
            Text('• Blood Glucose Check'),
            Text('• Medication Administration'),
            Text('• NGT Feeding'),
            SizedBox(height: 16),
            Text(
              'Estimated Budget',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(),
                  ),
                );
              },
              child: Text('Pay'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Icon(Icons.warning, size: 50, color: Colors.yellow),
                          SizedBox(height: 16),
                          Text(
                            'Are you sure want to cancel this appointment?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You can rebook it later from the canceled appointment menu.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle the cancellation logic here
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes, Cancel'),
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
                  // primary: Colors.red,
                  ),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
