import 'package:flutter/material.dart';
import 'package:mega_monedero/Items/itemCategory.dart';
import 'package:mega_monedero/Models/categoryModel.dart';
import 'package:mega_monedero/Models/userModel.dart';
import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;

class CategoriesScreen extends StatefulWidget {

  double latitude;
  double longitude;
  UserModel userModel;
  CategoriesScreen({this.latitude, this.longitude, this.userModel});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  
  List<CategoryModel> categories = [];
  final double barHeight = 50.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories.add(CategoryModel(id: "1", name: "Ruta numero 1", url: Icon(Icons.directions_car, size: 40, color: MyColors.Colors.colorRedBackgroundDark)));
    categories.add(CategoryModel(id: "2", name: "Ruta numero 2", url: Icon(Icons.wc, size: 40, color: MyColors.Colors.colorRedBackgroundDark)));
    categories.add(CategoryModel(id: "3", name: "Ruta numero 3", url: Icon(Icons.lock, size: 40, color: MyColors.Colors.colorRedBackgroundDark)));
   

  }
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
                "MII MONEDERO",
                style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.Colors.colorRedBackgroundDark, MyColors.Colors.colorRedBackgroundLight],
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
              "¿Qué Ruta deseas buscar?",
              textAlign: TextAlign.center,
          ),
          Flexible(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (0.75),
                children: List.generate(categories.length, (index) {
                  return ItemCategory(categoryModel: categories[index], userModel: widget.userModel);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
