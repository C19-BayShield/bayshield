

import 'package:flutter/cupertino.dart';

class User {

  String email;
  int phoneNumber;
  User(this.email, this.phoneNumber);
  User.named({this.email, this.phoneNumber});

}

class MedicalFacility extends User {

  MedicalFacility({String email, int phoneNumber, this.address, @required this.orgName, this.staffSize}) :
    super(email, phoneNumber);

  String address;
  String orgName;
  int staffSize;
  String contactPersonName;
  String contactPersonTitle;

}