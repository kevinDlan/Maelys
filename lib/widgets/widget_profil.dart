import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maelys_imo/api/dio.dart';
import 'package:maelys_imo/pages/home.dart';
import 'package:maelys_imo/provider/auth.dart';
import 'package:maelys_imo/widgets/BHColors.dart';
import 'package:maelys_imo/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Profile1Widget extends StatefulWidget {
  const Profile1Widget({Key? key}) : super(key: key);

  @override
  _Profile1WidgetState createState() => _Profile1WidgetState();
}

class _Profile1WidgetState extends State<Profile1Widget>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  var telephone;
  var motDePasse;
  var idUser;

  File? _image;
  var imagePicker;
  bool _loading = false;

  // Fonction permettant de prendre une photo avec la caméra du téléphone
  Future getImageCamera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    }
  }

  // Fonction permettant de charger une image depuis la gallerie photo
  Future getImageGallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    }
  }

  // Future uploadImage() async {
  //   //show your own loading or progressing code here
  //   //String uploadurl = "${URL.url}upload_image.php";
  //   final url = Uri.parse(
  //       "https://geeksp3.com/tialao/emaraichers/admin/traitements/uploadproducts.php");
  //   //Uri url = Uri.parse(uploadurl);
  //   var request = http.MultipartRequest('POST', url);
  //   request.fields['telephone'] = telephone;
  //   request.fields['motDePasse'] = motDePasse;
  //   request.fields['id_user'] = idUser;
  //   var picture = await http.MultipartFile.fromPath('image', _image!.path);
  //   request.files.add(picture);
  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Image Uploaded');
  //     print(request.fields['aboutImage']);
  //   } else {
  //     print('Image Not Uploaded');
  //   }
  //   setState(() {});
  // }

  Future updateProfile() async {
    setState(() {
      _loading = true;
    });
    FormData formData = FormData.fromMap(
        {"password": motDePasse, "contact": telephone, "profil": _image});
    var token = await Auth().getToken();
    final response = await dio().post(
      'update/profil',
      data: formData,
      options: Options(
        headers: {
          // 'auth':true
          'Authorization': 'Bearer $token'
        },
      ),
    );
    // Bool isUser = json.decode(response.toString());
    Map<String, dynamic> res = jsonDecode(response.toString());
    if (res["msg"] == "success") {
      setState(() {
        _loading = false;
      });
      Auth().attempt(token);
      FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.success,
        title: "Super !",
        message: "Profil mis a jour avec succès",
        duration: 5,
        onCloseEvent: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => route.isFirst);
          //setState(() {});
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
  }

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Scaffold(
        body: _loading
            ? const Loading()
            : Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                          height: 170.0,
                          color: Colors.white,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: new Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        if (_image != null)
                                          Container(
                                              width: 120.0,
                                              height: 120.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  image: FileImage(
                                                    _image!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ))
                                        else
                                          Container(
                                            width: 120.0,
                                            height: 120.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                image: new ExactAssetImage(
                                                    'assets/images/ml_profile_Image.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 70.0, right: 100.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new CircleAvatar(
                                            backgroundColor: Color(0xFFFF8C00),
                                            radius: 25.0,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                              ),
                                              tooltip: 'Increase volume by 10',
                                              onPressed: () {
                                                setState(() {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 150.0),
                                                      builder: (context) =>
                                                          Column(
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    const Icon(
                                                                  Icons
                                                                      .camera_alt_rounded,
                                                                  color:
                                                                      BHColorPrimary,
                                                                ),
                                                                title: const Text(
                                                                    'Utiliser la camera'),
                                                                onTap: () {
                                                                  getImageCamera();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              ListTile(
                                                                leading:
                                                                    const Icon(
                                                                  Icons.image,
                                                                  color:
                                                                      BHColorPrimary,
                                                                ),
                                                                title: const Text(
                                                                    'Utiliser la galerie'),
                                                                onTap: () {
                                                                  getImageGallery();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ));
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Form(
                              key: _formKey,
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 5.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Information personnelle',
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            _status
                                                ? _getEditIcon()
                                                : new Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'ID locataire',
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                "${auth.user?.code.toString()}",
                                            decoration: const InputDecoration(
                                                hintText: ""),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.black54),
                                            ),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Nom',
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                "${auth.user?.name.toString()} ${auth.user?.lastname.toString()}",
                                            decoration: const InputDecoration(
                                              hintText: "Entrez votre nom",
                                            ),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.black54),
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Email',
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                "${auth.user?.email.toString()}",
                                            decoration: const InputDecoration(
                                                hintText: "Entrer votre email"),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.black54),
                                            ),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Téléphone',
                                              style: GoogleFonts.montserrat(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            initialValue:
                                                "${auth.user?.contact.toString()}",
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Entrer le numéro de mobile"),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.black54),
                                            ),
                                            enabled: !_status,
                                            onSaved: (value) {
                                              telephone = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Mot de passe',
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                    color: Color(0xFFFF8C00),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            obscureText: !_showPassword,
                                            decoration: InputDecoration(
                                              hintText: "***************",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _showPassword =
                                                        !_showPassword;
                                                  });
                                                },
                                                child: Icon(
                                                    _showPassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.black54,
                                                    size: 20),
                                              ),
                                            ),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Colors.black54),
                                            ),
                                            enabled: !_status,
                                            onSaved: (value) {
                                              motDePasse = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !_status
                                      ? _getActionButtons(auth)
                                      : new Container(),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      );
    });

    ////
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(Auth auth) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: new ElevatedButton(
                child: new Text(
                  "Valider",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    updateProfile();
                    auth.user!.contact = telephone;
                  } else {
                    // print('Error');
                  }
                },
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: new ElevatedButton(
                child: new Text(
                  "Annuler",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFFFF8C00),
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
