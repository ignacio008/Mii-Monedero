import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:mega_monedero/Models/localitiesModel.dart';
import 'package:mega_monedero/Models/stateModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/censerDetailsScreen.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class MapScreen extends StatefulWidget {

  double latitude;
  double longitude;
  UserModel userModel;
  String category;
  MapScreen({this.latitude, this.longitude, this.userModel, this.category});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  List<StateModel> stateList = [];
  List<LocalityModel> localityList = [];
  List<LocalityModel> localityListFiltered = [];
  String _state = "Agregar estado";
  String _locality = "Agregar municipio";
  String _category = "";
  List<String> categories = [];
  bool _showSpinner = true;

  double _focusLatitude = 0.0;
  double _focusLongitude = 0.0;

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

    localityListFiltered.clear();
    for(int i = 0; i < localityList.length; i++){
      if(localityList[i].nombre_estado == widget.userModel.state){
        localityListFiltered.add(localityList[i]);
      }
    }
  }

  

 

  List<CenserModel> censerList = [];
 
  void setSpinnerStatus(bool status){
    setState(() {
      _showSpinner = status;
    });
  }

  void _getCensers() async {

    final messages = await QuerysService().getAllCensersByCategory(category: _category, locality: _locality);
    censerList = _getCenserItem(messages.docs);

    if(censerList.length > 0){

     
      setSpinnerStatus(false);

    }
    else{
      setSpinnerStatus(false);
      Toast.show("No se han encontrado censers", context, duration: Toast.LENGTH_LONG);
    }
  }

  List<CenserModel> _getCenserItem(dynamic miInfo){

    List<CenserModel> miInfoList = [];

    for(var datos in miInfo) {
      final id_ = datos.data()['id'];
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final description_ = datos.data()['description'] ?? '';
      final category_ = datos.data()['category'] ?? '';
      final addres_ = datos.data()['addres'] ?? '';
      final openHours_ = datos.data()['openHours'] ?? '';
      final latitude_ = datos.data()['latitude'];
      final longitude_ = datos.data()['longitude'];
      final state_ = datos.data()['state'] ?? '';
      final locality_ = datos.data()['locality'] ?? '';
      final nameOwner_ = datos.data()['nameOwner'] ?? '';
      final numberOwner_ = datos.data()['numberOwner'] ?? '';
      final suspended_ = datos.data()['suspended'];
      final photos_ = datos.data()['photos'];
      final services_ = datos.data()['services'];
      final distanceTo_ = datos.data()['distanceTo'] ?? '';


      CenserModel censerModel = CenserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        locality: locality_,
        state: state_,
        suspended: suspended_,
        description: description_,
        category: category_,
        addres: addres_,
        openHours: openHours_,
        latitude: latitude_,
        longitude: longitude_,
        nameOwner: nameOwner_,
        numberOwner: numberOwner_,
        photos: photos_ == null ? [] : photos_.cast<String>(),
        services: services_ == null ? [] : services_.cast<String>(),
        distanceTo: distanceTo_,
      );


      miInfoList.add(censerModel);
    }
    return miInfoList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStates();


    _state = widget.userModel.state;
    _locality = widget.userModel.locality;
    _category = widget.category;

    _focusLatitude = widget.latitude;
    _focusLongitude = widget.longitude;

    categories.add("AUTOLAVADO");
    categories.add("BAÑOS PÚBLICOS");
    categories.add("CERRAJERÍAS");
    categories.add("CIBER");
    categories.add("DENTISTA");
    categories.add("ELÉCTRICO");
    categories.add("ELECTRICISTA");
    categories.add("ESCUELA DE BAILE");
    categories.add("ESCUELA DE BELLEZA");
    categories.add("ESCUELA DE DANZA");
    categories.add("ESCUELA DE IDIOMAS");
    categories.add("ESCUELA DE NATACIÓN");
    categories.add("ESTACIONAMIENTO");
    categories.add("ESTÉTICA");
    categories.add("GIMNASIO");
    categories.add("JARDINERO");
    categories.add("LABORATORIO CLÍNICO");
    categories.add("LAVANDERÍAS");
    categories.add("LUSTADOR DE ZAPATOS");
    categories.add("MECÁNICO AUTOMOTRIZ");
    categories.add("MÉDICO");
    categories.add("MODISTA");
    categories.add("ÓPTICAS");
    categories.add("PINTOR");
    categories.add("PLOMERO");
    categories.add("REPARACIÓN DE CALZADO");
    categories.add("SPA");
    categories.add("TALLER DE BICICLETAS");
    categories.add("TÉCNICO EN REPARACIÓN DE CELULARES");
    categories.add("TÉCNICO EN REPARACIÓN DE ELECTRODOMÉSTICOS");
    categories.add("VETERINARIO");
    categories.add("VULCANIZADORA");

    _getCensers();

    Timer(
        Duration(
            milliseconds: 1000
        ), () {
     setState(() {

     });
    });
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: <Widget>[
           
            Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: (){
                    _showCategories();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: MyColors.Colors.colorRedBackgroundDark,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Center(
                        child: Text(
                            _category, style:TextStyle(color:Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          _showStatesDialog();
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: MyColors.Colors.colorRedBackgroundDark,
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                            child: Center(
                              child: Text(
                                  _state, style:TextStyle(color:Colors.white),
                              ),
                            ),
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
                          _showLocalitiesDialog();
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: MyColors.Colors.colorRedBackgroundDark,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                                _locality, style:TextStyle(color:Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_locality != "Seleccionar municipio"){
                          _getCensers();
                          _goToTheLake();
                        }
                        else{
                          Toast.show("Debes seleccionar el municipio para poder buscar", context, duration: Toast.LENGTH_LONG);
                        }
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: MyColors.Colors.colorRedBackgroundDark,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Icon(
                          Icons.search,color:Colors.white,
                        )
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
  
  }

  void _showCategories(){
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "CATEGORÍAS",
        style: TextStyle(
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Container(
        width:MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.80,
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _category = categories[index];
                      Navigator.of(context).pop();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          categories[index]
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
                      _locality = "Seleccionar municipio";

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
                      _focusLongitude = localityListFiltered[index].longitud;
                      _focusLatitude = localityListFiltered[index].latitud;
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
