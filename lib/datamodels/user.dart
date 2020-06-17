

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