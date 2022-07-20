import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/pages/home.dart';
import 'package:maelys_imo/pages/passeoublie_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/BHColors.dart';
import 'package:maelys_imo/widgets/BHConstants.dart';
import 'package:maelys_imo/widgets/loading.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = "/login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool visible = false;
  String err = '';
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  var _email;
  var _password;
  bool _showPassword = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  StreamSubscription? connection;
  bool isoffline = false;
  bool _loading = false;

  void submit() {
    setState(() {
      _loading = true;
    });
    Provider.of<Auth>(context, listen: false).login(
        credentials: {'email': _email, 'password': _password}, ctxt: context);

    /// Navigator.pop(context);
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

    // ignore: todo
    // TODO: implement initState
    super.initState();
    _testInternetConnect();
// Instantiate NewVersion manager object (Using GCP Console app as example)
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
    return isoffline
        ? const NoInternet()
        : _loading
            ? const Loading()
            : Consumer<Auth>(builder: (context, auth, child) {
                if (auth.authenticated) {
                  return const Home();
                } else {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 24),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/logo_maelys.png',
                                height: 150,
                                width: 150,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 200),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)),
                              color: Color(0xFF0C2E8A),
                            ),
                            child: SingleChildScrollView(
                              //reverse: true,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Connexion",
                                      style: GoogleFonts.arizonia(
                                          textStyle: const TextStyle(
                                              fontSize: 54,
                                              color: Colors.white)),
                                      //TextStyle(fontSize: 24, color: Colors.white)
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    ///////////////////////////////////////////////////////
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: BHAppDividerColor),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: BHColorPrimary),
                                        ),
                                        labelText: "Email",
                                        labelStyle: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              color: Color(0xFFFF8C00),
                                              fontSize: 20),
                                        ),
                                        errorStyle: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez rempli le champs Email SVP';
                                        }
                                        if (!emailRegex.hasMatch(value)) {
                                          return 'Veuillez entrez un Email valide SVP';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _email = value;
                                      },
                                    ),
                                    ///////////////////////////////////////////////////
                                    TextFormField(
                                      focusNode: passWordFocusNode,
                                      obscureText: !_showPassword,
                                      keyboardType: TextInputType.text,
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Mot de passe",
                                        labelStyle: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              color: Color(0xFFFF8C00),
                                              fontSize: 20),
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showPassword = !_showPassword;
                                            });
                                          },
                                          child: Icon(
                                              _showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: BHColorPrimary,
                                              size: 20),
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: BHAppDividerColor),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: BHColorPrimary),
                                        ),
                                        errorStyle: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez rempli le champs Mot de passe SVP';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _password = value;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PasseOublie()));
                                        },
                                        child: Text(
                                          BHTxtForgetPwd,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            //print(email);
                                            //print(password);
                                            //print(code);
                                            //print(id);
                                            // getData();
                                            submit();
                                          } else {
                                            //print('Error');
                                          }
                                          //  senddata;
                                        },
                                        child: Text(
                                          BHBtnSignIn,
                                          style: GoogleFonts.crimsonText(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: BHAppDividerColor,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                          ),
                                        ),
                                        Text(
                                          BHTxtOrSignIn,
                                          style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: BHAppDividerColor,
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/bh_facebookIcon.svg',
                                            height: 40,
                                            width: 40),
                                        SvgPicture.asset(
                                            'assets/images/bh_twitterIcon.svg',
                                            height: 40,
                                            width: 40),
                                        SvgPicture.asset(
                                            'assets/images/bh_pinterestIcon.svg',
                                            height: 40,
                                            width: 40),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              });
  }
}
