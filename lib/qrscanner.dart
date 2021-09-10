import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QRScan(),
            ));
          },
          child: Text('qrView'),
        ),
      ),
    );
  }
}

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool _isFlashActive = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    print(":: reassemble ::");
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner Example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 10, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Add Custom button Here',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),

                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),*/
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /*Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )*/

                      /*Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return Text('loading');
                                }
                              },
                            )),
                      )*/
                    ],
                  ),*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(alignment: Alignment.center, children: [
      Flexible(
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 5,
              borderLength: 15,
              borderWidth: 5,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height / 2 * 0.15,
        child: Container(
          child: Text(
            'Custom QR Scanner',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
      Positioned(
        bottom: MediaQuery.of(context).size.height / 2 * 0.10,
        child: IconButton(
            iconSize: 35.0,
            icon: (_isFlashActive
                ? const Icon(
                    Icons.flash_on,
                  )
                : const Icon(Icons.flash_off)),
            color: Colors.white,
            onPressed: _checkFlashActive),
      )
    ]);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        this.result = scanData;
        this.parseResult();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _checkFlashActive() {
    controller?.toggleFlash();
    setState(() {});
    controller?.getFlashStatus().then((value) async {
      print(value);
      _isFlashActive = value!;
      setState(() {});
    });
  }

  Route _qrResultLayoutRoute(result) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScanResult(resultData: result),
        transitionDuration: Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  parseResult() async {
    print(":: parseResult ::");
    print(result?.code);
    print("Result value");
    print("Inside parseresult");
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    if (result?.code != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanResult(resultData: result)));
    }
  }
}

class ScanResult extends StatefulWidget {
  final resultData;

  const ScanResult({
    Key? key,
    this.resultData,
  }) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  @override
  Widget build(BuildContext context) {
    print(":: ScanResult ::");
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Result Page'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScan()),
              );
            },
          ),
        ),
        body: Center(
            child: Column(children: [
          Text(describeEnum(widget.resultData!.format)),
          Text(widget.resultData!.code)
        ])));
  }
}
