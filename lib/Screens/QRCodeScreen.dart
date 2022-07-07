import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Models/codeModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/loginScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

class QRCodeScreen extends StatefulWidget {
  double latitud;
  double longitud;
  UserModel userModel;
  QRCodeScreen({this.latitud, this.longitud,this.userModel});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {

  final double barHeight = 50.0;
  int isActive;
  String textInactive = "La suscripción de su tarjeta no ha sido activada o ya ha caducado, para poder utilizarla un chofer autorizado dentro de la plataforma podrá escanear y activar de nuevo su tarjeta";
  String textActive = "Su tarjeta se encuentra activa y caduca el día: ";
  String textString;
  String myCode;
  CodeModel codeModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = DateTime.now();
    isActive = now.compareTo(widget.userModel.activeUntil);

    if(isActive == 1){
      textString = textInactive;
    }
    else{
      String formattedDate2 = DateFormat('dd-MM-yyyy').format(widget.userModel.activeUntil);
      textString = '${textActive}      ${formattedDate2}';
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.userModel.activeUntil);

    codeModel = CodeModel(id: widget.userModel.id, dateTime: formattedDate);
    myCode = json.encode(codeModel.toMap());
    print(myCode);
  }
  @override
  Widget build(BuildContext context) {

    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            child: Center(
              child: Text(
                "MII MONEDERO",
                style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundLight],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
          ),
          


          Container(
             height:MediaQuery.of(context).size.height*0.69,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(children: [
                      SizedBox(
            height: 15.0,
          ),
                Text(
                widget.userModel == null ? "Bienvenido" :
                "Bienvenido " + widget.userModel.name,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold
                ),
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
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  textString,
                  style: TextStyle(
                      fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                ),
                SizedBox(
                height: 15.0,
                ),
                QrImage(
                data: myCode,
                version: QrVersions.auto,
                size: 180,
                gapless: false,
                foregroundColor: Colors.black,
                ),

         SizedBox(
                height: 45.0,
                ),

                widget.userModel == null ? Container() : GestureDetector(
                onTap: (){
                  _showAlertCerrarSesion();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/6),
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: MyColors.Colors.colorRedBackgroundDarkD, width: 2.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(
                        child: Text(
                          "Cerrar Sesión",
                          style: TextStyle(
                              color: MyColors.Colors.colorRedBackgroundDark,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ),

                  ],),
                ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }

   void _showAlertCerrarSesion(){
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
        FlatButton(
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
        FlatButton(
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
                builder: (context) => LoginScreen (latitude: widget.latitud, longitude: widget.longitud,)
            ));
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }
}
