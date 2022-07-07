class CenserModel{

  String id;
  String name;
  String email;
  DateTime createdOn;
  String description;
  String services;
  String category;
  String addres;
  String openHours;
  String distanceTo;
  double latitude;
  double longitude;
  String state;
  String locality;
  String nameOwner;
  String numberOwner;
  bool suspended;
  String photos;

  

  String numUnidad;
  String placa;
  String photoPLaca;
  String photoLicencia;
  String nameRuta;
  String paraderoRuta;

  String photoCamion;

  CenserModel({this.id, this.name, this.nameOwner, this.suspended, this.numberOwner, this.email, this.createdOn, this.description, this.state, this.locality, this.services, this.category, this.addres, this.openHours, this.distanceTo, this.photos, this.latitude, this.longitude, this.numUnidad, this.placa, this.photoPLaca,this.photoLicencia,this.nameRuta,this.paraderoRuta,this.photoCamion});



  
      
   List  <CenserModel> getCensers(dynamic miInfo){
      List<CenserModel>iconmodelLits=[];


   
for(var datos in miInfo){

      final id_ = datos.data()['id']?? null;
      final name_ = datos.data()['name']?? null;
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final description_ = datos.data()['description'] ?? '';
      final category_ = datos.data()['category'] ?? '';
      final addres_ = datos.data()['addres'] ?? '';
      final openHours_ = datos.data()['openHours'] ?? '';
      final latitude_ = datos.data()['latitude'];
      final longitude_ = datos.data()['longitude'];
      final state_ = datos.data()['state'] ?? '';
      final locality_ = datos.data()['locality'] ?? '';
      final nameOwner_ = datos.data()['nameOwner'] ?? '';
      final numberOwner_ = datos.data()['numberOwner'] ?? '';
      final suspended_ = datos.data()['suspended']?? null;;
      final photos_ = datos.data()['photos']?? null;;
      final services_ = datos.data()['services']?? null;;
      final distanceTo_ = datos.data()['distanceTo'] ?? '';
      final numUnidad_ =datos.data()['numUnidad']??'';
      final placa_ = datos.data()['placa']??'';
      final photoPLaca_ = datos.data()['photoPLaca']??'';
      final photoLicencia_ = datos.data()['photoLicencia']??'';
      final nameRuta_ = datos.data()['nameRuta']??'';
      final paraderoRuta_ = datos.data()['paraderoRuta']??'';
      final photoCamion_ =datos.data()['camion']?? null;

     

      CenserModel usuariomodel = CenserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_== null ? null :createdOn_.toDate(),
        locality: locality_,
        state: state_,
        suspended: suspended_,
        description: description_,
        category: category_,
        addres: addres_,
        openHours: openHours_,
        latitude: latitude_,
        longitude: longitude_,
        nameOwner: nameOwner_,
        numberOwner: numberOwner_,
        photos: photos_  ,
        services: services_  ,
        distanceTo: distanceTo_,
        numUnidad:numUnidad_,
        placa:placa_,
        photoPLaca:photoPLaca_,
        photoLicencia:photoLicencia_,
        nameRuta:nameRuta_,
        paraderoRuta:paraderoRuta_,
        photoCamion:photoCamion_,

      );
 iconmodelLits.add(usuariomodel);
}
      return iconmodelLits;
     }


}