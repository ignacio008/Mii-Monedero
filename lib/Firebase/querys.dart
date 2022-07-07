import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'firebase_referencias.dart';

class QuerysService{

  final _fireStore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getAllCategories() async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_CATEGORIES).get();
  }

  Future<QuerySnapshot> getAllUsers() async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).get();
  }

  Future<QuerySnapshot> getAllCensersByCategory({String category, String locality}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_CENSERS).where('category', isEqualTo: category).where("locality", isEqualTo: locality).where("suspended", isEqualTo: false).get();
  }

  Future<QuerySnapshot> getMiInfo({String miId}) async{
    return await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).where('id', isEqualTo: miId).get();
  }

  void SaveUsuario({String idUsuario,BuildContext context, Function function, Function errorFunction, Map<String, dynamic> collectionValues}) async {
    bool error = false;

    await _fireStore.collection(FirebaseReferencias.REFERENCE_USERS).doc(idUsuario).set(collectionValues).catchError((onError){
      Toast.show("Ha ocurrido un error, por favor, intente de nuevo", context, duration: Toast.LENGTH_LONG);
      error = true;
    }).then((onValue){
      if(!error){
        Toast.show("¡Información subida exitosamente!", context, duration: Toast.LENGTH_LONG);
        function();
      }
      else{
        errorFunction();
      }
    });
  }

  UpdateUsuario({String collectionName, String idUsuario, Map<String, dynamic> collectionValues}) async {
    return await _fireStore.collection(collectionName).doc(idUsuario).set(collectionValues,);
    //_fireStore.collection(collectionName).document("").add(collectionValues);
  }

  Future<String> uploadProfilePhoto({File file, String id}) async {

    final Reference storageReference = FirebaseStorage.instance.ref().child("Users").child(id + "-profile.png");
    final UploadTask uploadTask = storageReference.putFile(file);
    var dowurl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    String url = dowurl.toString();
    return url;
  }
  Future<QuerySnapshot> getMyCenserRuta(String reference) {
    return  _fireStore.collection("Censers").where("nameRuta", isEqualTo: reference).orderBy("createdOn",  descending: true).get();
  }
  


}