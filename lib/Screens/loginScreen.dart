import 'package:clippy_flutter/diagonal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/QRCodeScreen.dart';
import 'package:mega_monedero/Screens/mainScreen.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero/Screens/registerScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {

  double latitude;
  double longitude;
  LoginScreen({this.latitude, this.longitude});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double height;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _showSpinner = false;
  List<UserModel> usuarios = [];

  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [MyColors.Colors.colorRedBackgroundDarkF, Colors.red[800]],
                      end: FractionalOffset.topCenter,
                      begin: FractionalOffset.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.repeated),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      
                      Diagonal(
                        clipShadows: [ClipShadow(color: Colors.black)],
                        position: DiagonalPosition.BOTTOM_LEFT,
                        clipHeight: height/15,
                        child: Container(
                          color: MyColors.Colors.colorRedBackgroundDark,
                          height: height/3.5,
                        ),
                      ),
                      Container(
                        height: height/3.5,
                        child: Center(
                          child: Text(
                            "MII MONEDERO USUARIO",
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "INICIAR SESIÓN",
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Container(
                        height: 42.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                controller: _emailController,
                                //obscureText: true,
                                style: TextStyle(
                                  fontFamily: 'Futura',
                                  color: Colors.white,

                                ),
                                decoration: InputDecoration(
                                    hintText: "Correo electrónico",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white54,
                                    )
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Container(
                        height: 42.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: _passwordController,
                                 cursorColor:MyColors.Colors.colorBackgroundDark,
                                obscureText: true,
                                style: TextStyle(
                                  fontFamily: 'Futura',
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white54,
                                    )
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 40.0),
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _loguearme();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0),
                      child: Container(
                        height: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: MyColors.Colors.colorRedBackgroundDark,
                        ),
                        child: Center(
                          child: Text(
                            "ENTRAR",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                                builder: (context) => RegisterScreen(latitud: widget.latitude, longitud: widget.longitude)
                          )
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:15.0, left: 40.0, right: 40.0),
                      child: Container(
                        height: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: MyColors.Colors.colorRedBackgroundDark, width: 2.0)
                        ),
                        child: Center(
                          child: Text(
                            "REGÍSTRATE AQUÍ",
                            style: TextStyle(
                                color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => MainScreen(latitud: widget.latitude, longitud: widget.longitude)
                  //         )
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 20.0),
                  //     child: Text(
                  //       "Omitir inicio de sesión",
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  _loguearme() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String email = _emailController.text.trim();
    String contrasena = _passwordController.text.trim();

    if(!email.contains("@") || email.length < 3 ){
      Toast.show("Su correo no está escrito correctamente, por favor, verifíquelo", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(contrasena.length < 6 ){
      Toast.show("Su contraseña debe ser minimo de 6 caracteres, por favor, verifíquela", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }

    setSpinnerStatus(true);
    var auth = await Authentication().logingUser(email: _emailController.text.trim(), password: _passwordController.text.trim());

    if(auth.succes){

      User user = await Authentication().getCurrentUser();
      _getMiInfo(user.uid);
      /*
                            Navigator.pushReplacementNamed(
                                context,
                                MainScreen.routeName);*/

      //FocusScope.of(context).requestFocus(_focusNode);
      _emailController.text = "";
      _passwordController.text = "";
    }
    else{
      Toast.show(auth.errorMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      setSpinnerStatus(false);
    }
  }

  void _getMiInfo(String idPropio) async {

    final messages = await QuerysService().getMiInfo(miId: idPropio);
    usuarios = _getUserItem(messages.docs);

    if(usuarios.length > 0){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QRCodeScreen (latitud: widget.latitude, longitud: widget.longitude, userModel: usuarios[0],)
          )
      );
      setSpinnerStatus(false);

    }
    else{
      Authentication().singOut();
      setSpinnerStatus(false);
      Toast.show("Ha ocurrido un error, por favor reinicie la aplicación", context, duration: Toast.LENGTH_LONG);
    }
  }

  List<UserModel> _getUserItem(dynamic miInfo){

    List<UserModel> miInfoList = [];

    for(var datos in miInfo) {
      final id_ = datos.data()['id'];
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
        locality: locality_,
        activeProductosUntil: activeProductosUntil_.toDate(),
        state: state_,
        renovations: renovations_,
        suspended: suspended_,
        urlProfile: urlProfile_,
      );


      miInfoList.add(usuariosModel);
    }
    return miInfoList;
  }
}
