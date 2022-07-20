import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:maelys_imo/pages/paiement_page.dart';

class SuccesPaiement extends StatefulWidget {
  const SuccesPaiement({Key? key}) : super(key: key);

  @override
  State<SuccesPaiement> createState() => _SuccesPaiementState();
}

class _SuccesPaiementState extends State<SuccesPaiement> {
  _popUp() {
    return FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.success,
      title: "Super",
      message: "Transaction effectué avec succès",
      duration: 8,
      onCloseEvent: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PaiemenPage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _popUp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 254, 254, 255),
      child: Center(
        child: Image.asset(
          'assets/images/index.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
