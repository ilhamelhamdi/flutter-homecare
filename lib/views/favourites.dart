import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final List<Map<String, dynamic>> pharmacists = [
    {
      'name': 'Olla Olivia',
      'image': 'assets/images/images_olla.png',
      'rating': 4.5,
      'isFavorite': true,
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
      'isFavorite': true,
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
      'isFavorite': true,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      pharmacists[index]['isFavorite'] = !pharmacists[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritePharmacists = pharmacists
        .where((pharmacist) => pharmacist['isFavorite'] as bool)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Favourites',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: favoritePharmacists.length,
        itemBuilder: (context, index) {
          final pharmacist = favoritePharmacists[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(pharmacist['image'] as String),
                        radius: 30,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacist['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Pharmacist'),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Appointment',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                pharmacist['isFavorite'] as bool
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              color: Color(0xFF35C5CF),
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
    );
  }
}
