import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maelys_imo/pages/notifycation_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/routes/app_route.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true); // optional: set false to disable printing logs to console

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();
  // This widget is the root of your application.

  Future<void> initOS() async
  {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("8b1586b7-27b7-4b30-a5eb-85359fb7bccf");
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result)
    {
         Navigator.pushNamed(context, NotificationPage.routeName);
    });
  }


  @override
  void initState()
  {
    super.initState();
    initOS();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
        debugShowCheckedModeBanner: false,
        title: 'Maelys imo',
        initialRoute: '/',
        routes: routes);
  }
}
