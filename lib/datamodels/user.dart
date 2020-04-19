

import 'package:flutter/cupertino.dart';

class User {

  String id;
  String email;
  String type;
  String name;
  String address;
  User({this.id, this.email, this.type});

  User.fromData(Map<String, dynamic> data)
    : id = data['id'],
      email = data['email'],
      type = data['type'] ?? '',
      name = data['name'],
      address = data['address'];
      
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
 
}

class MedicalFacility extends User {

  MedicalFacility({String id, String email, int phoneNumber, this.address, @required this.orgName, this.staffSize}) :
    super(
      id: id, 
      email: email, 
      type: "Medical Facility"
    );

  String address;
  String orgName;
  int staffSize;
  String contactPersonName;
  String contactPersonTitle;

}