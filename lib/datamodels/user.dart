import 'package:flutter/cupertino.dart';

class User {

  String id;
  String email;
  String type;
  String name;
  String address;
  String phoneNumber;

  User({this.id, this.email, this.type});

  User.fromData(Map<String, dynamic> data)
    : id = data['id'],
      email = data['email'],
      type = data['type'] ?? '',
      name = data['name'],
      address = data['address'],
      phoneNumber = data['phoneNumber'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'type': type,
    };
  }

  String getType() {
    return this.type;
  }

  String getName() {
    return this.name;
  }

  String getAddress() {
    return this.address;
  }

  String getEmail() {
    return this.email;
  }

  String getPhoneNumber() {
    return this.phoneNumber;
  }
}

class MedicalFacility extends User {

  MedicalFacility({id, String email, String phoneNumber, 
  this.address, @required this.medicalFacilityName, int staff, int cases, List<int> supply}) :
    super(
      id: id, 
      email: email, 
      type: "Medical Facility"
    );

  @override
  MedicalFacility.fromData(Map<String, dynamic> data)
    : id= data['id'],
      email = data['email'],
      name = data['name'],
      address = data['address'],
      phoneNumber = data['phoneNumber'],
      medicalFacilityName = data['medicalFacilityName'],
      staff = data["staff"],
      cases = data["cases"],
      shieldSupply = data["shieldSupply"],
      gownSupply = data["gownSupply"],
      gloveSupply = data["gloveSupply"],
      maskSupply = data["maskSupply"]
      ;

  String getFacilityName() {
    return this.medicalFacilityName;
  }

  int getStaff() {
    return this.staff;
  }

  int getCases() {
    return this.cases;
  }

  List<int> getSupply() {
    return [shieldSupply ?? 0, gownSupply ?? 0, gloveSupply ?? 0, maskSupply ?? 0];
  }

  String id;
  String email;
  String name;
  String address;
  String medicalFacilityName;
  int shieldSupply;
  int gownSupply;
  int gloveSupply;
  int maskSupply;
  int staff;
  int cases;
  String contactPersonName;
  String contactPersonTitle;
  String phoneNumber;

}

class CollectionHub extends User {

  String id;
  String email;
  String name;
  String address;
  String phoneNumber;
  String collectionHubName;

  CollectionHub({id, String email, String phoneNumber,
    this.address, @required this.collectionHubName}) :
        super(
          id: id,
          email: email,
          type: "Collection Hub"
      );

  @override
  CollectionHub.fromData(Map<String, dynamic> data)
      : id = data['id'],
        email = data['email'],
        name = data['name'],
        address = data['address'],
        phoneNumber = data['phoneNumber'],
        collectionHubName = data['collectionHubName'],
        faceShieldUCSFA1Supply = data['Face Shield'] == null ? 0 : data['Face Shield']['UCSF A1'] ?? 0,
        faceShieldUCSFC1Supply = data['Face Shield'] == null ? 0 : data['Face Shield']['UCSF C1'] ?? 0,
        maskClothSupply = data['Mask'] == null ? 0 : data['Mask']['Cloth'] ?? 0,
        maskN95Supply = data['Mask'] == null ? 0 : data['Mask']['N95'] ?? 0,
        maskSurgicalSupply = data['Mask'] == null ? 0 : data['Mask']['Surgical'] ?? 0,
        glovesSurgicalSupply = data['Gloves'] == null ? 0 : data['Gloves']['Surgical'] ?? 0,
        glovesNitrileSupply = data['Gloves'] == null ? 0 : data['Gloves']['Nitrile'] ?? 0,
        glovesNeopreneSupply = data['Gloves'] == null ? 0 : data['Gloves']['Neoprene'] ?? 0,
        gogglesSurgicalSupply = data['Goggles'] == null ? 0 : data['Goggles']['Surgical'] ?? 0,
        gownRegularSupply = data['Gown'] == null ? 0 : data['Gown']['Regular'] ?? 0,
        handSanitizerRegularSupply = data['Hand Sanitizer'] == null ? 0 : data['Hand Sanitizer']['Regular'] ?? 0;

  String getFacilityName() {
    return this.collectionHubName;
  }

  int getSupply(String itemName, String itemType) {
    switch (itemName + " " + itemType) {
      case "Face Shield UCSF A1":
        return this.faceShieldUCSFA1Supply;
      case "Face Shield UCSF C1":
        return this.faceShieldUCSFC1Supply;
      case "Mask Cloth":
        return this.maskClothSupply;
      case "Mask N95":
        return this.maskN95Supply;
      case "Mask Surgical":
        return this.maskSurgicalSupply;
      case "Gloves Surgical":
        return this.glovesSurgicalSupply;
      case "Gloves Nitrile":
        return this.glovesNitrileSupply;
      case "Gloves Neoprene":
        return this.glovesNeopreneSupply;
      case "Goggles Surgical":
        return this.gogglesSurgicalSupply;
      case "Gown Regular":
        return this.gownRegularSupply;
      case "Hand Sanitizer Regular":
        return this.handSanitizerRegularSupply;
    }
  }

  int faceShieldUCSFA1Supply;
  int faceShieldUCSFC1Supply;
  int maskClothSupply;
  int maskN95Supply;
  int maskSurgicalSupply;
  int glovesSurgicalSupply;
  int glovesNitrileSupply;
  int glovesNeopreneSupply;
  int gogglesSurgicalSupply;
  int gownRegularSupply;
  int handSanitizerRegularSupply;
}