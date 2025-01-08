import 'package:flutter/material.dart';
import 'package:flutter_homecare/cubit/profiles/profile_page.dart';
import 'package:flutter_homecare/views/appointment.dart';
import 'package:flutter_homecare/views/nursing.dart';
import 'package:flutter_homecare/views/pharmacist_services.dart';

// import 'package:flutter_homecare/views/details/detail_products.dart';
// import 'package:flutter_homecare/views/poct.dart';
// import 'package:flutter_homecare/views/tenders.dart';

import '../const.dart';
// import '../utils.dart';
import '../main.dart';
// import '../views/browse_products.dart';
// import '../views/drugs.dart';
// import '../views/analysis.dart' as listAnalysis;
// import '../views/affair.dart' as listAffair;
// import '../views/news.dart' as listNews;
// import '../views/marketing_services.dart' as listMarketingServices;
// import '../views/service_request.dart' as listServiceRequest;

import '../AppLanguage.dart';
import '../app_localzations.dart';
import 'package:provider/provider.dart';
// import '../api.dart';
// import '../models/analysis_response.dart' as analysis;
// import '../models/affair_response.dart' as affair;
// import '../models/marketing_services_response.dart' as marketing_services;
// import '../models/service_request_response.dart' as service_request;

class Dashboard extends StatefulWidget {
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final api = Api();
  // late analysis.AnalysisResponse analysisResponse;
  // late affair.AffairResponse affairResponse;
  // late marketing_services.MarketingServicesResponse marketingServicesResponse;
  // late service_request.ServiceRequestResponse serviceRequestResponse;
  // List<analysis.Data> datum = [];
  // List<affair.Data> datumAffair = [];
  // List<marketing_services.Data> datumMarketingServices = [];
  // List<service_request.Data> datumServiceRequest = [];
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  // bool hasMore = true;
  // bool isLoading = false;
  // bool isInitialLoad = true;
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isScrolledToEnd = true;
          });
        } else {
          setState(() {
            _isScrolledToEnd = false;
          });
        }
      });
    // getServiceRequest();
    // getMarketingServices();
    // getAnalysis();
    // getAffairs();
  }

  // Future<void> getServiceRequest({int page = 1}) async {
  //   final response = await api.fetchData(
  //       context, 'service-requests?page=$page&limit=$limitItem');
  //   print('Raw API Response Service Request: $response');
  //   try {
  //     if (response != null) {
  //       serviceRequestResponse =
  //           service_request.ServiceRequestResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datumServiceRequest = serviceRequestResponse.data ?? [];
  //         } else {
  //           datumServiceRequest.addAll(serviceRequestResponse.data ?? []);
  //         }
  //         currentPage = page;
  //         print('datumServiceRequest: $datumServiceRequest');
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data request service');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //   }
  // }

  // Future<void> getMarketingServices({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(
  //         context, 'marketing-services?page=$page&limit=$limitItem');
  //     print('Raw API Response Marketing: $response');

  //     if (response != null) {
  //       marketingServicesResponse =
  //           marketing_services.MarketingServicesResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datumMarketingServices = marketingServicesResponse.data ?? [];
  //         } else {
  //           datumMarketingServices.addAll(marketingServicesResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //   }
  // }

  // Future<void> getAnalysis({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(
  //         context, 'cases-analysis?page=$page&limit=$limitItem');
  //     if (response != null) {
  //       analysisResponse = analysis.AnalysisResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datum = analysisResponse.data ?? [];
  //         } else {
  //           datum.addAll(analysisResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //     // isLoading = false;
  //   }
  // }

  // Future<void> getAffairs({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(context,
  //         'gov-affairs?sort=created_at&order=desc&page=$page&limit=$limitItem');
  //     if (response != null) {
  //       affairResponse = affair.AffairResponse.fromJson(response);
  //       setState(() {
  //         if (page == datumAffair) {
  //           datumAffair = affairResponse.data ?? [];
  //         } else {
  //           datumAffair.addAll(affairResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //     // isLoading = false;
  //   }
  // }
  final List<Map<String, String>> services = [
    {'image': 'assets/icons/ilu_physio.png', 'name': 'Physiotherapy'},
    {
      'image': 'assets/icons/ilu_ocuTherapy.png',
      'name': 'Occupational\nTherapy'
    },
    {'image': 'assets/icons/ilu_sleep.png', 'name': 'Sleep & Mental\nHealth'},
    {'image': 'assets/icons/ilu_health.png', 'name': 'Health Risk\nAssessment'},
    {'image': 'assets/icons/ilu_dietitian.png', 'name': 'Dietitian Services'},
    {'image': 'assets/icons/ilu_precision.png', 'name': 'Precision\nNutrition'},
  ];

  @override
  Widget build(BuildContext context) {
    String? userName = "Anna";
    return Consumer<AppLanguage>(
      builder: (context, appLanguage, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 180,
            elevation: 2,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8EF4E8),
                    Color(0xFF35C5CF)
                  ], // Gradasi warna dari kiri ke kanan
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(
                      30), // Membuat border radius di bagian bawah
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Warna shadow
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Posisi shadow
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Const.banner,
                        fit: BoxFit.contain,
                        height: 25,
                      ),
                      const Spacer(), // Menambahkan spacer untuk memisahkan logo dan CircleAvatar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                15), // Membuat sudut membulat
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/icons/ic_avatar.png'), // Ganti dengan path gambar Anda
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Live Longer & Live Healthier, ${userName ?? 'Welcome User'}!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Jarak di bawah teks
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_doctor.png',
                          width: 24,
                          height: 24,
                          color: const Color.fromARGB(255, 0, 0,
                              0), // Menambahkan warna jika diperlukan
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  "Chat With AI doctor for all your health questions",
                              hintStyle: TextStyle(
                                  color: Color(0xFF8A96BC), fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: IconButton(
              //     icon: Icon(Icons.perm_identity),
              //     onPressed: () async {
              //       // bool isLoggedIn =
              //       //     await Utils.getSpBool(Const.IS_LOGED_IN) ?? false;
              //       // if (isLoggedIn == true) {
              //       //   // final back = await Navigator.push'cekMarketingServices : ' + (
              //       //   //   context,
              //       //   //   // MaterialPageRoute(builder: (context) => Submenu()),
              //       //   //   MaterialPageRoute(builder: (context) => SubmenuPage()),
              //       //   // );
              //       //   // if (back == 'back') {
              //       //   //   navbarVisibility(false);
              //       //   // }
              //       //   context.push(AppRoutes.submenu);
              //       // } else {
              //       //   context.push(AppRoutes.signIn);
              //       //   // await Navigator.push(
              //       //   //   context,
              //       //   //   MaterialPageRoute(builder: (context) => SignInPage()),
              //       //   // );
              //       // }
              //       // ;
              //     },
              //     // color: Colors.white,
              //   ),
              // )
            ],
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            color: Colors.white,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!.translate('services'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF232F55),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SearchInputBox(),
                  // SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RectangularIconWithTitle(
                        onTap: () {
                          navbarVisibility(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PharmaServices()),
                          );
                        },
                        iconPath:
                            'assets/icons/ic_pharma_service.png', // Replace with your actual image path
                        title: AppLocalizations.of(context)!
                            .translate('pharmacist_services'),
                        backgroundColor: const Color(0x559AE1FF),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      RectangularIconWithTitle(
                        onTap: () {
                          navbarVisibility(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NursingService()),
                          );
                        },
                        iconPath:
                            'assets/icons/ic_nurse.png', // Replace with your actual image path
                        title: AppLocalizations.of(context)!
                            .translate('home_nursing'),
                        backgroundColor: const Color(0x33B28CFF),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      RectangularIconWithTitle(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ComingSoonDialog();
                            },
                          );
                        },
                        iconPath:
                            'assets/icons/ic_diabetic.png', // Replace with your actual image path
                        title: AppLocalizations.of(context)!
                            .translate('diabetic_care'),
                        backgroundColor: const Color(0x33B28CFF),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RectangularIconWithTitle(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ComingSoonDialog();
                            },
                          );
                        },
                        iconPath: 'assets/icons/ic_report.png',
                        title: AppLocalizations.of(context)!
                            .translate('home_screening'),
                        backgroundColor: const Color(0x6B8EF4DC),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      RectangularIconWithTitle(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ComingSoonDialog();
                            },
                          );
                        },
                        iconPath: 'assets/icons/ic_drug.png',
                        title: AppLocalizations.of(context)!
                            .translate('remote_monitoring'),
                        backgroundColor: const Color(0xFFD3F2FF),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      RectangularIconWithTitle(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ComingSoonDialog();
                            },
                          );
                        },
                        iconPath: 'assets/icons/ic_lung.png',
                        title: AppLocalizations.of(context)!
                            .translate('2nd_opinion'),
                        backgroundColor: const Color(0x6B8EF4DC),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      title: const Text('Health Profile',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF35C5CF))),
                      subtitle: const Text('Anna Bella.'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              );
                            },
                            child: const Text('View all',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Handle more options action
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('allied_services'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF232F55),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Match the container's border radius
                              child: Image.asset(
                                services[index][
                                    'image']!, // Use the image path from the list
                                height: 72,
                                width: 111,
                                fit: BoxFit
                                    .cover, // Ensure the image fills the box
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            services[index]
                                ['name']!, // Use the name from the list
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  // final Color iconColor;
  final Color titleColor;
  final VoidCallback onTap;

  CircularIconWithTitle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    // required this.iconColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40, // Adjust the radius as needed
            backgroundColor: backgroundColor,
            child: Image.asset(
              iconPath,
              width: 50, // Adjust the size as needed
              height: 50, // Adjust the size as needed
              // color: iconColor.withOpacity(1.0), // Use withOpacity to control opacity
            ),
          ),
          const SizedBox(
              height: 8), // Add some space between the avatar and the title
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class RectangularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  RectangularIconWithTitle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, // Adjust the width as needed
              height: 80, // Adjust the height as needed
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    BorderRadius.circular(15), // Membuat sudut membulat
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 50, // Adjust the size as needed
                  height: 50, // Adjust the size as needed
                ),
              ),
            ),
            const SizedBox(
                height: 8), // Add some space between the avatar and the title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2, // Membatasi teks menjadi 2 baris
              overflow: TextOverflow
                  .ellipsis, // Menambahkan elipsis jika teks terlalu panjang
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputBox extends StatefulWidget {
  @override
  _SearchInputBoxState createState() => _SearchInputBoxState();
}

class _SearchInputBoxState extends State<SearchInputBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          30.0, 20.0, 30.0, 10.0), // Set margin around the entire TextField
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          topRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
        ),
        child: TextField(
          controller: _controller, // Assign the controller to the TextField

          decoration: InputDecoration(
            filled: true, // Enable filling the TextField with a color
            fillColor: Colors.grey[100], // Set the background color to grey
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search action here
                print('Search submitted: ${_controller.text}');
              },
            ),
            hintText: 'Search...',
            border: InputBorder.none, // Remove border
            focusedBorder: InputBorder.none, // Remove border when focused
            enabledBorder: InputBorder.none, // Remove border when enabled
            errorBorder:
                InputBorder.none, // Remove border when there's an error
            disabledBorder: InputBorder.none, // Remove border when disabled
          ),
        ),
      ),
    );
  }
}
