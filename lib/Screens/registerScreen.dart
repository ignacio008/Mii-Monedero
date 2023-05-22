import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_monedero/Dialogs/dialogSubirFoto.dart';
import 'package:mega_monedero/Firebase/authentication.dart';
import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/localitiesModel.dart';
import 'package:mega_monedero/Models/stateModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero/Screens/QRCodeScreen.dart';
import 'package:mega_monedero/Screens/mainScreen.dart';
import 'package:mega_monedero/Screens/menuScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {

  double latitud;
  double longitud;
  RegisterScreen({this.longitud, this.latitud});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  double screenHeight;
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;
  String _state = "Estado";
  String _locality = "Municipio";
  bool _showSpinner = false;
  File _image;
  UserModel myUser;
  String myId;
  DateTime _now;
  DateTime _yesterday;
  String myUrl;

  List<StateModel> stateList = [];
  List<LocalityModel> localityList = [];
  List<LocalityModel> localityListFiltered = [];

  void _getImageGallery() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    setState(() {
     _image=File(image.path);
    });
  }

  void _getImageCamera() async {
     final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera, maxHeight: 300, maxWidth: 300);

    setState(() {
      _image=File(image.path);
    });
  }

  Future<String> _loadASmaeAsset() async {
    return await rootBundle.loadString('assets/estados.json');
  }

  loadStates() async {
    String jsonString = await _loadASmaeAsset();
    var jsonResponse = json.decode(jsonString) as List;

    stateList = jsonResponse.map((i) => StateModel.fromJson(i)).toList();

    loadLocalities();
  }

  Future<String> _loadLocalitiesAsset() async {
    return await rootBundle.loadString('assets/result.json');
  }

  loadLocalities() async {
    String jsonString = await _loadLocalitiesAsset();
    var jsonResponse = json.decode(jsonString) as List;

    localityList = jsonResponse.map((i) => LocalityModel.fromJson(i)).toList();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    loadStates();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
  }

  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [MyColors.Colors.colorRedBackgroundDarkF, Colors.red[800]],
                    end: FractionalOffset.topCenter,
                    begin: FractionalOffset.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.repeated),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: screenHeight,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text(
                        "REGÍSTRATE AQUÍ",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogSubirFoto(
                                cameraFunction: _getImageCamera,
                                galleryFunction: _getImageGallery,
                              )
                          );
                        },
                        child: Container(
                          height: 110.0,
                          width: 110.0,
                          decoration: _image == null ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white
                          ) : null,
                          child : _image == null ? Icon(
                            Icons.add_photo_alternate,
                            color: MyColors.Colors.colorBackgroundDark,
                            size: 60.0,
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                  _image,
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
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
                                    controller: _nameController,
                                    textCapitalization: TextCapitalization.words,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    //obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Nombre",
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
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  _showStatesDialog();
                                },
                                child: Container(
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _state,
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  if(_state != "Estado"){
                                    _showLocalitiesDialog();
                                  }
                                  else{
                                    Toast.show("Debes seleccionar primero el estado", context, duration: Toast.LENGTH_LONG);
                                  }
                                },
                                child: Container(
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child:  Center(
                                    child: Text(
                                      _locality,
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
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
                                    controller: _passwordConfirmController,
                                    cursorColor:MyColors.Colors.colorBackgroundDark,
                                    obscureText: true,
                                    style: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Confirmar contraseña",
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
                      GestureDetector(
                        onTap: (){
                          _procesoRegistro();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top:20.0, left: 40.0, right: 40.0),
                          child: Container(
                            height: 45.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "FINALIZAR REGISTRO",
                                style: TextStyle(
                                    color: MyColors.Colors.colorBackgroundDark,
                                    fontWeight: FontWeight.bold
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
            )
          ],
        ),
      ),
    );
  }

  _procesoRegistro() async {

    String _name = _nameController.text;
    //String _lastName = _lastNameController.text;
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _passwordConfirmController.text.trim();

    FocusScope.of(context).requestFocus(FocusNode());

    if(_image == null){
      Toast.show("Por favor, necesita subir su foto para continuar", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(_name.length < 10){
      Toast.show("Por favor, escriba su nombre correctamente", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(_state == "Estado"){
      Toast.show("Por favor, seleccione su estado", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(_locality == "Municipio"){
      Toast.show("Por favor, seleccione su municipio", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(!_email.contains("@") || _email.length < 3 ){
      Toast.show("Su correo no está escrito correctamente, por favor, verifíquelo", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    if(_password.length < 6 ){
      Toast.show("Su contraseña debe ser minimo de 6 caracteres, por favor, verifíquela", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }
    else{
      if(_password != _confirmPassword){
        Toast.show("Sus contraseñas no coinciden", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        return;
      }
      else{
        setSpinnerStatus(true);
        var auth = await Authentication().createUser(email: _emailController.text.trim(), password: _passwordController.text.trim());

        if(auth.succes){

          var user = await Authentication().getCurrentUser();
          if (user != null) {

            String url = await QuerysService().uploadProfilePhoto(id: user.uid, file: _image);

            var now = DateTime.now();
            DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
            myId = user.uid;

            _now = now;
            _yesterday = yesterday;
            myUrl = url;

            QuerysService().SaveUsuario(idUsuario: user.uid, context: context, function: _switchOffProgress, errorFunction: _errorSwitchOffProgress, collectionValues: {
              'id' : user.uid,
              'name' : _name,
              'createdOn' : now,
              'email' : _email,
              'urlProfile' : url,
              'locality' : _locality,
              'activeProductosUntil' : yesterday,
              'state' : _state,
              'activeUntil' : yesterday,
              'renovations' : 0,
              'suspended' : false,
            });

          }
          setSpinnerStatus(false);
        }
        else{
           Toast.show("Ha ocurrido un problema, Verifique su correo electronico", context, duration: Toast.LENGTH_LONG);
       _errorSwitchOffProgress();
        }
      }
    }

  }

  _switchOffProgress(){
    setState(() {
      _showSpinner = false;

      myUser = UserModel(
        id: myId,
        name: _nameController.text,
        activeProductosUntil: _yesterday,
        createdOn : _now,
        email : _emailController.text.trim(),
        urlProfile : myUrl,
        locality : _locality,
        state : _state,
        activeUntil : _yesterday,
        renovations : 0,
        suspended : false,
      );

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MainScreen (latitud: widget.latitud, longitud: widget.longitud, userModel: myUser)
      //     ),
      //         (_) => false);
              Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QRCodeScreen (latitud: widget.latitud, longitud: widget.longitud, userModel: myUser)
          )
      );
    });
  }

  _errorSwitchOffProgress(){
    setState(() {
      _showSpinner = false;

    });
  }


  void _showStatesDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "ESTADOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.80,
        child: ListView.builder(
            itemCount: stateList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _state = stateList[index].nombre;
                      _locality = "Municipio";
      
                      localityListFiltered.clear();
                      for(int i = 0; i < localityList.length; i++){
                        if(localityList[i].nombre_estado == _state){
                          localityListFiltered.add(localityList[i]);
                        }
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          stateList[index].nombre
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              );
            }
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
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }

  void _showLocalitiesDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "MUNICIPIOS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.80,
        child: ListView.builder(
            itemCount: localityListFiltered.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _locality = localityListFiltered[index].nombre_municipio;
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          localityListFiltered[index].nombre_municipio
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              );
            }
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
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }

}
