import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/mtn_page.dart';
import 'package:maelys_imo/pages/orange_page.dart';
import 'package:maelys_imo/pages/wave_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:provider/provider.dart';


class PaiemenPage extends StatefulWidget {
  const PaiemenPage({Key? key}) : super(key: key);
  static const route = "/paiement_page";
  @override
  _PaiemenPageState createState() => _PaiemenPageState();
}

class _PaiemenPageState extends State<PaiemenPage> {
  bool noSubscription = false;

  Future<Map<String, dynamic>> recupBien() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'locataire-status',
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if ((jsonDecode(response.toString())['message']) == "subscription expire") {
      setState(() {
        noSubscription = true;
      });
    }

    Map<String, dynamic> biens = jsonDecode(response.toString());
    return biens;
  }

  late Map<String, dynamic> bien;
  Future recupBien2() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'locataire-status',
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    Map<String, dynamic> biens2 = jsonDecode(response.toString());
    setState(() {
      bien = biens2;
    });
  }

  List<String> nombreMois = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  int? _nombreMois = 1;
  bool _active = false;
  int? total;
  // Affiche un message lorsque l'abonnement du gestionnaire à expiré.

  Future<dynamic> fancySnackbarMessageErreur() async {
    await FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.error,
      title: "Désoler!",
      message: "L'abonnement de votre gestionnaire à expiré.",
      duration: 5,
      onCloseEvent: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    recupBien2();
  }

  void boutonNombreMois(value) {
    setState(() {
      _nombreMois = value;
    });
  }

  void changeMontant(_nombreMois) {
    _active = true;
    setState(() {
      total = (int.parse(bien['pay_amount']) * _nombreMois) as int?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mode de paiement"),
            centerTitle: true,
            backgroundColor: const Color(0xFF0C2E8A),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/logo_maelys.png',
                        height: 120,
                        width: 120,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: FutureBuilder<Map>(
                        future: recupBien(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (noSubscription) {
                                                fancySnackbarMessageErreur();
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PaiemenOrangePage()));
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/logo_orange.jpg',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                const Text('ORANGE'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (noSubscription) {
                                                fancySnackbarMessageErreur();
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PaiemenMtnPage()));
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/logo_mtn.jpg',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                const Text('MTN'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Card(
                                  //   color: Colors.white,
                                  //   child: Container(
                                  //     padding: const EdgeInsets.all(5),
                                  //     child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         InkWell(
                                  //           onTap: () {
                                  //             if (noSubscription) {
                                  //               fancySnackbarMessageErreur();
                                  //             } else {
                                  //               showToast('Bientôt disponible',
                                  //                   duration: 3);
                                  //               // Navigator.of(context).push(
                                  //               //     MaterialPageRoute(
                                  //               //         builder: (context) =>
                                  //               //             const PaiemenMoovPage()));
                                  //             }
                                  //           },
                                  //           child: Row(
                                  //             children: [
                                  //               Image.asset(
                                  //                 'assets/images/logo_moov.jpg',
                                  //                 height: 60,
                                  //                 width: 60,
                                  //               ),
                                  //               const SizedBox(
                                  //                 width: 30,
                                  //               ),
                                  //               const Text('MOOV'),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PaiemenWavePage()));
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/logo-wave.png',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                const Text('WAVE'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Erreur de chargement",
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
                          return const SpinKitFadingCircle(
                            color: Color(0xFFFF8C00),
                            size: 50,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
