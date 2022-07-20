import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/pages/contact_page.dart';
import 'package:maelys_imo/pages/message_page.dart';
import 'package:maelys_imo/pages/profil_page.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:provider/provider.dart';

Widget buildDrawer(BuildContext context, unreadMsgCounter) {
  String? filePath;
  const String image = 'assets/images/ml_profile_Image.png';
  return ClipPath(
    /// ---------------------------
    /// Building Shape for drawer .
    /// ---------------------------
    clipper: OvalRightBorderClipper(),

    /// ---------------------------
    /// Building drawer widget .
    /// ---------------------------
    child: Drawer(
      child: Consumer<Auth>(builder: (context, auth, child) {
        filePath = auth.user!.photopath;
        //auth.authenticated ? scheduleTask() : null;
        return Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: const BoxDecoration(
              color: Color(0xFF0C2E8A),
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            /// ---------------------------
            /// Building scrolling  content for drawer .
            /// ---------------------------
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                    ),
                  ),

                  /// Building header for drawer .
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFFF8C00)]),
                    ),
                    child: filePath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                "https://www.maelys-imo.com/${auth.user?.photopath}",
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 150,
                            ),
                          )
                        : const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(image),
                          ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "${auth.user?.name.toString()} ${auth.user?.lastname.toString()}",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    "${auth.user?.email.toString()}",
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white54),
                    ),
                  ),

                  /// Building items list  for drawer .
                  const SizedBox(height: 30.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: _buildRow(Icons.home, "Accueil"),
                  ),
                  _buildDivider(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PageProfilPage()));
                    },
                    child: _buildRow(Icons.person_pin, "Mon profil"),
                  ),
                  _buildDivider(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MessagePage()));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.message,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Messages',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 17.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.deepOrange,
                              elevation: 5.0,
                              shadowColor: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                width: 25,
                                height: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  "$unreadMsgCounter",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ])),
                  // _buildDivider(),
                  _buildDivider(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ContactPage()));
                    },
                    child: _buildRow(Icons.email, "Nous contacter"),
                  ),
                  _buildDivider(),
                  // InkWell(
                  //   onTap: () {
                  //     createMaelysImoNotification(
                  //         body:
                  //             "Bonjour Monsieur Daniel, rappel paiement du loyer - Mois d'avril.");
                  //   },
                  //   child: _buildRow(Icons.alarm, "Test-Notification"),
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );
}

Divider _buildDivider() {
  final Color divider = Colors.grey.shade600;
  return Divider(
    color: divider,
  );
}

/// ---------------------------
/// Building item  for drawer .
/// ---------------------------
Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
  TextStyle tStyle = GoogleFonts.montserrat(
    textStyle: const TextStyle(fontSize: 17.0, color: Colors.white),
  );
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        const Spacer(),
        if (showBadge)
          Material(
            color: Colors.deepOrange,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Text(
                "10+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    ),
  );
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
