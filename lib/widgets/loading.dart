import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C2E8A),
      child: const Center(
        child: SpinKitChasingDots(
          color: Color(0xFFFF8C00),
          size: 50,
        ),
      ),
    );
  }
}
