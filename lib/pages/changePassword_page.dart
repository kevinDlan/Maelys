import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/BHColors.dart';
import 'package:maelys_imo/widgets/BHConstants.dart';

class ChangeMotDePasse extends StatefulWidget {
  final String? email;
  const ChangeMotDePasse({
    Key? key,
    this.email,
  }) : super(key: key);

  static const routeName = '/change_password';

  @override
  State<ChangeMotDePasse> createState() => _ChangeMotDePasseState();
}

class _ChangeMotDePasseState extends State<ChangeMotDePasse> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showPassword01 = false;
  FocusNode passWordFocusNode = FocusNode();

  bool _loading = false;
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  var _password01;
  var _password02;

  Future resetPassword() async {
    if (_password01 == _password02) {
      FormData formData =
          FormData.fromMap({"password": _password02, "email": widget.email});
      var token = await Auth().getToken();
      final response = await dio().post('password/reset',
          data: formData,
          options: Options(
            headers: {
              // 'auth':true
              'Authorization': 'Bearer $token'
            },
          ));
      // Bool isUser = json.decode(response.toString());
      Map<String, dynamic> res = jsonDecode(response.toString());
      if (res['message'] == 'Password reset successfuly.') {
        setState(() {
          _loading = false;
        });
        FancySnackbar.showSnackbar(
          context,
          snackBarType: FancySnackBarType.success,
          title: "Super",
          message: "Mot de passe changé avec succès veuillez vous connecté",
          duration: 5,
          onCloseEvent: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false);
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
          message: "Adresse email introuvable",
          duration: 5,
          onCloseEvent: () {},
        );
      }
    } else {
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "Oh! non",
        message: "Mot de passe non identique",
        duration: 5,
        onCloseEvent: () {},
      );
    }
    // ignore: unnecessary_null_comparison
    // return posts.map((post) => Post.fromJson(post)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Changer votre passe',
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
                SvgPicture.asset('assets/images/passord_reset.svg',
                    height: 153, width: 125),
                const SizedBox(
                  height: 20,
                ),
                const Text(BHTxtResetPwd,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: BHAppTextColorPrimary)),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  BHResetPasswordTitle,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: BHAppTextColorSecondary, fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: passWordFocusNode,
                        obscureText: !_showPassword,
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: const TextStyle(
                              color: Color(0xFFFF8C00), fontSize: 20),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: BHColorPrimary),
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez rempli le champs Mot de passe SVP';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password01 = value;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        obscureText: !_showPassword01,
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          labelText: "Confirmer mot de passe",
                          labelStyle: const TextStyle(
                              color: Color(0xFFFF8C00), fontSize: 20),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPassword01 = !_showPassword01;
                              });
                            },
                            child: Icon(
                                _showPassword01
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: BHColorPrimary,
                                size: 20),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: BHColorPrimary),
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez rempli le champs Confirme passe SVP';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password02 = value;
                        },
                      ),
                    ],
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
                        resetPassword();
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
