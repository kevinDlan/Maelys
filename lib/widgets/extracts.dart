import 'package:flutter/material.dart';

class URL {
  static const String url = "https://magicrecharges.com/api_maelys-imo/";
}

class SignContainer extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool;

  const SignContainer(
      {Key? key, required this.controller, required this.label, this.bool})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: bool,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8D33B6)),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8D33B6)),
          ),
        ),
      ),
    );
  }
}

class LoginRegisterButton extends StatelessWidget {
  const LoginRegisterButton(
      {required this.accountText,
      required this.textButton,
      required this.onClick});

  final String accountText;
  final String textButton;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          accountText,
          style: const TextStyle(
            color: Color(0xFF8D33B6),
          ),
        ),
        FlatButton(
          textColor: const Color(0xFF8D33B6),
          child: Text(
            textButton,
            style: const TextStyle(fontSize: 20),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
