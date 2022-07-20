import 'package:flutter/cupertino.dart';
import 'package:maelys_imo/no_internet.dart';
import 'package:maelys_imo/pages/changePassword_page.dart';
import 'package:maelys_imo/pages/contact_page.dart';
import 'package:maelys_imo/pages/contratdebaie_page.dart';
import 'package:maelys_imo/pages/facture_page.dart';
import 'package:maelys_imo/pages/home.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:maelys_imo/pages/message_page.dart';
import 'package:maelys_imo/pages/notifycation_page.dart';
import 'package:maelys_imo/pages/paiement_page.dart';
import 'package:maelys_imo/pages/passeoublie_page.dart';
import 'package:maelys_imo/pages/pdf_page.dart';
import 'package:maelys_imo/pages/profil_page.dart';
import 'package:maelys_imo/pages/transaction_page.dart';
import 'package:maelys_imo/scrol_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (ctx) => const ScrollPage(),
  "/login_page": (ctx) => const LoginPage(),
  "/home": (ctx) => const Home(),
  "/change_password": (ctx) => const ChangeMotDePasse(),
  "/passe_oublie": (ctx) => const PasseOublie(),
  "/no_internet": (ctx) => const NoInternet(),
  "/paiement_page": (ctx) => const PaiemenPage(),
  "/transaction_page": (ctx) => const TransactionPage(),
  "/facture_page": (ctx) => const FacturePage(),
  "/contratdebail_page": (ctx) => const ContratPage(),
  "/profil_page": (ctx) => const PageProfilPage(),
  "/message_page": (ctx) => const MessagePage(),
  "/notifycation_page": (ctx) => const NotificationPage(),
  "/contact_page": (ctx) => const ContactPage(),
  "/pdf_page": (ctx) => const PdfPage(),
};
