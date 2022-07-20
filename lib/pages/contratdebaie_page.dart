import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// ---------------------------
/// Shaped Light Drawer Drawer widget goes here.
/// ---------------------------
class ContratPage extends StatefulWidget {
  static const routeName = '/contratdebail_page';

  const ContratPage({Key? key}) : super(key: key);

  @override
  State<ContratPage> createState() => _ContratPageState();
}

class _ContratPageState extends State<ContratPage> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  int progress = 0;

  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  StreamSubscription? connection;
  bool isoffline = false;
  String? link;

  Future<Map<String, dynamic>> recupContratBail() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'contrat',
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

    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isoffline
        ? const NoInternet()
        : Scaffold(
            appBar: AppBar(
              //   //backgroundColor: Colors.indigo.withOpacity(0.9),
              title: const Text('Contrat de bail'),
              backgroundColor: const Color(0xFF0C2E8A),
              centerTitle: true,
            ),
            body: FutureBuilder<Map>(
              future: recupContratBail(),
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasData) {
                  link = snapshot.data!["contrat_bail_link"];
                  if (link == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Contrat de bail non disponible",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SpinKitFadingCircle(
                            color: Color(0xFFFF8C00),
                            size: 50,
                          )
                        ],
                      ),
                    );
                  } else {
                    return SfPdfViewer.network("https://maelys-imo.com/$link",
                        controller: _pdfViewerController,
                        key: _pdfViewerStateKey);
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aucun contrat de baie disponible",
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SpinKitFadingCircle(
                          color: Color(0xFFFF8C00),
                          size: 50,
                        )
                      ],
                    ),
                  );
                }
                //return const CircularProgressIndicator();
                return const SpinKitFadingCircle(
                  color: Color(0xFFFF8C00),
                  size: 50,
                );
              },
            ),
          );
  }
}
