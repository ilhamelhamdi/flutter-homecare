import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homecare/cubit/profiles/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_homecare/route/app_router.dart';
import 'package:flutter_homecare/views/dashboard.dart';
import 'package:flutter_homecare/views/favourites.dart';
import 'package:navbar_router/navbar_router.dart';

import 'const.dart';
import 'views/appointment.dart';
import 'views/medical_store.dart';
import './AppLanguage.dart';
import './app_localzations.dart';
import 'package:provider/provider.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class NavigationHistory {
  static List<BuildContext> _history = [];

  static void addContext(BuildContext context) {
    _history.add(context);
  }

  static BuildContext? getPreviousContext() {
    if (_history.length > 1) {
      // Return the second last context in the history
      return _history[_history.length - 2];
    }
    return null;
  }
}

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

void selectTab(int index) {
  NavbarNotifier.index = index;
}

void routeTab(String route, int index) {
  NavbarNotifier.pushNamed(route, index);
  NavbarNotifier.index = 0;
}

void navbarVisibility(bool status) {
  NavbarNotifier.hideBottomNavBar = status;
  if (status == true) {
    NavbarNotifier.hideBottomNavBar = false;
    if (NavbarNotifier.isNavbarHidden) {
      NavbarNotifier.hideBottomNavBar = false;
    }
  } else {
    NavbarNotifier.hideBottomNavBar = true;
    if (NavbarNotifier.isNavbarHidden) {
      NavbarNotifier.hideBottomNavBar = true;
    }
  }
}

void changeLang(BuildContext context, String lang) {
  var appLanguage = Provider.of<AppLanguage>(context, listen: false);
  appLanguage.changeLanguage(Locale(lang));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({required this.appLanguage});
  final List<Color> colors = [Colors.white];

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  late AppLocalizations localizations;
  Locale _locale = const Locale('zh');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
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
    return AnimatedBuilder(
      animation: appSetting,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'flutter_homecare',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Const.colorDashboard),
            useMaterial3: true,
          ),
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('id', 'ID'), // Indo
            const Locale('zh', ''), // Chinese
          ],
          routerConfig: router,
        );
      },
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

  List<NavbarItem> items = [];

  // final Map<int, Map<String, Widget>> _routes = {
  //   0: {
  //     '/': Dashboard(),
  //   },
  //   1: {
  //     '/': Products(),
  //   },
  //   2: {
  //     '/': Distributors(),
  //   },
  //   3: {
  //     '/': Outsourcing(),
  //   },
  //   4: {
  //     '/': Outsourcing(),
  //   },
  // };

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 5, vsync: this);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   initializeNavbarItems();
  // }

  // void initializeNavbarItems() {
  //   items = [
  //     NavbarItem(IconMedmap.home, 'Home'),
  //     NavbarItem(IconMedmap.products, 'Products'),
  //     NavbarItem(IconMedmap.distributors, 'Distributors'),
  //     NavbarItem(IconMedmap.tenders, 'Tenders'),
  //     NavbarItem(IconMedmap.tenders, 'More'),
  //   ];
  // }

  @override
  void dispose() {
    NavbarNotifier.clear();
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
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
    final size = MediaQuery.of(context).size;
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
        child: BottomBar(
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(icon: Icon(Icons.home_outlined)),
              Tab(icon: Icon(Icons.schedule_outlined)),
              Tab(icon: Icon(Icons.add_shopping_cart_outlined)),
              Tab(icon: Icon(Icons.favorite_border_outlined)),
              Tab(icon: Icon(Icons.person_outline)),
            ],
          ), // A floating tab bar
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
          borderRadius:
              BorderRadius.circular(20), // Adjust the border radius as needed
          duration: Duration(seconds: 1),
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
            borderRadius:
                BorderRadius.circular(20), // Adjust the border radius as needed
          ),
          iconDecoration: BoxDecoration(
            color: Colors.blue, // Replace with your current page color
            borderRadius:
                BorderRadius.circular(20), // Adjust the border radius as needed
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
        ),
      ),
    );
  }
}

class ComingSoonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Coming Soon'),
      content: Text('This feature is coming soon.'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ComingSoonDialog();
    },
  );
}
