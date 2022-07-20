import 'dart:isolate';
import 'dart:ui';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import "package:flutter/material.dart";
import 'package:maelys_imo/pages/home.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfPage extends StatefulWidget {
  final String? link;
  const PdfPage({Key? key, this.link}) : super(key: key);
  static const routeName = '/pdf_page';
  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
  int progress = 0;
  final ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0C2E8A),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final status = await Permission.storage.request();
              final nameFile = "Reçu " + DateTime.now().toIso8601String();
              if (status.isGranted) {
                final externalDir = await getExternalStorageDirectory();
                final id = await FlutterDownloader.enqueue(
                  url: widget.link.toString(),
                  savedDir: externalDir!.path,
                  fileName: nameFile,
                  showNotification: true,
                  openFileFromNotification: true,
                );
              } else {
                print("Permission accordée");
              }
            },
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _pdfViewerController.zoomLevel = 1.25;
            },
            icon: const Icon(
              Icons.zoom_in,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: widget.link != null
          ? SfPdfViewer.network("${widget.link}",
              controller: _pdfViewerController, key: _pdfViewerStateKey)
          : FancySnackbar.showSnackbar(
              context,
              snackBarType: FancySnackBarType.error,
              title: "Oh! non",
              message: "Paiement échoué",
              duration: 7,
              onCloseEvent: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF8C00),
        onPressed: () async {
          final status = await Permission.storage.request();
          final nameFile = "Reçu " + DateTime.now().toIso8601String();
          if (status.isGranted) {
            final externalDir = await getExternalStorageDirectory();
            final id = await FlutterDownloader.enqueue(
              url: widget.link.toString(),
              savedDir: externalDir!.path,
              fileName: nameFile,
              showNotification: true,
              openFileFromNotification: true,
            );
          } else {
            print("Permission accordée");
          }
        },
        tooltip: 'Télécharger un fichier',
        child: const Icon(Icons.download),
      ),
    );
  }
}
