import 'package:flutter/material.dart';
import 'package:mega_monedero/Models/categoryModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/Screens/mapScreen.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero/Screens/rutasInicio.dart';

class ItemCategory extends StatefulWidget {

  CategoryModel categoryModel;
  double latitude;
  double longitude;
  UserModel userModel;
  ItemCategory({this.categoryModel, this.latitude, this.longitude, this.userModel});

  @override
  _ItemCategoryState createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => RutasInicio (widget.categoryModel.name,widget.userModel, ))
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
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(20.0),
                  child: widget.categoryModel.url,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              widget.categoryModel.name.toUpperCase(),
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
