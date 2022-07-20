import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/annulepeiment_page.dart';
import 'package:maelys_imo/pages/succespeiment_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:ndialog/ndialog.dart';

class PaiemenMtnPage extends StatefulWidget {
  const PaiemenMtnPage({Key? key}) : super(key: key);
  static const route = "/paiement_page";
  @override
  _PaiemenMtnPageState createState() => _PaiemenMtnPageState();
}

class _PaiemenMtnPageState extends State<PaiemenMtnPage> {
  final _formKey = GlobalKey<FormState>();
  String? telephone;
  bool _loading = false;

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
  late String transStatus;
  Timer? timer;
  bool _active = false;
  int? total;

  @override
  void initState() {
    super.initState();
    recupBien2();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  Future<void> checkpaiementApi(int stnbsmois, String transactionId) async {
    FormData formData = FormData.fromMap(
      {
        "method": "momo",
        "numberOfMonth": stnbsmois,
        "transactionId": transactionId
      },
    );
    var token = await Auth().getToken();
    final response = await dio().post(
      'payment-momo-status',
      data: formData,
      options: Options(
        headers: {
          //       // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    //Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res02 = jsonDecode(response.toString());
    if (res02['status']) {
      setState(() => transStatus = res02['trans_status']);
    }
  }

  Future paiementApi() async {
    setState(() {
      _loading = true;
    });
    FormData formData = FormData.fromMap({
      "method": "momo",
      "tel": telephone,
      "numberOfMonth": _nombreMois,
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
        transStatus = res['response']['status'];
      });
      String transactionId = res['response']['transactionId'];
      int stnbsmois = int.parse(res['response']['numberOfMonth']);
      if (transStatus == 'PENDING') {
        Timer.periodic(
          const Duration(seconds: 3),
          (timer) {
            if (transStatus == 'success') {
              timer.cancel();
              dispose();
              //setState(() => transStatus = res02['trans_status']);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SuccesPaiement(),
                ),
              );
            } else if (transStatus == 'FAILED') {
              timer.cancel();
              dispose();
              //setState(() => transStatus = res02['trans_status']);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AnnulePaiement(),
                ),
              );
            } else {
              checkpaiementApi(stnbsmois, transactionId);
            }
          },
        );
        // cron.schedule(Schedule.parse('*/3 * * * * *'), () async {
        //   checkpaiementApi(stnbsmois, transactionId);
        // });
        ProgressDialog progressDialog = ProgressDialog(
          context,
          dismissable: false,
          blur: 5,
          dialogTransitionType: DialogTransitionType.Shrink,
          title: const Text("Title"),
          message: const Text("Message"),
        );
        progressDialog.setLoadingWidget(const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF0C2E8A)),
        ));
        progressDialog
            .setMessage(const Text("Veuillez validé votre paiement au *133#"));
        progressDialog.setTitle(const Text("Paiement"));
        progressDialog.show();
        //await Future.delayed(const Duration(seconds: 5));
        //progressDialog.dismiss();

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
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Consumer<Auth>(
            builder: (context, auth, child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Paiement MTN"),
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
                                'assets/images/logo_mtn.jpg',
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
                                    return Card(
                                      elevation: 10,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Loyer",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  NumberFormat.currency(
                                                          locale: 'fr',
                                                          symbol: 'Fcfa',
                                                          decimalDigits: 0)
                                                      .format(
                                                    int.parse(snapshot
                                                        .data!["pay_amount"]),
                                                  ),
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        //fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Retard",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "0" " Mois",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        //fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Mois a payer",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 50,
                                                  child: DropdownButton<int>(
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle: const TextStyle(
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 15.0,
                                                          color: Colors.black54),
                                                    ),
                                                    value: _nombreMois,
                                                    items: nombreMois
                                                        .map((value) =>
                                                            DropdownMenuItem<
                                                                int>(
                                                              value: int.parse(
                                                                  value),
                                                              child:
                                                                  Text(value),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _nombreMois = value;
                                                        changeMontant(
                                                            _nombreMois);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Net à payer",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: _active
                                                    ? Text(
                                                        NumberFormat.currency(
                                                                locale: 'fr',
                                                                symbol: 'Fcfa',
                                                                decimalDigits:
                                                                    0)
                                                            .format(
                                                          int.parse(
                                                            total.toString(),
                                                          ),
                                                        ),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
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
                                                                locale: 'fr',
                                                                symbol: 'Fcfa',
                                                                decimalDigits:
                                                                    0)
                                                            .format(
                                                          int.parse(snapshot
                                                                  .data![
                                                              "pay_amount"]),
                                                        ),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          textStyle:
                                                              const TextStyle(
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.5),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .transparent),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.5),
                                                    ),
                                                    prefixIcon: const Icon(
                                                        Icons.phone_android),
                                                    labelText:
                                                        'N° MTN du payeur',
                                                    filled: true,
                                                    fillColor: Colors.blue[50],
                                                    hintText: '05 40 50 12 10'),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black87),
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      !(value.substring(0, 2) ==
                                                          "05")) {
                                                    return 'Veuillez entrer un numero MTN SVP';
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
                          }
                        },
                        child: Material(
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
                                    "Payer Mon Loyer",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
