import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:maelys_imo/pages/paiement_page.dart';

class AnnulePaiement extends StatefulWidget {
  const AnnulePaiement({Key? key}) : super(key: key);

  @override
  State<AnnulePaiement> createState() => _AnnulePaiementState();
}

class _AnnulePaiementState extends State<AnnulePaiement> {
  _popUp() {
    return FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.success,
      title: "Super",
      message: "Transaction effectué avec succès",
      duration: 8,
      onCloseEvent: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PaiemenPage(),
          ),
        );
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
          'assets/images/index2.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
