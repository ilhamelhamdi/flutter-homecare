import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_homecare/app_localzations.dart';
import '../const.dart';
import '../utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:flutter_homecare/main.dart';

import '../views/details/detail_pharma.dart';

class PharmaServices extends StatefulWidget {
  @override
  _PharmaState createState() => _PharmaState();
}

class PharmaCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const PharmaCard(
      {required this.pharma, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 243,
        padding: const EdgeInsets.all(16.0),
        color:
            color.withOpacity(0.1), // Set the background color with 10% opacity
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pharma['title']}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/ic_play.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: -25,
              right: -20,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    pharma['imagePath']!,
                    width: 185,
                    height: 139,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmaState extends State<PharmaServices> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'Medication Counseling\nand Education',
      'description':
          'Medication counseling and education guide\npatients on proper use, side effects, and\nadherence to prescriptions,\nenhancing safety and\nimproving health outcomes.',
      'imagePath': 'assets/icons/ilu_pharmacist.png',
      'color': 'F79E1B',
      'opacity': '0.1',
    },
    {
      'title': 'Compehensive Therapy\nReview',
      'description':
          'Comprehensive review of your medication\nand lifestyle to optimize treatment\noutcomes and minimize potential side\neffects',
      'imagePath': 'assets/icons/ilu_therapy.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
    {
      'title': 'Health Coaching',
      'description':
          'Personalized guidance and support to help\nindividuals achieve their health goals, manage\nchronic conditions, and improve overall well-\nbeing, with specialized programs for weight\nmanagement, diabetes management, high\nblood pressure management, and high\ncholesterol management',
      'imagePath': 'assets/icons/ilu_coach.png',
      'color': '9AE1FF',
      'opacity': '0.33',
    },
    {
      'title': 'Smoking Cessation',
      'description':
          'Smoking cessation involves quitting\nsmoking through strategies like\ncounseling, medications, and support\nprograms to improve health and\nreduce the risk of smoking-related\ndiseases.',
      'imagePath': 'assets/icons/ilu_lung.png',
      'color': 'FF9A9A',
      'opacity': '0.19',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('pharmacist_services2'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: dummyTenders.length,
                itemBuilder: (context, index) {
                  final tender = dummyTenders[index];
                  return PharmaCard(
                    pharma: tender,
                    onTap: () {
                      String route;
                      switch (index) {
                        case 0:
                          navbarVisibility(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PharmaDetailPage(
                                item: tender,
                              ),
                            ),
                          ).then((_) {
                            // Show the bottom navigation bar when returning
                            navbarVisibility(false);
                          });
                          return;
                        case 1:
                          route = AppRoutes.home;
                          break;
                        case 2:
                          route = AppRoutes.home;
                          break;
                        case 3:
                          route = AppRoutes.home;
                          break;
                        default:
                          route = AppRoutes.home;
                      }
                      Navigator.pushNamed(context, route);
                    },
                    color: Color(int.parse('0xFF${tender['color']}'))
                        .withOpacity(tender['opacity'] != null
                            ? double.parse(tender['opacity']!)
                            : 1.0),
                  );
                },
                separatorBuilder: (context, index) => Divider(height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmaDetailPage extends StatefulWidget {
  final Map<String, String> item;

  PharmaDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _PharmaDetailPageState createState() => _PharmaDetailPageState();
}

class _PharmaDetailPageState extends State<PharmaDetailPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  // void _shareProduct() {
  //   final String productUrl = Const.URL_WEB + '/tender/detail/${item['title']}';
  //   Share.share(productUrl, subject: '');
  // }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _chatHistory.add({
          "message": _chatController.text,
          "isSender": true,
        });
        _chatController.clear();
      });

      // Simulate a response from the other side
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _chatHistory.add({
            "message": "This is a dummy response",
            "isSender": false,
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.supervised_user_circle), // Replace with your custom icon
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Pharmacist",
                  style: TextStyle(
                    color: Color(0xFF35C5CF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 130.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: Colors.grey),
                            Text(
                              "(HIPAA Privacy)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_chatHistory[index]["isSender"])
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Align(
                              alignment: (_chatHistory[index]["isSender"]
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: (_chatHistory[index]["isSender"]
                                      ? Color(0xFF35C5CF)
                                      : Colors.white),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  _chatHistory[index]["message"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: _chatHistory[index]["isSender"]
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 150,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.grey),
                        SizedBox(
                            width:
                                5), // Add some spacing between the icon and text
                        Text(
                          "Need Help? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPersonalPage()),
                            );
                          },
                          child: Text(
                            "Request help from the Pharmacist",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Write your message',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA1A1A1),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal:
                                            20.0), // Adjust these values as needed
                                  ),
                                  controller: _chatController,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.mic, color: Colors.grey),
                                onPressed: () {
                                  // Add your mic button logic here
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.send, color: Colors.blue),
                                onPressed: () {
                                  _sendMessage();
                                  // Add your send message logic here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
