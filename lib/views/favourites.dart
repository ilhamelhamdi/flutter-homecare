import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';
import 'package:m2health/views/search/pharma_checkout.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class FavoriteProvider with ChangeNotifier {
  final Map<int, bool> _favorites = {};

  Map<int, bool> get favorites => _favorites;

  void toggleFavorite(int id) {
    if (_favorites.containsKey(id)) {
      _favorites[id] = !_favorites[id]!;
    } else {
      _favorites[id] = true;
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites[id] ?? false;
  }
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Map<String, dynamic>> pharmacists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavoritePharmacists();
  }

  Future<void> fetchFavoritePharmacists() async {
    try {
      final userId = await Utils.getSpString(
          Const.USER_ID); // Get user ID from shared preferences
      final token = await Utils.getSpString(
          Const.TOKEN); // Get bearer token from shared preferences

      final response = await Dio().get(
        Const.API_FAVORITES,
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

      if (response.statusCode == 200) {
        setState(() {
          pharmacists = List<Map<String, dynamic>>.from(response.data['data'])
              .map((item) {
            final pharmacist = item['item'];
            return {
              'id': item['item_id'],
              'name': pharmacist != null ? pharmacist['name'] ?? '' : '',
              'image': pharmacist != null ? pharmacist['avatar'] ?? '' : '',
              'rating': pharmacist != null
                  ? (pharmacist['rating'] ?? 0.0).toDouble()
                  : 0.0,
              'isFavorite': item['highlighted'] == 1,
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
      final userId = await Utils.getSpString(
          Const.USER_ID); // Get user ID from shared preferences
      final token = await Utils.getSpString(
          Const.TOKEN); // Get bearer token from shared preferences

      if (isFavorite) {
        final response = await Dio().post(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': pharmacistId,
            'item_type': 'pharmacist',
            'highlighted': 1,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update favorite status');
        }
      } else {
        final response = await Dio().delete(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': pharmacistId,
            'item_type': 'pharmacist',
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to delete favorite');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _toggleFavorite(int index) {
    final isFavorite = !pharmacists[index]['isFavorite'];
    setState(() {
      pharmacists[index]['isFavorite'] = isFavorite;
      if (!isFavorite) {
        pharmacists.removeAt(index);
      }
    });
    updateFavoriteStatus(pharmacists[index]['id'], isFavorite);
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                                  NetworkImage(pharmacist['image'] as String),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PharmacistProfilePage(
                                            pharmacist: pharmacist,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
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
