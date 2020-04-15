import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplyside/datamodels/user.dart';

class FirestoreUsers {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
      print('Saved to database: $user.email');
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String id) async {
    try {
      var userData = await _usersCollectionReference.document(id).get();
      return User.fromData(userData.data);
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future updateUserType(String id, String type) async {
    try {
      await _usersCollectionReference.document(id).updateData({"type": type});
      print('Saved type: $type');
    } catch (e) {
      return e.message;
    }
  }
}