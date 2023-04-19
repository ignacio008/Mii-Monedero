class CamionesModel{
  
  String idCamion;
  String nameRuta;
  DateTime createdOn;
  String state;
  String locality;
  String createBy;
  DateTime updateOn;
  String idCamionero;

  CamionesModel({this.idCamion, this.nameRuta ,this.createdOn, this.state, this.locality, this.createBy, this.updateOn,this.idCamionero});


  
  List  <CamionesModel> getScaner(dynamic miInfo){
      List<CamionesModel>iconmodelLits=[];

    
        for(var datos in miInfo){
      final idCamion_ = datos.data()['idCamion']?? null;
      final nameRuta_ = datos.data()['nameRuta']?? null;
      final createdOn_ = datos.data()['createdOn']?? null;
      final state_ =datos.data()['state']?? null;
      final locality_ = datos.data()['locality']?? null;
      final createBy_ = datos.data()['createBy']?? null;
      final updateOn_ = datos.data()['updateOn']?? null;
      final idCamionero_ = datos.data()['idCamionero']?? null;



      CamionesModel pagoModel = CamionesModel(
        idCamion: idCamion_,
        nameRuta: nameRuta_,
        createdOn: createdOn_== null ? null :createdOn_.toDate(),
        state:state_,
        locality:locality_,
        createBy:createBy_,
        updateOn: updateOn_== null ? null :updateOn_.toDate(),
        idCamionero: idCamionero_,
      );

       iconmodelLits.add(pagoModel);
}
      return iconmodelLits;
     }
}