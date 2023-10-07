


import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/camionesModel.dart';
import 'package:mega_monedero/Models/censerModel.dart';
import 'package:mega_monedero/Models/userModel.dart';

class FetchData{

     

   Future<List>getTopMyRutas(String idUser)async{
    List<CenserModel>iconlistTopChanel=[];
    final messages= await QuerysService().getMyCenserRuta(idUser);
    dynamic  miinfo=messages.docs;
    iconlistTopChanel=CenserModel().getCensers(miinfo);
    return iconlistTopChanel;
    
  }
   Future<List>getScanner(idScaner)async{
     List<CamionesModel>iconlistVentas=[];
     final messages= await QuerysService().getAllScaner(idScaner);
     dynamic  miinfo=messages.docs;
     iconlistVentas=CamionesModel().getScaner(miinfo);
     return iconlistVentas;
   }
   Future <UserModel> getAdmin(id)async{  
      final messages= await QuerysService().getAdimDocument(id);
      dynamic  miinfo=messages;
      print(miinfo.data().toString());
      UserModel adminmodel = UserModel().getUsuario(miinfo);
      return adminmodel;
     }


  
}