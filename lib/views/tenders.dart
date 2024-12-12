import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_homecare/app_localzations.dart';
import '../const.dart';
import '../utils.dart';
import 'package:share_plus/share_plus.dart';

class Tenders extends StatefulWidget {
  @override
  _TenderState createState() => _TenderState();
}

class TenderCard extends StatelessWidget {
  final Map<String, String> tender;
  final VoidCallback onTap;
  final Color color;

  const TenderCard(
      {required this.tender, required this.onTap, required this.color});

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
                  '${tender['title']}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${tender['description']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300, // Light font weight
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onTap,
                  child: Text('Book Now'),
                ),
              ],
            ),
            Positioned(
              bottom: -25,
              right: -15,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    tender['imagePath']!,
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

class _TenderState extends State<Tenders> {
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
            AppLocalizations.of(context)!.translate('pharmacist_services')),
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
                  return TenderCard(
                    tender: tender,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TenderDetailPage(item: tender),
                        ),
                      );
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

class TenderDetailPage extends StatelessWidget {
  final Map<String, String> item;

  TenderDetailPage({Key? key, required this.item});

  void _shareProduct() {
    final String productUrl = Const.URL_WEB + '/tender/detail/${item['title']}';
    Share.share(productUrl, subject: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tender Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item['title']!,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Avenir',
                  color: Const.primaryTextColor,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.left,
            ),
            const Divider(
              color: Colors.black38,
            ),
            Text(
              item['description']!,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Avenir',
                  color: Const.primaryTextColor,
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.left,
            ),
            const Divider(
              color: Colors.black38,
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Tender Detail',
                    style: TextStyle(
                      color: Color(0xFF22212E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            HtmlWidget(
              item['description']!,
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
