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

  Future setUserName(String id, String name) async {
    try {
      await _usersCollectionReference.document(id).updateData({"name": name});
      print('Saved name: $name');
    } catch (e) {
      return e.message;
    }
  }

  Future setUserEmail(String id, String email) async {
    try {
      await _usersCollectionReference.document(id).updateData({"email": email});
      print('Saved email: $email');
    } catch (e) {
      return e.message;
    }
  }

  Future setUserPhoneNumber(String id, String phoneNumber) async {
    try {
      await _usersCollectionReference.document(id).updateData({"phoneNumber": phoneNumber});
      print('Saved phone number: $phoneNumber');
    } catch (e) {
      return e.message;
    }
  }

  Future setUserCollectionHubName(String id, String collectionHubName) async {
    try {
      await _usersCollectionReference.document(id).updateData({"collectionHubName": collectionHubName});
      print('Saved collection hub name: $collectionHubName');
    } catch (e) {
      return e.message;
    }
  }

  Future setMedicalFacilityName(String id, String medicalFacilityName) async {
    try {
      await _usersCollectionReference.document(id).updateData({"medicalFacilityName": medicalFacilityName});
      print('Saved medical facility name: $medicalFacilityName');
    } catch (e) {
      return e.message;
    }
  }

  Future setUserAddress(String id, String address) async {
    try {
      await _usersCollectionReference.document(id).updateData({"address": address});
      print('Saved address: $address');
    } catch (e) {
      return e.message;
    }
  }
}