import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/provider/auth.dart';

class About1 extends StatefulWidget {
  static const routeName = '/About1';
  const About1({Key? key}) : super(key: key);

  @override
  State<About1> createState() => _About1State();
}

class _About1State extends State<About1> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[_buildInfo1(), _buildInfo3()],
        ),
      ),
    );
  }

  Widget _buildInfo1() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/logo_maelys.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'MAELYS IMO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text("Version"),
                subtitle: Text("1.0.1"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInfo3() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Center(
            child: FutureBuilder<Map>(
              future: recupInfoContact(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: const Text(
                          'Entreprise || Propriétaire',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFF8C00),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: Text(
                          snapshot.data!["name"],
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          "Achat, vente, location",
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.alternate_email),
                        title: Text(
                          snapshot.data!["email"],
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                        ),
                        //subtitle: Text("non loin"),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(
                          snapshot.data!["adress"],
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data!["city"],
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(
                          snapshot.data!["contact"],
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
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
          ),
        ),
      ),
    );
  }
}
