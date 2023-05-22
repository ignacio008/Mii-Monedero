import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Firebase/fetch_data.dart';
import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/camionesModel.dart';
import 'package:mega_monedero/Models/codeModel.dart';
import 'package:mega_monedero/Models/scaneosTotal.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/loginScreen.dart';
import 'package:mega_monedero/Screens/screenQrFinal.dart';
import 'package:mega_monedero/Screens/screenQrResult.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

import 'package:qrscan/qrscan.dart' as scanner;

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class QRCodeScreen extends StatefulWidget {
  double latitud;
  double longitud;
  UserModel userModel;
  QRCodeScreen({this.latitud, this.longitud, this.userModel});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _showSpinner = false;
  final double barHeight = 50.0;
  int isActive;
  String textInactive =
      "La suscripción de su tarjeta no ha sido activada o ya ha caducado, para poder utilizarla un chofer autorizado dentro de la plataforma podrá escanear y activar de nuevo su tarjeta";
  String textActive = "Su tarjeta se encuentra activa y caduca el día: ";
  String textString;
  String myCode;
  CodeModel codeModel;

  String id_variable = "";
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id_variable =
        List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return id_variable;
  }

  List<CamionesModel> iconModelList = [];

  void getlista(String idScanner) async {
    iconModelList = await FetchData().getScanner(idScanner);
    setState(() {});
    print('Tengo ventas ${iconModelList.length} cards');
    DateTime now = DateTime.now();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenQrFinal(
                  userModel: widget.userModel,
                  isActive: isActive,
                  camionesModel: iconModelList[0],
                )));

    bool erroguardar = await QuerysService().SaveGeneralInfoScaneos(
      reference: "Scaneos",
      id: id_variable,
      collectionValues: ScaneosModel().toJsonBodyScaner(
          id_variable,
          iconModelList[0].idCamionero,
          widget.userModel.id,
          widget.userModel.locality,
          widget.userModel.state,
          now,
          widget.userModel.urlProfile,
          widget.userModel.email,
          idScanner,
          widget.userModel.activeUntil),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    generateRandomString(12);
    DateTime now = DateTime.now();
    isActive = now.compareTo(widget.userModel.activeUntil);

    if (isActive == 1) {
      textString = textInactive;
    } else {
      String formattedDate2 =
          DateFormat('dd-MM-yyyy').format(widget.userModel.activeUntil);
      textString = '${textActive}      ${formattedDate2}';
    }

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.userModel.activeUntil);

    codeModel = CodeModel(id: widget.userModel.id, dateTime: formattedDate);
    myCode = json.encode(codeModel.toMap());
    print(myCode);
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            child: Center(
              child: Text(
                "MII MONEDERO",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    MyColors.Colors.colorRedBackgroundDark,
                    MyColors.Colors.colorRedBackgroundLight
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.69,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        widget.userModel == null
                            ? "Bienvenido"
                            : "Bienvenido " + widget.userModel.name,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 2.0),

                      SizedBox(
                        height: 10.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/fondo_negro.jpg",
                          image: widget.userModel.urlProfile,
                          fit: BoxFit.cover,
                          width: 100.0,
                          height: 100.0,
                          fadeInDuration: Duration(milliseconds: 1000),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //   child: Text(
                      //     widget.userModel.name,
                      //     style: TextStyle(
                      //         fontSize: 22.0,
                      //         fontWeight: FontWeight.bold,
                      //       color: MyColors.Colors.colorBackgroundDark
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 15.0,
                      ),
                      // Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      // child: Text(
                      //   textString,
                      //   style: TextStyle(
                      //       fontSize: 16.0,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 180,
                        child: Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              // String cameraScanResult = await scanner.scan();
                              String cameraScanResult =
                                  await FlutterBarcodeScanner.scanBarcode(
                                      '#ff6666',
                                      'Cancel',
                                      true,
                                      ScanMode.BARCODE);
                              print(
                                  "el resuktado de la camara es ${cameraScanResult}");
                              if (cameraScanResult.length >= 10) {
                                _processUserScan(cameraScanResult);
                              } else {
                                print(
                                    "Lo sentimos no has selecionado un codigo QR valido");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  left: 40.0,
                                  right: 40.0,
                                  bottom: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.red[800],
                                ),
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 80.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Escanear código",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      widget.userModel == null
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                _showAlertCerrarSesion();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                      //color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          color: MyColors
                                              .Colors.colorRedBackgroundDarkD,
                                          width: 2.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Center(
                                      child: Text(
                                        "Cerrar Sesión",
                                        style: TextStyle(
                                            color: MyColors
                                                .Colors.colorRedBackgroundDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertCerrarSesion() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Cerrar Sesión",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "¿Está seguro de querer cerrar sesión?",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            "Cancelar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          child: Text(
            "Aceptar",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Authentication().singOut();
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          latitude: widget.latitud,
                          longitude: widget.longitud,
                        )));
          },
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _processUserScan(String data) {
    CodeModel codeModel = CodeModel.fromJson(jsonDecode(data));
    if (codeModel.dateTime == null) {
      print("holasssssssssssssssssssssssssssssssssssssssssss");
      print("el id de qr del camion es: ${codeModel.id}");

      print("el id de qr del camion es: ${codeModel.state}");

      DateTime now = DateTime.now();
      isActive = now.compareTo(widget.userModel.activeUntil);

      if (widget.userModel.state == codeModel.state &&
          widget.userModel.locality == codeModel.locality) {
        print("Exito estado y municipio iguales");

        if (isActive == 1) {
          getlista(codeModel.id);
           Toast.show("Lo sentimos no eatas Activo", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // textString = textInactive;
          //       scaneoTrue() async {
          //      DateTime now = DateTime.now();
          //      bool erroguardar = await QuerysService().SaveGeneralInfoScaneos(
          //        reference: "Scaneos",
          //        id: id_variable,
          //        collectionValues: ScaneosModel().toJsonBodyScaner(
          //            id_variable,
          //            widget.censerModel.id,
          //            widget.userModel.id,
          //            widget.userModel.locality,
          //            widget.userModel.state,
          //            now,
          //            widget.censerModel.email,
          //            widget.userModel.email),
          //      );
          //  }
          //                scaneoTrue() async {
          //     DateTime now = DateTime.now();
          //     bool erroguardar = await QuerysService().SaveGeneralInfoScaneos(
          //       reference: "Scaneos",
          //       id: id_variable,
          //       collectionValues: ScaneosModel().toJsonBodyScaner(
          //           id_variable,
          //           iconModelList[0].idCamionero,
          //           widget.userModel.id,
          //           widget.userModel.locality,
          //           widget.userModel.state,
          //           now,
          //           widget.userModel.urlProfile,
          //           widget.userModel.email,
          //           codeModel.id),
          //     );
          // }
        } else {
          String formattedDate2 =
              DateFormat('dd-MM-yyyy').format(widget.userModel.activeUntil);
          textString = '${textActive}      ${formattedDate2}';
          getlista(codeModel.id);
          Toast.show("Activo", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } else {
        print("Lo sentimos no eatas en el mismo lugar que el camion");
        Toast.show("Lo sentimos no estas registrado en la misma ruta que el camion", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }

      // _getVincular(codeModel.id);
    } else {
      DateTime activeUntil = DateFormat("yyyy-MM-dd").parse(codeModel.dateTime);
      DateTime now = DateTime.now();

      int isActive = now.compareTo(activeUntil);
      setState(() {
        _showSpinner = true;
      });
      print("Usuario inactivo");
      // _getMiInfo(codeModel.id, false);
    }
  }
}
