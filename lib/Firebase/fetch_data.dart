


import 'package:mega_monedero/Firebase/querys.dart';
import 'package:mega_monedero/Models/censerModel.dart';

class FetchData{

     

   Future<List>getTopMyRutas(String idUser)async{
    List<CenserModel>iconlistTopChanel=[];
    final messages= await QuerysService().getMyCenserRuta(idUser);
    dynamic  miinfo=messages.docs;
    iconlistTopChanel=CenserModel().getCensers(miinfo);
    return iconlistTopChanel;
    
  }


  
}