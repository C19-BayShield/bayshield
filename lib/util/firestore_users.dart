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

  Future getMedicalFacility(String id) async {
    try {
      var userData = await _usersCollectionReference.document(id).get();
      return MedicalFacility.fromData(userData.data);
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future getCollectionHub(String id) async {
    try {
      var userData = await _usersCollectionReference.document(id).get();
      return CollectionHub.fromData(userData.data);
    } catch (e) {
      return null;
    }
  }

  Future getMaker(String id) async {
    try {
      var userData = await _usersCollectionReference.document(id).get();
      return Maker.fromData(userData.data);
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

  Future setHubInventory(String id, String itemName, String itemType, int quantity) async {
    try {
      await _usersCollectionReference.document(id).updateData({itemName + "." + itemType: quantity});
    } catch (e) {
      return e.message;
    }
  }

  Future setOrgDetails(String id, int staff, int cases, 
  int shieldSupply, int gownSupply, int gloveSupply, int maskSupply) async {
    try {
      if (staff != null && staff >= 0) {
        await _usersCollectionReference.document(id).updateData({"staff": staff});
        print('Saved new staff number: $staff');
      }
      if (cases != null && cases >= 0) {
        await _usersCollectionReference.document(id).updateData({"cases": cases});
        print('Saved new reported case number: $cases');
      }
      if (shieldSupply != null && shieldSupply >= 0) {
        await _usersCollectionReference.document(id).updateData({"shieldSupply": shieldSupply});
        print('Saved new shield supply number: $shieldSupply');
      }
      if (gownSupply != null && gownSupply >= 0) {
        await _usersCollectionReference.document(id).updateData({"gownSupply": gownSupply});
        print('Saved new gown supply number: $gownSupply');
      }
      if (gloveSupply != null && gloveSupply >= 0) {
        await _usersCollectionReference.document(id).updateData({"gloveSupply": gloveSupply});
        print('Saved new glove supply number: $gloveSupply');
      }
      if (maskSupply != null && maskSupply >= 0) {
        await _usersCollectionReference.document(id).updateData({"maskSupply": maskSupply});
        print('Saved new mask supply number: $maskSupply');
      }
    } catch (e) {
      return e.message;
    }
  }
}
