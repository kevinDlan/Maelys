import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/widgets/widget_notification.dart';

/// ---------------------------
/// Shaped Light Drawer Drawer widget goes here.
/// ---------------------------
class NotificationPage extends StatefulWidget {
  static const routeName = '/notifycation_page';
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

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
  }

  @override
  Widget build(BuildContext context) {
    return isoffline
        ? const NoInternet()
        : Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: const Color(0xFF0C2E8A),
        centerTitle: true,
      ),
      body: const TextFormFieldExample(),
    );
  }
}