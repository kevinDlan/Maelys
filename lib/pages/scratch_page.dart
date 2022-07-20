import 'package:flutter/material.dart';
import 'package:maelys_imo/pages/home.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:provider/provider.dart';

class ScratchPage extends StatefulWidget {
  const ScratchPage({Key? key}) : super(key: key);
  @override
  State<ScratchPage> createState() => _ScratchPageState();
}

class _ScratchPageState extends State<ScratchPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return auth.authenticated ? const Home() : const LoginPage();
    });
  }
}
