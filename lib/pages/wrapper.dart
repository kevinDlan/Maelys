import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import 'home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  static String route = 'wrapper';
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final storage = const FlutterSecureStorage();
  bool isLogin = false;
  StreamSubscription? connection;
  bool isoffline = false;

  @override
  void initState() {
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
    _attemptAuthentication();
    Timer(const Duration(seconds: 2), () {
      if (!Provider.of<Auth>(context, listen: false).authenticated) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
            (Route<dynamic> route) => false);
      }
    });
  }

  void _attemptAuthentication() async {
    final key = await storage.read(key: 'auth');
    await Provider.of<Auth>(context, listen: false).attempt(key ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Scaffold(
        backgroundColor: const Color(0xFF0C2E8A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              // logo here
              Image.asset(
                'assets/images/logo_maelys-blanc.png',
                height: 120,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(
                height: 70.0,
                width: 30,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      );
    });
  }
}
