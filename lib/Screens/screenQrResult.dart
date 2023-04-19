import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero/Models/camionesModel.dart';
import 'package:mega_monedero/Models/userModel.dart';

import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

class ScreenQrResult extends StatefulWidget {
  UserModel userModel;
  int isActive;
  CamionesModel camionesModel;
  ScreenQrResult({this.userModel, this.isActive,this.camionesModel});

  @override
  State<ScreenQrResult> createState() => _ScreenQrResultState();
}

class _ScreenQrResultState extends State<ScreenQrResult> {
  bool _showSpinner = false;
  final double barHeight = 50.0;

  String textInactive =
      "La suscripción de su tarjeta no ha sido activada o ya ha caducado, para poder utilizarla un chofer autorizado dentro de la plataforma podrá escanear y activar de nuevo su tarjeta";
  String textActive = "Su tarjeta se encuentra activa y caduca el día: ";
  String textString;
  String formattedDate2;
  @override
  void initState() {
    // TODO: implement initState

    formattedDate2 =
        DateFormat('dd-MM-yyyy').format(widget.userModel.activeUntil);
    super.initState();
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
                      Text(
                        widget.isActive == 1
                            ? "${textInactive}"
                            : "${textActive}      ${formattedDate2}",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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
}
