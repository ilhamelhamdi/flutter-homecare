import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homecare/app_localzations.dart';
import 'package:flutter_homecare/cubit/nursing/nursing_cubit.dart';
import 'package:flutter_homecare/cubit/nursing/nursing_payment.dart';
import 'package:flutter_homecare/cubit/nursing/nursing_state.dart';
import 'package:flutter_homecare/cubit/personal/personal_page.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'package:flutter_homecare/main.dart';

class NursingService extends StatefulWidget {
  @override
  _NursingState createState() => _NursingState();
}

class NursingCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const NursingCard(
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

class _NursingState extends State<NursingService> {
  @override
  void initState() {
    super.initState();
    context.read<NursingCubit>().loadNursingServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('nursing'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<NursingCubit, NursingState>(
                builder: (context, state) {
                  if (state is NursingLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NursingLoaded) {
                    return ListView.separated(
                      itemCount: state.tenders.length,
                      itemBuilder: (context, index) {
                        final tender = state.tenders[index];
                        return NursingCard(
                          pharma: tender,
                          onTap: () {
                            String route;
                            switch (index) {
                              case 0:
                                navbarVisibility(true);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalPage(
                                        // item: tender,
                                        ),
                                  ),
                                ).then((_) {
                                  // Show the bottom navigation bar when returning
                                  navbarVisibility(false);
                                });
                                return;
                              case 1:
                                navbarVisibility(true);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalPage(
                                        // item: tender,
                                        ),
                                  ),
                                ).then((_) {
                                  // Show the bottom navigation bar when returning
                                  navbarVisibility(false);
                                });
                                return;
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
                    );
                  } else if (state is NursingError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
