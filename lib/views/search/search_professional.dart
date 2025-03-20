import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/views/search/professional_details.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';
import 'package:m2health/models/favorite.dart';

class SearchPage extends StatefulWidget {
  final String serviceType; // Add serviceType parameter

  const SearchPage({Key? key, required this.serviceType}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> professionals = [];
  List<Favorite> favoriteProfessionals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfessionals();
  }

  Future<void> fetchProfessionals() async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);

      // Fetch favorite professionals
      final favoriteResponse = await Dio().get(
        Const.API_FAVORITES,
        queryParameters: {
          'user_id': userId,
          'item_type':
              widget.serviceType.toLowerCase(), // "pharmacist" or "nurse"
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (favoriteResponse.statusCode == 200) {
        favoriteProfessionals =
            List<Map<String, dynamic>>.from(favoriteResponse.data['data'])
                .map((item) => Favorite.fromJson(item))
                .toList();
      } else {
        throw Exception('Failed to load favorite professionals');
      }

      // Fetch all professionals
      final response = await Dio().get(
        widget.serviceType == "Pharma"
            ? Const.API_PHARMACIST_SERVICES
            : Const.API_NURSE_SERVICES, // Use appropriate API
      );
      if (response.statusCode == 200) {
        setState(() {
          professionals = List<Map<String, dynamic>>.from(response.data['data'])
              .map((professional) {
            final isFavorite = favoriteProfessionals
                .any((fav) => fav.itemId == professional['id']);
            return {
              'id': professional['id'] ?? 0,
              'name': professional['name'] ?? '',
              'avatar': getImageUrl(professional['avatar'] ?? ''),
              'experience': professional['experience'] ?? 0,
              'rating': (professional['rating'] ?? 0.0).toDouble(),
              'about': professional['about'] ?? '',
              'working_information': professional['working_information'] ?? '',
              'days_hour': professional['days_hour'] ?? '',
              'maps_location': professional['maps_location'] ?? '',
              'certification': professional['certification'] ?? '',
              'user_id': professional['user_id'] ?? 0,
              'created_at': professional['created_at'] ?? '',
              'updated_at': professional['updated_at'] ?? '',
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

  Future<void> updateFavoriteStatus(int professionalId, bool isFavorite) async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);

      if (isFavorite) {
        final data = {
          'user_id': userId,
          'item_id': professionalId,
          'item_type': widget.serviceType.toLowerCase(),
          'highlighted': 1,
        };
        print('Updating favorite status with data: $data');

        final response = await Dio().post(
          Const.API_FAVORITES,
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
          'item_id': professionalId,
          'item_type': widget.serviceType.toLowerCase(),
        };
        print('Deleting favorite with data: $data');

        final response = await Dio().delete(
          Const.API_FAVORITES,
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
      professionals[index]['isFavorite'] = !professionals[index]['isFavorite'];
    });
    print(
        'Toggled favorite for professional ID: ${professionals[index]['id']}');
    print('New favorite status: ${professionals[index]['isFavorite']}');
    updateFavoriteStatus(
        professionals[index]['id'], professionals[index]['isFavorite']);
  }

  @override
  Widget build(BuildContext context) {
    final String role = widget.serviceType == "Pharma" ? "Pharmacist" : "Nurse";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search ${widget.serviceType}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search ${widget.serviceType}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: professionals.length,
                      itemBuilder: (context, index) {
                        final professional = professionals[index];
                        return Card(
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
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  professional['avatar']),
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
                                        StarRating(
                                            rating: professional['rating']),
                                        const SizedBox(width: 4),
                                        Text(professional['rating']
                                            .toString()), // Rating
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        professional['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(widget.serviceType),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfessionalProfilePage(
                                                    professional: professional,
                                                    role: role,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Appointment',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              professional['isFavorite']
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
