import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:maelys_imo/pages/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'no_internet.dart';

/// App widget class.
class ScrollPage extends StatefulWidget {
  const ScrollPage({Key? key}) : super(key: key);
  static const routeName = "/scrol_page";
  // Making list of pages needed to pass in IntroViewsFlutter constructor.
  @override
  State<ScrollPage> createState() => _ScrollPage();
}

class _ScrollPage extends State<ScrollPage> {
  StreamSubscription? connection;
  bool isoffline = false;
  int? isViewed = 0;

  Future<void> _onboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isViewed = prefs.getInt('onBoard');
    });
  }

  _storeOnboardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', 1);
  }

  @override
  void initState() {
    _onboarded();
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
  }

  final pages = [
    PageViewModel(
      pageColor: const Color(0xFF0C2E8A),
      // iconImageAssetPath: 'assets/air-hostess.png',
      bubble: Image.asset('assets/images/point.png'),
      body: const Text(
        'Bienvenue sur votre application de paiements de loyer MAELYS-IMO',
      ),
      title: const Text(
        '',
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: SvgPicture.asset('assets/images/bienvenue_1.svg',
          height: 350, width: 400),
    ),
    PageViewModel(
      pageColor: const Color(0xFFFF8C00),
      iconImageAssetPath: 'assets/images/point.png',
      body: const Text(
        'Payer son loyer devient plus simple',
      ),
      title: const Text(''),
      mainImage: SvgPicture.asset('assets/images/paiement_loyer.svg',
          height: 350, width: 400),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Color(0xFF0C2E8A),
              Color(0xFFFF8C00),
            ],
          ),
        ),
      ),
      iconImageAssetPath: 'assets/images/point.png',
      body: const Text(
        '',
      ),
      title: const Text(''),
      mainImage:
          SvgPicture.asset('assets/images/maison.svg', height: 350, width: 400),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return isViewed == 1
        ? const Wrapper()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Maelys imo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: isoffline
                ? const NoInternet()
                : Builder(
                    builder: (context) => IntroViewsFlutter(
                      pages,
                      showNextButton: true,
                      showBackButton: true,
                      onTapDoneButton: () {
                        _storeOnboardInfo();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      pageButtonTextStyles: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
          );
  }
}
