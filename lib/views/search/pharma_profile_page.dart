import 'package:flutter/material.dart';
import 'package:m2health/views/book_appointment.dart';
import 'package:m2health/const.dart';

class PharmacistProfilePage extends StatelessWidget {
  final Map<String, dynamic> pharmacist;

  const PharmacistProfilePage({Key? key, required this.pharmacist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(pharmacist['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pharmacist['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  'Pharmacist',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '180+',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Const.tosca,
                          ),
                        ),
                        const Text('Patients'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '${pharmacist['experience']}Y++',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Const.tosca,
                          ),
                        ),
                        const Text('Experience'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              pharmacist['rating'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Const.tosca,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        const Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pharmacist['about'],
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Working Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(pharmacist['days_hour']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                ),
                const SizedBox(width: 8),
                Text(
                  pharmacist['maps_location'],
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Professional Certification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 112,
                        height: 76,
                        child:
                            Image.asset('assets/images/cert${index + 1}.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Certificate Title $index',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('ID Number: 12345$index'),
                            const Text('Issued: 2021'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle See All click
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/review1.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Reviewer $index',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('4.5'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is a detailed review comment that can be seen in full. '
                        'It provides insights and feedback about the pharmacist\'s services.',
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookAppointmentPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF35C5CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Book Appointment',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
