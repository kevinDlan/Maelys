import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/changePassword_page.dart';
import 'package:maelys_imo/widgets/BHColors.dart';
import 'package:maelys_imo/widgets/BHConstants.dart';
import 'package:maelys_imo/widgets/loading.dart';

import '../provider/auth.dart';

class PasseOublie extends StatefulWidget {
  const PasseOublie({Key? key}) : super(key: key);

  static const routeName = "/passe_oublie";

  @override
  State<PasseOublie> createState() => _PasseOublieState();
}

class _PasseOublieState extends State<PasseOublie> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  var _email;
  bool _loading = false;

  Future checkPassword() async {
    setState(() {
      _loading = true;
    });
    FormData formData = FormData.fromMap({"email": _email});
    var token = await Auth().getToken();
    final response = await dio().post(
      'email/check',
      data: formData,
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    // Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res = jsonDecode(response.toString());
    if (res.containsKey('isUser')) {
      setState(() {
        _loading = false;
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ChangeMotDePasse(email: _email)),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _loading = false;
      });
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Oh! non",
        message: "Adresse email introuvable",
        duration: 5,
        onCloseEvent: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return _loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Mot de passe oublié',
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFF0C2E8A),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      SvgPicture.asset('assets/images/passeoublie.svg',
                          height: 123, width: 125),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(BHTxtForgotPwd,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: BHAppTextColorPrimary)),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(BHForgotPasswordSubTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: BHAppTextColorSecondary, fontSize: 14)),
                      const SizedBox(
                        height: 8,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: BHAppDividerColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF8C00),
                              ),
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Color(0xFFFF8C00), fontSize: 20),
                            errorStyle: TextStyle(color: Colors.red),
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
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            primary: BHColorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              //print(_email);
                              //print(password);
                              checkPassword();
                            } else {
                              //print('Error');
                            }
                          },
                          child: const Text(
                            BHBtnSend,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
