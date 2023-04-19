import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:flutter/material.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/loginScreen.dart';
import 'package:mega_monedero/Screens/mainScreen.dart';
import 'package:toast/toast.dart';

class MenuScreen extends StatefulWidget {

  double latitud;
  double longitud;
  UserModel userModel;
  MenuScreen({this.latitud, this.longitud, this.userModel});


  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final double barHeight = 50.0;

  @override
  Widget build(BuildContext context) {

    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            child: Center(
              child: Text(
                "MEGA MONEDERO",
                style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.Colors.colorBackgroundDark, MyColors.Colors.colorBackgroundLight],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
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
          widget.userModel == null ? Container() : GestureDetector(
            onTap: (){
              _showAlertCerrarSesion();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: MyColors.Colors.colorBackgroundDark, width: 2.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                          color: MyColors.Colors.colorBackgroundDark,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Seleccione una opción",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){
                if(widget.userModel != null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(userModel: widget.userModel, longitud: widget.longitud, latitud: widget.latitud)
                      )
                  );
                }
                else{
                  _showAlert();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0, bottom: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: MyColors.Colors.colorBackgroundLight,
                  ),
                  child: Icon(
                    Icons.account_balance,
                    size: 60.0,
                    color: MyColors.Colors.colorBackgroundDark,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "Servicios",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){
                Toast.show("Esta funcionalidad estará disponible proximamente", context, duration: Toast.LENGTH_LONG);
              },
              child: Padding(
                padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0, bottom: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: MyColors.Colors.colorBackgroundLight,
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 60.0,
                    color: MyColors.Colors.colorBackgroundDark,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "Tiendas de conveniencia",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          )
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

  void _showAlert(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Aviso",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        "No puedes acceder a esta sección porque no te has logueado",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            "Cerrar",
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
            "Loguearme",
            style: TextStyle(
              fontSize: 16.0,
              color: MyColors.Colors.colorBackgroundDark,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
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
