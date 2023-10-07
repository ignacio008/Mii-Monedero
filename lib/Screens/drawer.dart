import 'package:flutter/material.dart';

import '../Firebase/authentication.dart';
import '../Models/censerModel.dart';
import '../Models/userModel.dart';
import 'edit_user_camionero.dart';
import 'loginScreen.dart';

class DrawerMenu extends StatefulWidget {
  UserModel userModel;
  DrawerMenu(this.userModel);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
             
                UserAccountsDrawerHeader(
                accountName: Text("Bienvenido ${widget.userModel.name}"),
                 accountEmail: Text("Correo: ${widget.userModel.email}"),
                 
                 currentAccountPicture:  

            CircleAvatar(   
                radius: 30.0,
               backgroundImage:
               widget.userModel.urlProfile!=null?     NetworkImage(
                      "${widget.userModel.urlProfile}",)
                      :AssetImage("assets/images/user3.png"),
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ),
                otherAccountsPictures: <Widget>[
                
                ],
                
                // onDetailsPressed: (){
                //    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateUser(widget.iconmodel)));
                
                // },
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors:[Color.fromARGB(255, 209, 4, 1), Color.fromARGB(255, 91, 9, 9)] ),
                  ),                 
                 
                 ),
                 
                ListTile(title: Text("Inicio"),
                leading: Icon(Icons.home, color:Colors.blueGrey[400]),
                onTap:(){
                   Navigator.pop(context);
                },
                ),

                
                
                ListTile(title: Text("Edite su Usuario"),
                leading: Icon(Icons.people, color:Colors.blueGrey[400]),
                onTap:
                ()=> irEditarUsuario(context)
                 
                ),

                // codigo qr vinculado
                // ListTile(title: Text("Codigo QR"),
                // leading: Icon(Icons.qr_code_2_rounded, color:Colors.black),
                // onTap:()=>ir_qr(context),
                // ),
              

              

                

                ListTile(title: Text("Cerrar Sesion"),
                leading: Icon(Icons.power_settings_new, color:Colors.red),
                onTap:()=>mostrarDialogo(context),
                ),
            ], 
          ),
      ); 
  }

  irEditarUsuario(BuildContext context) {
    Navigator.pop(context);
     Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarUsuario(widget.userModel)));
  }

   void cerrarSesion() async{
     Authentication().singOut();
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void mostrarDialogo(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
              title: Text("Cerrar Sesion"),
              content: Text("¿Estas Seguro que deseas cerrar sesion?"),
              actions: <Widget>[
                TextButton(
                  child: Text("No", style: (TextStyle(color: Colors.blue))),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Si"),
                  onPressed: (){
                    cerrarSesion();
                  },
                ),

                
              ],
          );//alertdialogo
       },//finshowdialog
          barrierDismissible: false);
      
  }
}