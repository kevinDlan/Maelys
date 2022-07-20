import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/constant/app_constant.dart';
import 'package:maelys_imo/pages/pdf_page.dart';
import 'package:intl/intl.dart';
import '../provider/auth.dart';

List colors = [Colors.red, Colors.yellow, Colors.blue, Colors.green];

class FactureWidget extends StatefulWidget {
  const FactureWidget({Key? key}) : super(key: key);

  @override
  State<FactureWidget> createState() => _FactureWidgetState();
}

class _FactureWidgetState extends State<FactureWidget> {
  String? mafacture;
  Future<List> recupTransaction() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'payments',
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    List infos = jsonDecode(response.toString());
    return infos;
  }

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    //final hauteur = MediaQuery.of(context).size.height;
    return SizedBox(
      width: largeur * 1.0,
      child: FutureBuilder<List>(
        future: recupTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: const Color(0xFFFF8C00),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i) {
                  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                  DateTime dateTime =
                      dateFormat.parse("${snapshot.data![i]['date_paiement']}");
                  mafacture = snapshot.data![i]['receipt_link'];
                  return mafacture != null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 3.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.blueAccent,
                                            foregroundColor: Colors.blueAccent,
                                            backgroundImage: NetworkImage(
                                                "https://maelys-imo.com/img/logo_maelys.png"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mois: ' +
                                                  months[int.parse(snapshot
                                                          .data![i]['mois']) -
                                                      1],
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Text(
                                              "N° 45862-34",
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Text(
                                              //snapshot.data![i]['date_paiement'],
                                              DateFormat.yMMMEd('fr')
                                                  .format(dateTime),
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            Text(
                                              'à ' +
                                                  DateFormat.Hm()
                                                      .format(dateTime),
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PdfPage(
                                                link: appBaseUrl +
                                                    "${snapshot.data![i]['receipt_link']}",
                                              ),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFF8C00),
                                          textStyle: const TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic),
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Détail",
                                          style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Facture non disponible",
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
                },
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
