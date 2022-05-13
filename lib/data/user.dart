import 'package:cloud_firestore/cloud_firestore.dart';

class UserOwn {
  UserOwn({
    required this.uid,
    required this.id,
    required this.firstName,
    required this.telephone,
  });

  final String? uid;
  final String? id;
  final String firstName;
  final String telephone;

  static UserOwn fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      UserOwn(
        uid: snapshot.data()['Id'],
        id: snapshot.id,
        firstName: snapshot.data()['FirstName'],
        telephone: snapshot.data()['Telephone'],
      );

  Map<String, dynamic> toMap() => {
        'Id': uid,
        'FirstName': firstName,
        'Telephone': telephone,
      };
}
