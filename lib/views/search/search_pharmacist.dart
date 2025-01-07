import 'package:flutter/material.dart';
import 'package:flutter_homecare/views/book_appointment.dart';
import 'package:flutter_homecare/const.dart';

class SearchPharmacistPage extends StatefulWidget {
  @override
  _SearchPharmacistPageState createState() => _SearchPharmacistPageState();
}

class _SearchPharmacistPageState extends State<SearchPharmacistPage> {
  final List<Map<String, dynamic>> pharmacists = [
    {
      'name': 'Olla Olivia',
      'image': 'assets/images/images_olla.png',
      'rating': 4.5,
      'isFavorite': false,
    },
    {
      'name': 'Tisa Erlangga',
      'image': 'assets/images/images_tisa.png',
      'rating': 4.0,
      'isFavorite': false,
    },
    {
      'name': 'Arieska Budiono',
      'image': 'assets/images/images_arieska.png',
      'rating': 4.8,
      'isFavorite': false,
    },
    {
      'name': 'Peter Xu',
      'image': 'assets/images/images_peter.png',
      'rating': 4.3,
      'isFavorite': false,
    },
    {
      'name': 'Dr. Rianda Tan',
      'image': 'assets/images/images_rianda.png',
      'rating': 4.7,
      'isFavorite': false,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      pharmacists[index]['isFavorite'] = !pharmacists[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Pharmacist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Pharmacist',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: pharmacists.length,
                itemBuilder: (context, index) {
                  final pharmacist = pharmacists[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: AssetImage(pharmacist['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 36,
                                    right: 3,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  StarRating(rating: pharmacist['rating']),
                                  const SizedBox(width: 4),
                                  Text(pharmacist['rating']
                                      .toString()), // Rating
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pharmacist['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Pharmacist'),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PharmacistProfilePage()),
                                        );
                                      },
                                      child: const Text('Appointment',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        pharmacist['isFavorite']
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                      color: const Color(0xFF35C5CF),
                                      onPressed: () {
                                        _toggleFavorite(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;

  StarRating({
    required this.rating,
    this.starCount = 1,
    this.size = 20.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index >= rating) {
          return Icon(
            Icons.star_border,
            size: size,
            color: color,
          );
        } else if (index > rating - 1 && index < rating) {
          return Icon(
            Icons.star_half,
            size: size,
            color: color,
          );
        } else {
          return Icon(
            Icons.star,
            size: size,
            color: color,
          );
        }
      }),
    );
  }
}

class PharmacistProfilePage extends StatelessWidget {
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
                        image: const DecorationImage(
                          image: AssetImage('assets/images/images_olla.png'),
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
                const Text(
                  'Dr. Khanza Deliva',
                  style: TextStyle(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
                        Text('Patients'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '10Y++',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Const.tosca),
                        ),
                        Text('Experience'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '4.5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Const.tosca),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        Text(
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
            const Text(
              'Dr. Khanza Deliva is a highly experienced pharmacist with over 10 years of experience in the field. She has successfully treated over 180 patients and is known for her dedication and expertise.',
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
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 8),
                Text('Monday - Friday, 08.00 AM - 21.00 PM'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.location_on,
                ),
                SizedBox(width: 8),
                Text(
                  'Caterpillar Hospital, Jack Road, Singapore 89191',
                  style: TextStyle(color: Colors.blue),
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
                  style: const TextStyle(
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
