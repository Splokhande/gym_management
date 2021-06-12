import 'package:firebase_core/firebase_core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paldes/modal/Attendance.dart';
import 'package:paldes/modal/User.dart';
import 'package:paldes/routes.dart';
import 'package:paldes/User_module/screens/splash.dart';
import 'package:paldes/themeProvider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // Status bar style on Android/iOS
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  await core.Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDetailsAdapter());
  Hive.registerAdapter(AttendanceAdapter());
  await Hive.openBox<Attendance>('attendance');

  // FirebaseApp defaultApp = Firebase.app();
  runApp(ProviderScope(child: MainPage()));

}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DarkThemeProvider themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
    await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(414, 896),
      builder: () => MaterialApp(
        title: 'Paldes',
        theme: Styles.themeData(false, context),
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        home: SplashScreen(),
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
