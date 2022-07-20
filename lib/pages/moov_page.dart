import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/loading.dart';
import 'package:provider/provider.dart';

class PaiemenMoovPage extends StatefulWidget {
  const PaiemenMoovPage({Key? key}) : super(key: key);
  static const route = "/paiement_page";
  @override
  _PaiemenMoovPageState createState() => _PaiemenMoovPageState();
}

class _PaiemenMoovPageState extends State<PaiemenMoovPage> {
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
  bool _active = false;
  int? total;

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

  Future paiementApi() async {
    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Consumer<Auth>(
            builder: (context, auth, child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Paiement MOOV"),
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
                                'assets/images/logo_moov.jpg',
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
                                                      // boutonNombreMois(value);
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
                                                            color: Colors.blue),
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
                                                      'N° MOOV du payeur',
                                                  filled: true,
                                                  fillColor: Colors.blue[50],
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black87),
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 10,
                                                validator: (value) {
                                                  if (value!.isEmpty || !(value.substring(0, 2) == "01")) return 'Veuillez entrer un numero MOOV SVP';
                                                  return "";
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
                            //print('Error');
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
                                    "PAYER MON LOYER",
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
