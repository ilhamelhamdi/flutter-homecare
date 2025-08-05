// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/app_localzations.dart';
// import 'package:m2health/cubit/personal/personal_page.dart';
// import 'package:m2health/cubit/provider/provider_cubit.dart';
// import 'package:m2health/cubit/provider/provider_state.dart';
// import 'package:m2health/models/service_config.dart';
// import 'package:m2health/route/app_routes.dart';
// import 'package:m2health/main.dart';
// import 'package:m2health/views/health_coaching.dart';
// import 'package:m2health/views/search/search_professional_new.dart';
// import 'package:m2health/widgets/provider_card.dart';
// import 'package:m2health/widgets/service_widgets.dart';
// import 'package:m2health/widgets/chat_pharma.dart';
// import 'package:m2health/services/provider_service.dart';
// import 'package:dio/dio.dart';

// class PharmaServices extends StatefulWidget {
//   @override
//   _PharmaServicesState createState() => _PharmaServicesState();
// }

// class _PharmaServicesState extends State<PharmaServices> {
//   late ProviderCubit _providerCubit;

//   @override
//   void initState() {
//     super.initState();
//     _initializeProvider();
//   }

//   void _initializeProvider() {
//     final config = ServiceConfig.pharmacist();
//     final providerService = ProviderService(Dio());
//     _providerCubit = ProviderCubit(providerService, config);
//     _providerCubit.loadProviders();
//   }

//   @override
//   void dispose() {
//     _providerCubit.close();
//     super.dispose();
//   }

//   void _navigateToProviderSearch(String serviceTitle) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SearchPage(
//           config: ServiceConfig.pharmacist(),
//           initialServiceTitle: serviceTitle,
//         ),
//       ),
//     );
//   }

//   // Service data
//   final List<Map<String, String>> pharmacistServices = [
//     {
//       'title': 'Medication Counseling\nand Education',
//       'description':
//           'Medication counseling and education guide\npatients on proper use, side effects, and\nadherence to prescriptions,\nenhancing safety and\nimproving health outcomes.',
//       'imagePath': 'assets/icons/ilu_pharmacist.png',
//       'color': 'F79E1B',
//       'opacity': '0.1',
//       'serviceTitle': 'Medication Counseling',
//     },
//     {
//       'title': 'Comprehensive Therapy\nReview',
//       'description':
//           'Comprehensive review of your medication\nand lifestyle to optimize treatment\noutcomes and minimize potential side\neffects',
//       'imagePath': 'assets/icons/ilu_therapy.png',
//       'color': 'B28CFF',
//       'opacity': '0.2',
//       'serviceTitle': 'Therapy Review',
//     },
//     {
//       'title': 'Health Coaching',
//       'description':
//           'Personalized guidance and support to help\nindividuals achieve their health goals, manage\nchronic conditions, and improve overall well-\nbeing, with specialized programs for weight\nmanagement, diabetes management, high\nblood pressure management, and high\ncholesterol management',
//       'imagePath': 'assets/icons/ilu_coach.png',
//       'color': '9AE1FF',
//       'opacity': '0.33',
//       'serviceTitle': 'Health Coaching',
//     },
//     {
//       'title': 'Smoking Cessation',
//       'description':
//           'Smoking cessation involves quitting\nsmoking through strategies like\ncounseling, medications, and support\nprograms to improve health and\nreduce the risk of smoking-related\ndiseases.',
//       'imagePath': 'assets/icons/ilu_lung.png',
//       'color': 'FF9A9A',
//       'opacity': '0.19',
//       'serviceTitle': 'Smoking Cessation',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppLocalizations.of(context)!.translate('pharmacist_services2'),
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) => _providerCubit,
//         child: Container(
//           margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Service selection cards
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: pharmacistServices.length,
//                   itemBuilder: (context, index) {
//                     final service = pharmacistServices[index];
//                     return ServiceSelectionCard(
//                       title: service['title']!,
//                       description: service['description']!,
//                       imagePath: service['imagePath']!,
//                       color: Color(int.parse('0xFF${service['color']!}')),
//                       opacity: double.parse(service['opacity']!),
//                       onTap: () => _handleServiceTap(context, index, service),
//                     );
//                   },
//                   separatorBuilder: (context, index) => SizedBox(height: 8),
//                 ),
//               ),

//               // Add a section to show available providers
//               BlocBuilder<ProviderCubit, ProviderState>(
//                 builder: (context, state) {
//                   if (state is ProviderLoading) {
//                     return Container(
//                       padding: EdgeInsets.all(16),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }

//                   if (state is ProviderLoaded && state.providers.isNotEmpty) {
//                     return Container(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Available Pharmacists',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 12),
//                           Container(
//                             height: 200,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: state.providers.take(3).length,
//                               itemBuilder: (context, index) {
//                                 final provider = state.providers[index];
//                                 return Container(
//                                   width: 160,
//                                   margin: EdgeInsets.only(right: 12),
//                                   child: ProviderCard(
//                                     provider: provider,
//                                     onTap: () => _navigateToProviderSearch(
//                                         'All Services'),
//                                     onFavoriteToggle: (provider) {
//                                       _providerCubit
//                                           .toggleFavorite(provider.id);
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           TextButton(
//                             onPressed: () =>
//                                 _navigateToProviderSearch('All Services'),
//                             child: Text(
//                               'View All Pharmacists',
//                               style: TextStyle(
//                                 color: Color(0xFF35C5CF),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return SizedBox.shrink();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleServiceTap(
//       BuildContext context, int index, Map<String, String> service) {
//     switch (index) {
//       case 0: // Medication Counseling
//         _navigateToProviderSearch(service['serviceTitle']!);
//         break;
//       case 1: // Comprehensive Therapy Review
//         _navigateToProviderSearch(service['serviceTitle']!);
//         break;
//       case 2: // Health Coaching
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HealthCoaching(),
//           ),
//         );
//         break;
//       case 3: // Smoking Cessation
//         _navigateToProviderSearch(service['serviceTitle']!);
//         break;
//       default:
//         _navigateToProviderSearch('All Services');
//     }
//   }
// }

// // Legacy support for existing PharmaDetailPage
// class PharmaDetailPage extends StatefulWidget {
//   final Map<String, String> item;

//   PharmaDetailPage({Key? key, required this.item}) : super(key: key);

//   @override
//   _PharmaDetailPageState createState() => _PharmaDetailPageState();
// }

// class _PharmaDetailPageState extends State<PharmaDetailPage> {
//   final TextEditingController _chatController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Map<String, dynamic>> _chatHistory = [];

//   void _sendMessage() {
//     if (_chatController.text.isNotEmpty) {
//       setState(() {
//         _chatHistory.add({
//           "message": _chatController.text,
//           "isSender": true,
//         });
//         _chatController.clear();
//       });

//       // Simulate a response from the other side
//       Future.delayed(Duration(seconds: 1), () {
//         setState(() {
//           _chatHistory.add({
//             "message": "This is a dummy response",
//             "isSender": false,
//           });
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChatPharma(
//       chatHistory: _chatHistory,
//       chatController: _chatController,
//       scrollController: _scrollController,
//       sendMessage: _sendMessage,
//     );
//   }
// }
