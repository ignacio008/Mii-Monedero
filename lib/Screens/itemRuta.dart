import 'package:flutter/material.dart';
import 'package:mega_monedero/Models/categoryModel.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/verCamiones.dart';

class ItemRuta extends StatefulWidget {
  CenserModel categoryModelCamionero;
  UserModel userModel;
  ItemRuta(this.categoryModelCamionero,this.userModel);

  @override
  State<ItemRuta> createState() => _ItemRutaState();
}

class _ItemRutaState extends State<ItemRuta> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Navigator.push(
             context,
             MaterialPageRoute(
             builder: (context) => VerCamiones (widget.categoryModelCamionero,  widget.userModel, ))
         );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(20.0),
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
                scale:0.5,
                child: CircularProgressIndicator(
                  
                    
                ),
              ),
            ),
          );

                },
                
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              widget.categoryModelCamionero.name.toUpperCase(),
              style: TextStyle(
                  fontFamily: 'Futura',
                  //color: Colors.white,
                  fontWeight: FontWeight.bold,
                fontSize: 10.0
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}