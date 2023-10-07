import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CenserDetailsScreen extends StatefulWidget {

  CenserModel censerModel;
  double latitude;
  double longitude;
  CenserDetailsScreen({this.censerModel, this.longitude, this.latitude});

  @override
  _CenserDetailsScreenState createState() => _CenserDetailsScreenState();
}

class _CenserDetailsScreenState extends State<CenserDetailsScreen> {

  String distancia = "";
  int _current = 0;

  List<String> imgList = [];
  final double barHeight = 50.0;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _getDistance();

    for(int i = 0; i < widget.censerModel.photos.length; i++){

      if(widget.censerModel.photos[i].length > 0){
        imgList.add(widget.censerModel.photos[i]);
      }
    }

  }

  _getDistance() async {
   
  
  }

  @override
  Widget build(BuildContext context) {

    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return Scaffold(

      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: widget.censerModel.services.length + 3,
          itemBuilder: (context, index) {
            if(index == 0){
              return Container(
                padding: EdgeInsets.only(top: statusbarHeight),
                height: statusbarHeight + barHeight,
                child: Center(
                  child: Text(
                    widget.censerModel.name,
                    style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundDarkD],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                  ),
                ),
              );
            }
            else if(index == 1){
              return body();
            }
            else if(index == widget.censerModel.services.length + 2){
              return GestureDetector(
                onTap: (){
                  _openMap(widget.censerModel.latitude.toString(), widget.censerModel.longitude.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundLight],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.5, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Ir hacia este establecimiento",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            else{
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Text(widget.censerModel.services[index - 2]),
              );
            }
          },
        ),
      ),
    );
  }

  Widget body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /*Container(
          width: double.infinity,
          height: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: "assets/images/fondo_negro.jpg",
            image: widget.censerModel.photos[0],
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 1000),
          ),
        ),*/
        CarouselSlider(
          viewportFraction: 1.0,
          items: map<Widget>(
            imgList,
                (index, i) {
              return Container(
                width: double.infinity,
                //height: 50.0,
                margin: EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(0.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/fondo_negro.jpg",
                    image: imgList[index],
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 1000),
                  ),
                ),
              );
            },
          ),
          autoPlay: true,
          enlargeCenterPage: false,
          aspectRatio: 5/3,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.censerModel.name,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                widget.censerModel.category,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
              ),
              Text(
                "Aproximadamente a " + distancia + " km",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width:40,
                    height: 40,
                    child: Icon(
                        Icons.info
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.censerModel.description,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width:40,
                    height: 40,
                    child: Icon(
                        Icons.location_on
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.censerModel.addres,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width:40,
                    child: Icon(
                        Icons.access_time
                    ),
                  ),
                  Expanded(
                    child: Text(
                        widget.censerModel.openHours
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "Servicios",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _openMap(String latitud, String longitud) async {
    // Android
    String url = 'google.navigation:q=$latitud,$longitud';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      String url = 'http://maps.apple.com/?q=$latitud,$longitud';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
