import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/constant/app_constant.dart';
import 'package:maelys_imo/provider/auth.dart';

void main() {
  runApp(const TransactionWidget());
}

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
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
          // print(snapshot.data);
          if (snapshot.hasData) {
            return Container(
              color: const Color(0xFFFF8C00),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        snapshot.data![i]['moyen_paiement'],
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black54),
                        ),
                      ),
                      subtitle: Text(
                        'Montant = ' +
                            NumberFormat.currency(
                                    locale: 'fr',
                                    symbol: 'Fcfa',
                                    decimalDigits: 0)
                                .format(
                              int.parse(snapshot.data![i]['montant']),
                            ) +
                            ' Mois = ' +
                            months[int.parse(snapshot.data![i]['mois']) - 1],
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black54),
                        ),
                      ),
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
