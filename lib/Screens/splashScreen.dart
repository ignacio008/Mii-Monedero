import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero/Screens/QRCodeScreen.dart';
import 'package:mega_monedero/Screens/loginScreen.dart';
import 'package:mega_monedero/Screens/mainScreen.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String latlng = "";
  bool _logueado = false;
  bool _userComplete = false;
  bool _locationComplete = false;
  List<UserModel> usuarios = [];

  void getCurrentUser() async{
    var user = await Authentication().getCurrentUser();
    if (user != null) {
      _logueado = true;
      _getMiInfo(user.uid);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    getCurrentUser();
    /*Timer(
        Duration(
            milliseconds: 2500
        ), () {
      Navigator.pushReplacementNamed(
          context,
          MainDrawer.routeName);
    });*/
  }

  _getCurrentPosition() async {

    /*GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);

    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if(isLocationEnabled){
      print("GPS activado");
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latlng = position.latitude.toString() + ", " + position.longitude.toString();
      });
    }
    else{
      print("GPS desactivado");
    }*/

    bool _serviceEnabled;

  

   

    /*_locationData = await location.getLocation();
    setState(() {
      latlng = _locationData.latitude.toString() + ", " + _locationData.longitude.toString();
    });*/

    



    if(_logueado){
      if(_userComplete){
        Timer(
            Duration(
                milliseconds: 500
            ), () {

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QRCodeScreen (userModel: usuarios[0])
              )
          );
        });
      }
    }
    else{
      Timer(
          Duration(
              milliseconds: 500
          ), () {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen ()
            )
        );
      });
    }


  }

  void _getMiInfo(String idPropio) async {

    final messages = await QuerysService().getMiInfo(miId: idPropio);
    usuarios = _getUserItem(messages.docs);

    if(usuarios.length > 0){

      _userComplete = true;

      if(_locationComplete){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => QRCodeScreen ( userModel: usuarios[0],)
            )
        );
      }

    }
    else{
      Toast.show("Ha ocurrido un error, por favor reinicie la aplicación", context, duration: Toast.LENGTH_LONG);
    }
  }

  List<UserModel> _getUserItem(dynamic miInfo){

    List<UserModel> miInfoList = [];

    for(var datos in miInfo) {
      final id_ = datos.data()['id']?? null;
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final activeUntil_ = datos.data()['activeUntil'];
      final activeProductosUntil_ = datos.data()['activeProductosUntil'];
      final locality_ = datos.data()['locality'] ?? '';
      final state_ = datos.data()['state'] ?? '';
      final renovations_ = datos.data()['renovations'];
      final suspended_ = datos.data()['suspended'];
      final urlProfile_ = datos.data()['urlProfile'] ?? '';


      UserModel usuariosModel = UserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        activeUntil: activeUntil_.toDate(),
        activeProductosUntil: activeProductosUntil_.toDate(),
        locality: locality_,
        state: state_,
        renovations: renovations_,
        suspended: suspended_,
        urlProfile: urlProfile_,
      );


      miInfoList.add(usuariosModel);
    }
    return miInfoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundLight],
                end: FractionalOffset.topCenter,
                  begin: FractionalOffset.bottomCenter,
                 stops: [0.0, 1.0],
                 tileMode: TileMode.repeated
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Mii Pasaje Móvil",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height:8.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
