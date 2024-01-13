import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    id = (snap.value as dynamic)['id'];
    name = (snap.value as dynamic)['name'];
    phone = (snap.value as dynamic)['phone'];
    email = (snap.value as dynamic)['email'];
  }
}
