

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

  MedicalFacility({id, String email, int phoneNumber, this.address, @required this.medicalFacilityName, this.staffSize}) :
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
      medicalFacilityName = data['medicalFacilityName'];

  String getFacilityName() {
    return this.medicalFacilityName;
  }

  String id;
  String email;
  String name;
  String address;
  String medicalFacilityName;
  int staffSize;
  String contactPersonName;
  String contactPersonTitle;

}