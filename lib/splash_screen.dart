import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'scrol_page.dart';

class MySplahsPage extends StatefulWidget {
  const MySplahsPage({Key? key}) : super(key: key);

  @override
  _MySplahsPageState createState() => _MySplahsPageState();
}

class _MySplahsPageState extends State<MySplahsPage> {
  StreamSubscription? connection;
  bool isoffline = false;
  int? isViewed = 0;

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
    Timer(
      const Duration(seconds: 4),
      () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ScrollPage()),
          (Route<dynamic> route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  child: Image.asset(
                    'assets/images/logo_maelys.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Center(
                child: SizedBox(
                  height: 10,
                ),
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
