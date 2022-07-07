import 'package:flutter/material.dart';
import 'package:mega_monedero/Firebase/fetch_data.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:mega_monedero/Models/userModel.dart';

import 'package:mega_monedero/MyColors/Colors.dart' as MyColors;
import 'package:mega_monedero/Screens/itemRuta.dart';


class RutasInicio extends StatefulWidget {
  String category;
  UserModel userModel;
  
  RutasInicio(this.category,this.userModel);

  @override
  State<RutasInicio> createState() => _RutasInicioState();
}

class _RutasInicioState extends State<RutasInicio> {
  List<CenserModel> iconModelListRuta=[];
  final double barHeight = 50.0;
  bool isLoading=false;
   void getlista(String rutas)async{
    iconModelListRuta=await FetchData().getTopMyRutas(rutas);
    print('Tengo ${iconModelListRuta.length} cards');
    //isLoading=true;
    setState(() {
      isLoading=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
     getlista(widget.category);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return Scaffold(
      body:
      
      
       
      
      
      
      
      Column(
        children:[
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
          iconModelListRuta.isEmpty?SizedBox(height:50):
          Text(
              "¿Qué Camion deseas ver?",
              textAlign: TextAlign.center,
          ),

          isLoading==false? Container(

       child: Center(
         child: Column(
                         
                          children:[
                            SizedBox(height:MediaQuery.of(context).size.height*0.2),
                        Container( 
                          width: MediaQuery.of(context).size.width*0.7,
                          height:MediaQuery.of(context).size.height*0.3,
                        
             child: Transform.scale(
                scale: 0.9,
               child: CircularProgressIndicator())) 
                        ]),
       ),

      ):

      iconModelListRuta.isEmpty?Center(
        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Icon(Icons.warning_amber_rounded, size:230, color:Colors.orange[600]),
                        Text("¡Lo sentimos no hay ningun camion para esta Ruta!"),
                      ]),


                    ),
      ):

           Flexible(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (0.75),
                children: List.generate(iconModelListRuta.length, (index) {
                  return ItemRuta(iconModelListRuta[index], widget.userModel);
                }),
              ),
            ),
          ),
          
        ]
      )
    );
  }
}