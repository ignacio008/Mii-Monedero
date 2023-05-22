import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_monedero/Models/camionesModel.dart';
import 'package:mega_monedero/Models/userModel.dart';

import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

class ScreenQrFinal extends StatefulWidget {
  UserModel userModel;
  int isActive;
  CamionesModel camionesModel;
  ScreenQrFinal({this.userModel, this.isActive, this.camionesModel});

  @override
  State<ScreenQrFinal> createState() => _ScreenQrFinalState();
}

class _ScreenQrFinalState extends State<ScreenQrFinal> {
  bool _showSpinner = false;
  final double barHeight = 50.0;

  String textInactive =
      "La suscripción de su tarjeta no ha sido activada o ya ha caducado, para poder utilizarla un chofer autorizado dentro de la plataforma podrá escanear y activar de nuevo su tarjeta";
  String textActive = "Su tarjeta se encuentra activa y caduca el día: ";
  String textString;
  String formattedDate2;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState

    formattedDate2 =
        DateFormat('dd-MM-yyyy').format(widget.userModel.activeUntil);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: widget.userModel.id)
        .snapshots();
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text("MII MONEDERO"),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
                colors: <Color>[
                  MyColors.Colors.colorRedBackgroundDark,
                  MyColors.Colors.colorRedBackgroundLight
                ]),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.red,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 120,
                  ),
                  Text(
                    'Algo salió mal, por favor recargue la app',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                    child: CircularProgressIndicator(
              color: Colors.white,
            )));
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String urlProfile = data['urlProfile'] ?? 'default value';

              DateTime isActiveDate =
                  data['activeUntil'].toDate() ?? 'No hay valor';

              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(isActiveDate);
              int isActive = now.compareTo(isActiveDate);

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        MyColors.Colors.colorRedBackgroundDark,
                        MyColors.Colors.colorRedBackgroundLight
                      ],
                      end: FractionalOffset.topCenter,
                      begin: FractionalOffset.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.repeated),
                ),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        widget.userModel == null
                            ? "Bienvenido"
                            : "Bienvenido " + widget.userModel.name,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/fondo_negro.jpg",
                          image: urlProfile,
                          fit: BoxFit.cover,
                          width: 140.0,
                          height: 140.0,
                          fadeInDuration: Duration(milliseconds: 1000),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        isActive == 1
                            ? "${textInactive} "
                            : "${textActive}      ${formattedDate}",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
