import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/widget_contact.dart';

/// ---------------------------
/// Shaped Light Drawer Drawer widget goes here.
/// ---------------------------
class ContactPage extends StatefulWidget {
  static const routeName = '/contact_page';
  const ContactPage({Key? key}) : super(key: key);
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  StreamSubscription? connection;
  bool isoffline = false;

  Future<Map<String, dynamic>> recupInfoContact() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'manager/info',
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    Map<String, dynamic> infos = jsonDecode(response.toString());
    return infos;
  }

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
    recupInfoContact();
  }

  @override
  Widget build(BuildContext context) {
    return isoffline
        ? const NoInternet()
        : Scaffold(
            key: _key,
            appBar: AppBar(
              //backgroundColor: Colors.indigo.withOpacity(0.9),
              title: const Text('Contact'),
              backgroundColor: const Color(0xFF0C2E8A),
              centerTitle: true,
            ),
            body: const About1(),
          );
  }
}
