import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/cubit/pharmacist_profile/pharmacist_profile_page.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/book_appointment.dart';
import 'package:m2health/const.dart';
import 'package:m2health/models/favorite.dart';

class SearchPharmacistPage extends StatefulWidget {
  @override
  _SearchPharmacistPageState createState() => _SearchPharmacistPageState();
}

class _SearchPharmacistPageState extends State<SearchPharmacistPage> {
  List<Map<String, dynamic>> pharmacists = [];
  List<Favorite> favoritePharmacists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPharmacists();
  }

  Future<void> fetchPharmacists() async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);

      // Fetch favorite pharmacists
      final favoriteResponse = await Dio().get(
        'http://localhost:3333/v1/favorites',
        queryParameters: {
          'user_id': userId,
          'item_type': 'pharmacist',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (favoriteResponse.statusCode == 200) {
        favoritePharmacists =
            List<Map<String, dynamic>>.from(favoriteResponse.data['data'])
                .map((item) => Favorite.fromJson(item))
                .toList();
      } else {
        throw Exception('Failed to load favorite pharmacists');
      }

      // Fetch all pharmacists
      final response =
          await Dio().get('http://localhost:3333/v1/pharmacist-services');
      if (response.statusCode == 200) {
        setState(() {
          pharmacists = List<Map<String, dynamic>>.from(response.data['data'])
              .map((pharmacist) {
            final isFavorite = favoritePharmacists
                .any((fav) => fav.itemId == pharmacist['id']);
            return {
              'id': pharmacist['id'] ?? 0,
              'name': pharmacist['name'] ?? '',
              'avatar': pharmacist['avatar'] ?? '',
              'experience': pharmacist['experience'] ?? 0,
              'rating': (pharmacist['rating'] ?? 0.0).toDouble(),
              'about': pharmacist['about'] ?? '',
              'working_information': pharmacist['working_information'] ?? '',
              'days_hour': pharmacist['days_hour'] ?? '',
              'maps_location': pharmacist['maps_location'] ?? '',
              'certification': pharmacist['certification'] ?? '',
              'user_id': pharmacist['user_id'] ?? 0,
              'created_at': pharmacist['created_at'] ?? '',
              'updated_at': pharmacist['updated_at'] ?? '',
              'isFavorite': isFavorite,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> updateFavoriteStatus(int pharmacistId, bool isFavorite) async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);

      if (isFavorite) {
        final data = {
          'user_id': userId,
          'item_id': pharmacistId,
          'item_type': 'pharmacist',
          'highlighted': 1,
        };
        print('Updating favorite status with data: $data');

        final response = await Dio().post(
          'http://localhost:3333/v1/favorites',
          data: data,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode != 200) {
          throw Exception('Failed to update favorite status');
        }
      } else {
        final data = {
          'user_id': userId,
          'item_id': pharmacistId,
          'item_type': 'pharmacist',
        };
        print('Deleting favorite with data: $data');

        final response = await Dio().delete(
          'http://localhost:3333/v1/favorites',
          data: data,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode != 200) {
          throw Exception('Failed to delete favorite');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      pharmacists[index]['isFavorite'] = !pharmacists[index]['isFavorite'];
    });
    print('Toggled favorite for pharmacist ID: ${pharmacists[index]['id']}');
    print('New favorite status: ${pharmacists[index]['isFavorite']}');
    updateFavoriteStatus(
        pharmacists[index]['id'], pharmacists[index]['isFavorite']);
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
                                        image: NetworkImage(
                                            pharmacist['avatar'] ?? ''),
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
