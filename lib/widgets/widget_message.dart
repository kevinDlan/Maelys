import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/loading.dart';

class SimpleTabWithIcon extends StatefulWidget {
  static const routeName = '/SimpleTabWithIcon';

  const SimpleTabWithIcon({Key? key}) : super(key: key);
  @override
  _SimpleTabWithIconState createState() => _SimpleTabWithIconState();
}

class _SimpleTabWithIconState extends State<SimpleTabWithIcon> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  var _objet;
  var _message;
  var statut;

  Future<List> recupMessage() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'locataire/messsages',
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    if ((jsonDecode(response.toString())['message']) == "subscription expire") {
      // ignore: avoid_print
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Désoler!",
        message: "L'abonnement de votre gestionnaire à expiré.",
        duration: 5,
        onCloseEvent: () {},
      );
    }
    List message = jsonDecode(response.toString())['userMessages'];
    return message;
  }

  Future messageAgence() async {
    _loading = true;
    FormData formData =
        FormData.fromMap({"object": _objet, "message": _message});
    var token = await Auth().getToken();
    final response = await dio().post('locataire_message',
        data: formData,
        options: Options(
          headers: {
            // 'auth':true
            'Authorization': 'Bearer $token'
          },
        ));
    // Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res = jsonDecode(response.toString());

    if (res['message'] == 'success') {
      setState(() {
        _loading = false;
      });
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.success,
        title: "Super!",
        message: "Email envoyé avec succès",
        duration: 5,
        onCloseEvent: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SimpleTabWithIcon(),
            ),
          );
        },
      );
    } else {
      setState(() {
        _loading = false;
      });
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Oh! non",
        message: "Envoi echoué",
        duration: 5,
        onCloseEvent: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SimpleTabWithIcon(),
            ),
          );
        },
      );
    }
    // ignore: unnecessary_null_comparison

    // return posts.map((post) => Post.fromJson(post)).toList();
  }

  Future messageUserLu(String id) async {
    //_loading = true;
    FormData formData = FormData.fromMap({"id": id});
    var token = await Auth().getToken();
    final response = await dio().post('message/read',
        data: formData,
        options: Options(
          headers: {
            // 'auth':true
            'Authorization': 'Bearer $token'
          },
        ));
    // Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res = jsonDecode(response.toString());
    if (res['status'] == true) {
    } else {
      setState(() {
        _loading = false;
      });
    }
    // ignore: unnecessary_null_comparison
    // return posts.map((post) => Post.fromJson(post)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _loading
          ? const Loading()
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Message",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF0C2E8A),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.comment, color: Colors.white),
                            Text(
                              ' Reçus',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.mail_outline, color: Colors.white),
                            Text(' Envoi',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      // Tab(
                      //   child: Row(
                      //     children: const <Widget>[
                      //       Icon(Icons.settings, color: Colors.white),
                      //       Text('Settings', style: TextStyle(color: Colors.white)),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  centerTitle: true,
                ),
                body: TabBarView(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(),
                      child: FutureBuilder<List>(
                        future: recupMessage(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              color: const Color(0xFFFFFFFF),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, i) {
                                  statut =
                                      snapshot.data![i]['status'].toString();
                                  DateFormat dateFormat =
                                      DateFormat("yyyy-MM-dd HH:mm:ss");
                                  DateTime dateTime = dateFormat.parse(
                                      "${snapshot.data![i]['delivery_date']}");
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0, vertical: 3.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: Icon(
                                                      Icons.message,
                                                      size: 40,
                                                      color: Color(0xFF0C2E8A),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        child: SizedBox(
                                                          width: 190,
                                                          child: Text(
                                                            "${snapshot.data![i]['msg_subject']}",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              textStyle: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        //snapshot.data![i]['date_paiement'],
                                                        "Reçu le: " +
                                                            DateFormat.yMMMEd(
                                                                    'fr')
                                                                .format(
                                                                    dateTime),
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                      Text(
                                                        'à ' +
                                                            DateFormat.Hm()
                                                                .format(
                                                                    dateTime),
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Statut: ',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              textStyle: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      11.0,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            child: statut == "1"
                                                                ? Container(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              4,
                                                                          bottom:
                                                                              4),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            102,
                                                                            26),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(40.0),
                                                                          topRight:
                                                                              Radius.circular(40.0),
                                                                          bottomLeft:
                                                                              Radius.circular(40.0),
                                                                          bottomRight:
                                                                              Radius.circular(40.0),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Lu",
                                                                          style:
                                                                              GoogleFonts.nunito(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 11.0, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              5,
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              4,
                                                                          bottom:
                                                                              4),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            209,
                                                                            7,
                                                                            7),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(40.0),
                                                                          topRight:
                                                                              Radius.circular(40.0),
                                                                          bottomLeft:
                                                                              Radius.circular(40.0),
                                                                          bottomRight:
                                                                              Radius.circular(40.0),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Non lu",
                                                                          style:
                                                                              GoogleFonts.nunito(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 11.0, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8.0),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (statut == "0") {
                                                      messageUserLu(snapshot
                                                          .data![i]['id']
                                                          .toString());
                                                      setState(() {
                                                        recupMessage();
                                                      });
                                                    }
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            content: Stack(
                                                              clipBehavior:
                                                                  Clip.none,
                                                              children: <
                                                                  Widget>[
                                                                Positioned(
                                                                  right: -40.0,
                                                                  top: -40.0,
                                                                  child:
                                                                      InkResponse(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        const CircleAvatar(
                                                                      child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white),
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xFF0C2E8A),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                    "${snapshot.data![i]['msg_body']}"),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFFF8C00),
                                                    textStyle: const TextStyle(
                                                        fontSize: 11,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                    elevation: 5,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Message",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            //return const Text("Erreur de chargement");
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aucun message disponible",
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
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
                    Container(
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(height: 24.0),
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      filled: true,
                                      icon: Icon(Icons.send),
                                      hintText: "Entrez l'objet du message ici",
                                      labelText: 'Objet *',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Veuillez rempli le champs Objet SVP';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _objet = value;
                                    },
                                    //validator: _validateName,
                                  ),
                                  const SizedBox(height: 24.0),
                                  // "Life story" form.
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Entrez votre message ici',
                                      helperText:
                                          'Votre message au proprietaire / agence.',
                                      labelText: 'Message *',
                                    ),
                                    maxLines: 10,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Veuillez rempli le champs Message SVP';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _message = value;
                                    },
                                  ),
                                  const SizedBox(height: 24.0),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFFF8C00),
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          // _formKey.currentState!.reset();
                                          messageAgence();
                                          _formKey.currentState!.reset();
                                        } else {
                                          //print('Error');
                                        }
                                        //  senddata;
                                      },
                                      child: const Text(
                                        'ENVOYER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
