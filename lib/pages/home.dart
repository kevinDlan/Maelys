import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/constant/app_constant.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/pages/contratdebaie_page.dart';
import 'package:maelys_imo/pages/facture_page.dart';
import 'package:maelys_imo/pages/paiement_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maelys_imo/pages/scratch_page.dart';
import 'package:maelys_imo/pages/transaction_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'dart:async';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:maelys_imo/widgets/widget_Drawer.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// ---------------------------
/// Shaped Light Drawer Drawer widget goes here.
/// ---------------------------
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = "/home";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  final storage = const FlutterSecureStorage();
  // ignore: non_constant_identifier_names
  String? file_path;

  StreamSubscription? connection;
  bool isoffline = false;

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

  Future<List> recupImageSlider() async {
    var token = await Auth().getToken();
    final response = await dio().get(
      'adds',
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

  void getUnreadTotal() async {
    var token = await Auth().getToken();
    Provider.of<Auth>(context, listen: false).getUserUnreadMessageNumber(token);
    print("Comeback");
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
    _testInternetConnect();
    super.initState();
  }

  Future<void> _testInternetConnect() async {
    final newVersion = NewVersion(
      iOSId: '',
      //androidId: 'com.groupmagicconceptsarl.kpy',
    );
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'MIS A JOUR DISPO !!!',
        dismissButtonText: "Plus tard",
        dialogText: "Veuillez mettre votre app à jour version " +
            " ${status.localVersion} " +
            " A " +
            " ${status.storeVersion}",
        updateButtonText: "Mettre à jour",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    final hauteur = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Consumer<Auth>(builder: (context, auth, child) {
      if (auth.authenticated) {
        file_path = auth.user!.photopath;
        //auth.authenticated ? storeFCMToken() : null;
        // Future <List<dynamic>> listeImage = recupImageSlider();
        return isoffline
            ? const NoInternet()
            : WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: Scaffold(
                  key: _key,
                  appBar: AppBar(
                    //backgroundColor: Colors.indigo.withOpacity(0.9),
                    title: const Text('Tableau de bord'),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _key.currentState?.openDrawer();
                        getUnreadTotal();
                      },
                    ),
                    backgroundColor: const Color(0xFF0C2E8A),
                  ),

                  /// ----------------
                  /// Building drawer here .
                  /// ---------------
                  drawer: buildDrawer(context, auth.unreadCounter),

                  /// ----------------
                  /// Main Content .
                  /// ---------------
                  body: DoubleBackToCloseApp(
                    snackBar: const SnackBar(
                      backgroundColor: Color(0xFFFF8C00),
                      content: Text(
                        'Appuyez à nouveau pour quitter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            height: size.height * .3,
                            width: size.width * 1.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.topCenter,
                                image: AssetImage(
                                    'assets/images/maelys_dasch2.png'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 64,
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: file_path != null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "https://www.maelys-imo.com/${auth.user?.photopath}",
                                                  placeholder: (context, url) =>
                                                      const SpinKitFadingCircle(
                                                    color: Color(0xFF0C2E8A),
                                                    size: 40,
                                                  ),
                                                  imageBuilder:
                                                      (context, image) =>
                                                          CircleAvatar(
                                                    backgroundImage: image,
                                                    radius: 50,
                                                  ),
                                                )
                                              : const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/ml_profile_Image.png'),
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${auth.user?.name.toString()} ${auth.user?.lastname.toString()}",
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              '${auth.user?.email.toString()}',
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ///////////
                                FutureBuilder<List>(
                                  builder: (ctx, snapshot) {
                                    // Checking if future is resolved or not
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      // If we got an error
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            '${snapshot.error} occured',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        );
                                        // if we got our data
                                      } else if (snapshot.hasData) {
                                        // Extracting data from snapshot object
                                        final data = snapshot.data as List;
                                        if (data.isNotEmpty) {
                                          return CarouselSlider.builder(
                                            itemCount: data.length,
                                            options: CarouselOptions(
                                              autoPlay: true,
                                              aspectRatio: 2.0,
                                              enlargeCenterPage: true,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index, int realIndex) {
                                              const SizedBox(
                                                height: 200,
                                              );
                                              return Center(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: CachedNetworkImage(
                                                        imageUrl: appBaseUrl +
                                                            data[index]['url'],
                                                        fit: BoxFit.cover,
                                                        width: 1000,
                                                        placeholder: (context,
                                                                url) =>
                                                            const SpinKitFadingCircle(
                                                              color: Color(
                                                                  0xFF0C2E8A),
                                                              size: 40,
                                                            ))),
                                              );
                                            },
                                          );
                                        } else {
                                          return const SpinKitFadingCircle(
                                            color: Color(0xFF0C2E8A),
                                            size: 50,
                                          );
                                        }
                                      } else {
                                        // Displaying LoadingSpinner to indicate waiting state
                                        return const SpinKitFadingCircle(
                                          color: Color(0xFFFF8C00),
                                          size: 50,
                                        );
                                      }
                                    } else {
                                      // Displaying LoadingSpinner to indicate waiting state
                                      return const SpinKitFadingCircle(
                                        color: Color(0xFFFF8C00),
                                        size: 50,
                                      );
                                    }
                                  },
                                  // Future that needs to be resolved
                                  // inorder to display something on the Canvas
                                  future: auth.authenticated
                                      ? recupImageSlider()
                                      : null,
                                ),
                                //////////////
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      color: const Color(0xFF0C2E8A),
                                      shadowColor: const Color(0xFF0C2E8A),
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: hauteur * .13,
                                        width: largeur * .46,
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PaiemenPage()));
                                          },
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.clean_hands_sharp,
                                                size: 40.0,
                                                color: Color(0xFFFF8C00),
                                              ),
                                              Text(
                                                "Payer mon loyer",
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: const Color(0xFF0C2E8A),
                                      shadowColor: const Color(0xFF0C2E8A),
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      semanticContainer: true,
                                      child: Container(
                                        height: hauteur * .13,
                                        width: largeur * .46,
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TransactionPage()),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.loop,
                                                size: 40.0,
                                                color: Color(0xFFFF8C00),
                                              ),
                                              Text(
                                                "Transactions",
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      color: const Color(0xFF0C2E8A),
                                      shadowColor: const Color(0xFF0C2E8A),
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      semanticContainer: true,
                                      child: Container(
                                        height: hauteur * .13,
                                        width: largeur * .46,
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const FacturePage(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.description,
                                                size: 40.0,
                                                color: Color(0xFFFF8C00),
                                              ),
                                              Text(
                                                "Reçus",
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: const Color(0xFF0C2E8A),
                                      shadowColor: const Color(0xFF0C2E8A),
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: hauteur * .13,
                                        width: largeur * .46,
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ContratPage(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.description_outlined,
                                                size: 40.0,
                                                color: Color(0xFFFF8C00),
                                              ),
                                              Text(
                                                "Contrat de bail",
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, top: 0, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Dernière transaction',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TransactionPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Tout afficher',
                                          style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.black54),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: largeur * 1.0,
                                  // height: hauteur * 0.37,
                                  padding: const EdgeInsets.all(5),
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        SizedBox(height: hauteur * 0.015),
                                        FutureBuilder<List>(
                                          future: auth.authenticated
                                              ? recupTransaction()
                                              : null,
                                          builder: (context, snapshot) {
                                            // print(snapshot.data);
                                            if (snapshot.hasData) {
                                              return Container(
                                                color: const Color(0xFFFF8C00),
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      snapshot.data?.length,
                                                  itemBuilder: (context, i) {
                                                    return Card(
                                                      child: ListTile(
                                                        title: Text(
                                                          "Mode : " +
                                                              snapshot.data![i][
                                                                  'moyen_paiement'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            textStyle: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Montant = ' +
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          'fr',
                                                                      symbol:
                                                                          'Fcfa',
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(
                                                                int.parse(snapshot
                                                                    .data![i][
                                                                        'montant']
                                                                    .toString()),
                                                              ) +
                                                              ' Mois = ' +
                                                              months[int.parse(
                                                                      snapshot.data![
                                                                              i]
                                                                          [
                                                                          'mois']) -
                                                                  1],
                                                          style: GoogleFonts
                                                              .nunito(
                                                            textStyle: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Erreur de chargement");
                                            }
                                            //return const CircularProgressIndicator();
                                            return const SpinKitFadingCircle(
                                              color: Color(0xFFFF8C00),
                                              size: 50,
                                            );
                                          },
                                        ),
                                        SizedBox(height: hauteur * 0.015),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/logo_maelys.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const Text("Version : 1.0.1"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      } else {
        return const ScratchPage();
      }
    });
  }

  /// ---------------------------
  /// Building divider for drawer .
  /// ---------------------------

}

/// ------------------
/// for shaping the drawer. You can customize it as your own
/// ------------------
