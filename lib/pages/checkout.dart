import 'dart:async';
import 'dart:convert';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import "package:flutter/material.dart";
import 'package:maelys_imo/pages/home.dart';
import "package:webview_flutter/webview_flutter.dart";
import 'package:dio/dio.dart';
import '../api/dio.dart';
import '../provider/auth.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/provider/auth.dart';

class Checkout extends StatefulWidget {
  final String? link;
  final String token;
  final String trans_id;
  final int numberOfMonth;
  final int amount;
  const Checkout(
      {Key? key,
      required this.link,
      required this.token,
      required this.trans_id,
      required this.numberOfMonth,
      required this.amount})
      : super(key: key);
  static const routeName = '/checkout';
  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String tranStatus = "";
  Timer? timer;
  String link = '';
  String status = 'INITIATED';
  @override
  initState() {
    super.initState();
    setState(() {
      link = widget.link ?? 'http://google.com';
    });
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        checkPaymentStatus(timer);
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkPaymentStatus(Timer timer) async {
    try {
      if (status == 'INITIATED') {
        FormData formData = FormData.fromMap(
          {
            "method": "om",
            "numberOfMonth": widget.numberOfMonth,
            "transactionId": widget.trans_id,
            "trans_token": widget.token,
            "amount": widget.amount,
          },
        );
        var token = await Auth().getToken();
        final response = await dio().post(
          'payment-momo-status',
          data: formData,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        Map<String, dynamic> res = jsonDecode(response.toString());
        setState(() {
          status = res['trans_status'];
        });
        if (status == "success") {
          timer.cancel();
          dispose();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
        } else if (!res['status'] && res['message'] == "Paiement Expiré") {
          timer.cancel();
          dispose();
          FancySnackbar.showSnackbar(
            context,
            snackBarType: FancySnackBarType.error,
            title: "Desolé",
            message: "Transaction expiré",
            duration: 4,
            onCloseEvent: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Home()),
                  (Route<dynamic> route) => false);
            },
          );
        } else if (!res['status'] && res['message'] == "Paiement échoué") {
          timer.cancel();
          dispose();
          FancySnackbar.showSnackbar(
            context,
            snackBarType: FancySnackBarType.error,
            title: "Desolé",
            message: "Transaction echoué",
            duration: 4,
            onCloseEvent: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Home()),
                  (Route<dynamic> route) => false);
            },
          );
        }
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Paiement Orange'),
          backgroundColor: const Color(0xFF0C2E8A),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 30.0,
              ),
              onPressed: () {
                FancySnackbar.showSnackbar(
                  context,
                  snackBarType: FancySnackBarType.error,
                  title: "Desolé",
                  message: "Transaction annulé",
                  duration: 4,
                  onCloseEvent: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Home()),
                        (Route<dynamic> route) => false);
                  },
                );
              },
            ),
          ],
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: "${link}",
        ));
  }
}
