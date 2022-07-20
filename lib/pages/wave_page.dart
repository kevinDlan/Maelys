import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/home.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaiemenWavePage extends StatefulWidget {
  const PaiemenWavePage({Key? key}) : super(key: key);
  static const route = "/paiement_page";
  @override
  _PaiemenWavePageState createState() => _PaiemenWavePageState();
}

class _PaiemenWavePageState extends State<PaiemenWavePage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  String? telephone;
  bool _loading = false;
  String? lien;
  String? link;

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
    Map<String, dynamic> biens = jsonDecode(response.toString());
    return biens;
  }

  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int? numberOfMonth = 1;
  bool _active = false;
  bool isLink = false;
  int? total;
  String? transId;


  void _launchLink() async {
    var url = Uri.parse("$link");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Impossible de lancer le lien.";
    }
  }

  void boutonNombreMois(value) {
    setState(() {
      numberOfMonth = value;
    });
  }

  void changeAmount({required int rentAmount, required int numberOfMonth}) {
    _active = true;
    setState(() {
      total = rentAmount * numberOfMonth;
    });
  }

  Future paiementApi() async {
    setState(() {
      _loading = true;
    });
    FormData formData = FormData.fromMap({
      "method": "wave",
      "tel": telephone,
      "numberOfMonth": numberOfMonth,
      "amount": 10
    });
    var token = await Auth().getToken();
    final response = await dio().post(
      'payment-momo',
      data: formData,
      options: Options(
        headers: {
          //       // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    //Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res = jsonDecode(response.toString());
    if (res['status'] == true) {
      setState(() {
        _loading = false;
      });
      transId = res['response']['transactionId'];
      numberOfMonth = int.parse(res['response']['numberOfMonth']);
      setState(() {
        link = res['response']['link'];
      });

      if (link!.isNotEmpty) {
        isLink = true;
      }
    } else {
      setState(() {
        _loading = false;
      });
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Paiement echoué",
        message: "Solde mobile money insuffisant",
        duration: 6,
        onCloseEvent: () {},
      );
    }
  }

  @override
  void initState()
  {
    WidgetsBinding.instance.addObserver(this);
    print("WAVE");
    super.initState();
  }

  Future<void> checkPaymentStatus() async
  {
    try {
        FormData formData = FormData.fromMap(
          {
            "method": "wave",
            "numberOfMonth": numberOfMonth,
            "id": transId,
            "amount": total,
          },
        );
        var token = await Auth().getToken();
        final response = await dio().post(
          'payment-momo-status',
          data: formData,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        Map<String, dynamic> res = jsonDecode(response.toString());
        if (res["status"])
        {
          FancySnackbar.showSnackbar(
            context,
            snackBarType: FancySnackBarType.success,
            title: "Succès",
            message: "Paiement Effectué avec succès",
            duration: 4,
          );
          Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
        }else{
          FancySnackbar.showSnackbar(
            context,
            snackBarType: FancySnackBarType.success,
            title: "Erreur",
            message: "Paiement echoué",
            duration: 4,
          );
          Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (route) => false);
        }
    } catch (error)
    {
      print(error);
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Error",
        message: error.toString(),
        duration: 4,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
  {
    print("STATE : $state");
    if(state == AppLifecycleState.resumed)
      {
        //print("Ready to fetch wave API");
        checkPaymentStatus();
      }
  }

  @override
  dispose()
  {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Consumer<Auth>(
            builder: (context, auth, child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Paiement WAVE"),
                  centerTitle: true,
                  backgroundColor: const Color(0xFF0C2E8A),
                ),
                body: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/logo-wave.png',
                                height: 90,
                                width: 90,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Center(
                              child: FutureBuilder<Map>(
                                future: recupBien(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return isLink
                                        ? ElevatedButton(
                                            child: Text(
                                              "Payer maintenant",
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              shadowColor: Colors.black,
                                              elevation: 5,
                                            ),
                                            onPressed: () {
                                              _launchLink();
                                            },
                                          )
                                        : Card(
                                            elevation: 10,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "Loyer",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        NumberFormat.currency(
                                                                locale: 'fr',
                                                                symbol: 'Fcfa',
                                                                decimalDigits:
                                                                    0)
                                                            .format(int.parse(
                                                                snapshot.data![
                                                                    "rent_price"])),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "Retard",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "${snapshot.data!['number_of_month']} Mois",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "Mois a payer",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: SizedBox(
                                                        width: 50,
                                                        child:
                                                            DropdownButton<int>(
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            textStyle:
                                                                const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .black54),
                                                          ),
                                                          value: numberOfMonth,
                                                          items: months
                                                              .map((value) =>
                                                                  DropdownMenuItem<
                                                                      int>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value
                                                                            .toString()),
                                                                  ))
                                                              .toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              numberOfMonth =
                                                                  value;
                                                            });
                                                            changeAmount(
                                                                rentAmount: int
                                                                    .parse(snapshot
                                                                            .data![
                                                                        "rent_price"]),
                                                                numberOfMonth:
                                                                    numberOfMonth!);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "Net à payer",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: _active
                                                          ? Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          'fr',
                                                                      symbol:
                                                                          'Fcfa',
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(
                                                                      total),
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            )
                                                          : Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          'fr',
                                                                      symbol:
                                                                          'Fcfa',
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(int.parse(snapshot
                                                                      .data![
                                                                          "pay_amount"]
                                                                      .toString())),
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Form(
                                                    key: _formKey,
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.5),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.5),
                                                        ),
                                                        prefixIcon: const Icon(
                                                            Icons
                                                                .phone_android),
                                                        labelText:
                                                            'N° WAVE du payeur',
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                      ),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Colors.black87),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 10,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Veuillez entrer un numero WAVE SVP';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        telephone = value;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                      const SizedBox(height: 10.0),

                      ///Button
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            paiementApi();
                          } else {
                            // print('Error');
                          }
                        },
                        child: !isLink
                            ? Material(
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color(0xFFFF8C00),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        ///Icon
                                        Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                        ),

                                        Text(
                                          "PAYER MON LOYER",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]),
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
