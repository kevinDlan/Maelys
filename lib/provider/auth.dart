import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/models/user.dart';
import 'package:maelys_imo/pages/changePassword_page.dart';
import 'package:maelys_imo/pages/login_page.dart';
import 'package:maelys_imo/pages/wrapper.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;
  User? _user;
  final storage = const FlutterSecureStorage();
  bool get authenticated => _authenticated;
  User? get user => _user;
  int? unreadCounter;

  Future login({Map? credentials, required BuildContext ctxt}) async {
    String deviceID = await getDeviceID();
    final response = await dio().post(
      'login',
      data: json.encode(
        credentials!..addAll({"deviceID": deviceID}),
      ),
    );
    Map<String, dynamic> res = jsonDecode(response.toString());
    if (res.containsKey('token')) {
      var token = res['token'];
      await attempt(token);
      await storageToken(token);
      res['fcm_token']!.isNotEmpty ? null : await initPlatform(token);
      Navigator.of(ctxt).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Wrapper()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(ctxt).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
      FancySnackbar.showSnackbar(
        ctxt,
        snackBarType: FancySnackBarType.error,
        title: "Oh! non",
        message: "Mot de passe ou Email incorrect",
        duration: 7,
        onCloseEvent: () {},
      );
    }
  }

  Future attempt(String token) async {
    try {
      final response = await dio().get(
        'auth/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _user = User.fromJson(json.decode(response.toString()));
      _authenticated = true;
      getUserUnreadMessageNumber(token);
    } catch (e) {
      // print(e.toString());
      _authenticated = false;
    }
    notifyListeners();
  }

  Future getToken() async {
    return await storage.read(key: 'auth');
  }

  Future storageToken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future deleteToken() async {
    await storage.delete(key: "auth");
  }

  Future getUserUnreadMessageNumber(String token) async {
    final res = await dio().get("locataire_message",
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    unreadCounter = jsonDecode(res.toString())['totalUnread'];
    notifyListeners();
  }

  Future<void> initPlatform(String token) async {
    try {
      await OneSignal.shared.setAppId("8b1586b7-27b7-4b30-a5eb-85359fb7bccf");
      await OneSignal.shared.getDeviceState().then((value) async {
        FormData formData = FormData.fromMap({'token': value!.userId});
        final resp = await dio().post(
          "store/fcm_token",
          data: formData,
          options: Options(
            headers: {
              // 'auth':true
              'Authorization': 'Bearer $token'
            },
          ),
        );
        var result = jsonDecode(resp.toString());
        if (result["status"] != true) print(result["message"]);
      });
    } catch (error) {
      debugPrint("Erreur ${error.toString()}");
    }
  }

  Future getDeviceID() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      //
    }
    return deviceId;
  }

  Future logout() async {
    var token = await Auth().getToken();
    await dio().delete('logout',
        data: {'deviceID': await getDeviceID()},
        options: Options(headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        }));
    await deleteToken();
    _authenticated = false;
    notifyListeners();
  }

  Future checkPassword({Map? credentials, required BuildContext ctxt}) async {
    String deviceID = await getDeviceID();
    final response = await dio().post(
      'email/check',
      data: json.encode(
        credentials!..addAll({"deviceID": deviceID}),
      ),
    );
    String token = jsonDecode(response.toString())['token'];
    // ignore: unnecessary_null_comparison
    if (token == null) {
    } else {
      Navigator.of(ctxt).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChangeMotDePasse(),
        ),
      );
    }
  }
}
