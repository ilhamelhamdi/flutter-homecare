import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m2health/cubit/profiles/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m2health/route/app_router.dart';
import 'package:m2health/views/dashboard.dart';
import 'package:m2health/views/favourites.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:navbar_router/navbar_router.dart';

import 'const.dart';
import 'views/appointment.dart';
import 'views/medical_store.dart';
import './AppLanguage.dart';
import './app_localzations.dart';
import 'package:provider/provider.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppLanguage(),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(appLanguage: appLanguage),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({super.key, required this.appLanguage});
  final List<Color> colors = [Colors.white];

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  static void toggleBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.toggleBottomAppBar();
  }

  static void showBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.showBottomAppBar();
  }

  static void hideBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.hideBottomAppBar();
  }
}

class _MyAppState extends State<MyApp> {
  late AppLocalizations localizations;
  Locale _locale = const Locale('zh');
  bool _showBottomAppBar = false;

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleBottomAppBar() {
    setState(() {
      _showBottomAppBar = !_showBottomAppBar;
    });
  }

  void showBottomAppBar() {
    setState(() {
      _showBottomAppBar = true;
    });
  }

  void hideBottomAppBar() {
    setState(() {
      _showBottomAppBar = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = WidgetsBinding.instance.window.locale;
    localizations = AppLocalizations(_locale);
    localizations.load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppointmentCubit(Dio()),
        ),
      ],
      child: AnimatedBuilder(
        animation: appSetting,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'm2health',
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Const.colorDashboard),
              useMaterial3: true,
            ),
            locale: DevicePreview.locale(context),
            builder: (context, child) {
              return Scaffold(
                body: Stack(
                  children: [
                    DevicePreview.appBuilder(context, child),
                  ],
                ),
                bottomNavigationBar: _showBottomAppBar ? BottomAppBar() : null,
              );
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('id', 'ID'), // Indo
              Locale('zh', ''), // Chinese
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}

AppSetting appSetting = AppSetting();
final List<Color> themeColorSeed = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
  Colors.brown,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lime,
  Colors.amber,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.yellow,
  Colors.grey,
];

class AppSetting extends ChangeNotifier {
  bool isDarkMode;
  Color themeSeed = Colors.blue;

  AppSetting({this.isDarkMode = false});

  void changeThemeSeed(Color color) {
    themeSeed = color;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _resumedFromBackground = false;
  bool _showBottomBar = true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      // Hide BottomBar on the third tab (index 2)
      _showBottomBar = tabController.index != 2;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumedFromBackground = true;
      print("onResume");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_resumedFromBackground) {
          _resumedFromBackground = false;
          return false; // Prevent default back button behavior
        } else {
          return true; // Allow default back button behavior
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: .0), // Adjust the bottom padding as needed
        child: Stack(
          children: [
            BottomBar(
              fit: StackFit.expand,
              icon: (width, height) => Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.grey, // Replace with your unselected color
                    size: width,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(
                  20), // Adjust the border radius as needed
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate,
              showIcon: true,
              width: MediaQuery.of(context).size.width * 0.8,
              barColor: Colors.white, // Replace with your bar color
              start: 2,
              end: 0,
              offset: 10,
              barAlignment: Alignment.bottomCenter,
              iconHeight: 35,
              iconWidth: 35,
              reverse: false,
              barDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              iconDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              hideOnScroll: true,
              scrollOpposite: false,
              onBottomBarHidden: () {},
              onBottomBarShown: () {},
              body: (context, controller) => TabBarView(
                controller: tabController,
                dragStartBehavior: DragStartBehavior.down,
                physics: const BouncingScrollPhysics(),
                children: [
                  Dashboard(),
                  AppointmentPage(),
                  MedicalStorePage(),
                  FavouritesPage(),
                  ProfilePage(), // Add your pages here
                ],
              ),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.home_outlined)),
                  Tab(icon: Icon(Icons.calendar_month_outlined)),
                  Tab(icon: Icon(Icons.add_shopping_cart_outlined)),
                  Tab(icon: Icon(Icons.favorite_border_outlined)),
                  Tab(icon: Icon(Icons.person_outline)),
                ],
                indicatorColor: const Color(0xFF40E0D0), // Warna tosca
              ),
            ),
            if (!_showBottomBar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 0, // Hide BottomBar by setting height to 0
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BottomAppBar extends StatefulWidget {
  const BottomAppBar({Key? key}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<BottomAppBar>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _resumedFromBackground = false;
  bool _showBottomBar = true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      // Hide BottomBar on the third tab (index 2)
      _showBottomBar = tabController.index != 2;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumedFromBackground = true;
      print("onResume");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_resumedFromBackground) {
          _resumedFromBackground = false;
          return false; // Prevent default back button behavior
        } else {
          return true; // Allow default back button behavior
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: .0), // Adjust the bottom padding as needed
        child: Stack(
          children: [
            BottomBar(
              fit: StackFit.expand,
              icon: (width, height) => Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.grey, // Replace with your unselected color
                    size: width,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(
                  20), // Adjust the border radius as needed
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate,
              showIcon: true,
              width: MediaQuery.of(context).size.width * 0.8,
              barColor: Colors.white, // Replace with your bar color
              start: 2,
              end: 0,
              offset: 10,
              barAlignment: Alignment.bottomCenter,
              iconHeight: 35,
              iconWidth: 35,
              reverse: false,
              barDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              iconDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              hideOnScroll: true,
              scrollOpposite: false,
              onBottomBarHidden: () {},
              onBottomBarShown: () {},
              body: (context, controller) => TabBarView(
                controller: tabController,
                dragStartBehavior: DragStartBehavior.down,
                physics: const BouncingScrollPhysics(),
                children: [
                  Dashboard(),
                  AppointmentPage(),
                  MedicalStorePage(),
                  FavouritesPage(),
                  ProfilePage(), // Add your pages here
                ],
              ),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.home_outlined)),
                  Tab(icon: Icon(Icons.calendar_month_outlined)),
                  Tab(icon: Icon(Icons.add_shopping_cart_outlined)),
                  Tab(icon: Icon(Icons.favorite_border_outlined)),
                  Tab(icon: Icon(Icons.person_outline)),
                ],
                indicatorColor: const Color(0xFF40E0D0), // Warna tosca
              ),
            ),
            if (!_showBottomBar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 0, // Hide BottomBar by setting height to 0
                ),
              ),
          ],
        ),
      ),
    );
  }
}
