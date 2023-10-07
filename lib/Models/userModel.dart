class UserModel{

  String id;
  String name;
  String email;
  String state;
  String locality;
  DateTime createdOn;
  String urlProfile;
  DateTime activeUntil;
  DateTime activeProductosUntil;
  int renovations;
  bool suspended;

  UserModel({this.id, this.name, this.activeProductosUntil, this.state, this.locality, this.suspended, this.email, this.createdOn, this.urlProfile, this.activeUntil, this.renovations});

  
  UserModel getUsuario(dynamic datos){

      final id_ = datos.data()['id'];
      final name_ = datos.data()['name'] ?? '';
      final email_ = datos.data()['email'] ?? '';
      final createdOn_ = datos.data()['createdOn'];
      final state_ = datos.data()['state'] ?? '';
      final locality_ = datos.data()['locality'] ?? '';
      final suspended_ = datos.data()['suspended'];
      final urlProfile_ = datos.data()['urlProfile'];
    
      final activeUntil_ = datos.data()['activeUntil'];
      final activeProductosUntil_ = datos.data()['activeProductosUntil'];
      final renovations_ = datos.data()['renovations'];
      

       UserModel usuariosModel = UserModel(
        id: id_,
        name: name_,
        email: email_,
        createdOn: createdOn_.toDate(),
        locality: locality_,
        state: state_,
        suspended: suspended_,
        urlProfile:urlProfile_,
        activeUntil:activeUntil_.toDate(),
        activeProductosUntil:activeProductosUntil_.toDate(),
        renovations:renovations_,



        
      );

    return usuariosModel;
  }

  Map<String, dynamic> toJsonBodyUserEdit(id, name, state , locality, urlProfile) =>
          {
            'id':id,
            'name': name,
            'state':state,
            'locality':locality,
            'urlProfile':urlProfile,
            
          };
}