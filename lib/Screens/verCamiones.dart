import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:mega_monedero/Models/userModel.dart';

import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

import 'censerDetailsScreen.dart';

class VerCamiones extends StatefulWidget {
  CenserModel categoryModelCamionero;
  UserModel userModel;
  VerCamiones(this.categoryModelCamionero,this.userModel);

  @override
  State<VerCamiones> createState() => _VerCamionesState();
}

class _VerCamionesState extends State<VerCamiones> {
  
  final double barHeight = 50.0;
  
  int _current = 0;
  List<String> imgList = [];
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
          itemCount: 2,
          itemBuilder: (context, index) {
            if(index == 0){
              return Container(
                padding: EdgeInsets.only(top: statusbarHeight),
                height: statusbarHeight + barHeight,
                child: Center(
                  child: Text(
                    widget.categoryModelCamionero.nameRuta,
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
            else if(index == widget.categoryModelCamionero.services.length){
              return GestureDetector(
                onTap: (){
                  // _openMap(widget.censerModel.latitude.toString(), widget.censerModel.longitude.toString());
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
                child: Text(widget.categoryModelCamionero.photoLicencia),
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
       Container(
         width:MediaQuery.of(context).size.width,
         height:MediaQuery.of(context).size.height*0.3,
         child: Image.network(widget.categoryModelCamionero.photoCamion==null?"https://ep01.epimg.net/elpais/imagenes/2019/10/30/album/1572424649_614672_1572453030_noticia_normal.jpg":widget.categoryModelCamionero.photoCamion,fit: BoxFit.cover, 
                loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
                   if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: Container(
              width:200,
              height:200,
              child: Transform.scale(
                scale:0.9,
                child: CircularProgressIndicator(   
                ),
              ),
            ),
          );
                },    
                  ),
       ),
       
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                widget.categoryModelCamionero.name,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                widget.categoryModelCamionero.numberOwner,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
              ),
              Text(
                "${widget.categoryModelCamionero.locality}, ${widget.categoryModelCamionero.state} " " ",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
              ),
             ],
           ),
                Container( 
                                          width: 90,
                                          height: 90,
                                          child:ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Image.network(widget.categoryModelCamionero.photos,fit: BoxFit.cover, 
                                loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                            return child;
                          }
                                  return Center(
                                    child: Container(
                                      width:200,
                                      height:200,
                                      child: Transform.scale(
                                        scale:0.4,
                                        child: CircularProgressIndicator(
                                        ),
                                      ),
                                    ),
                                  );
                                        },
                                        ),
                                          ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:  Colors.grey[200] ,
                                  border: Border.all(color: Colors.red[900])
                                ),
                              ),
                ],
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
                    child: Row(
                      children: [
                        Text("Numero de unidad: ",style:TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                         "${widget.categoryModelCamionero.numUnidad} ",
                         style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
                        ),
                      ],
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
                        Icons.credit_card_sharp
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text("Placa: ",style:TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                         "${widget.categoryModelCamionero.placa} ",
                         style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.0
                ),
                        ),
                      ],
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
                    child: Row(
                      children: [
                         Text("Paraderos: ",style:TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          widget.categoryModelCamionero.paraderoRuta,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5.0,
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
                        widget.categoryModelCamionero.openHours
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}