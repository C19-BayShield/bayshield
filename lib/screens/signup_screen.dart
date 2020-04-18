import 'package:flutter/material.dart';
import 'package:supplyside/screens/root_screen.dart';
import 'package:supplyside/screens/user_type_screen.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {

  SignUpScreen({this.userId, this.auth, this.label});

  final String userId;
  final BaseAuth auth;
  final String label;

  @override
  State<StatefulWidget> createState() => new _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen>{
  final _formKey = new GlobalKey<FormState>();
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();

  String _name;
  String _email;
  String _phoneNumber;
  String _collectionHubName;
  String _medicalFacilityName;
  String _address;

  String _errorMessage;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('BayShield ' + widget.label + ' Signup'),
          backgroundColor: Color(0xFF313F84),
        ),
        body: Stack(
          children: <Widget>[
            _showForm()
          ],
        ));
  }

  // Check if form is valid before going to root screen
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Go to root screen when successfully signed up
  Future navigateToRootScreen(context, String userId) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootScreen(
      auth: widget.auth,
    )
    ))
    ;
  }

  // Go back to user type screen
  Future navigateToUserTypeScreen(context, String userId) async {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => UserTypeScreen(userId:widget.userId, auth: widget.auth,
      )
    ))
    ;
  }

  Future setCollectionHubInfo(String userId, String name, String email,
      String phoneNumber, String collectionHubName, String address) async {
    try {
      await _firestoreUsers.setUserName(userId, name);
      await _firestoreUsers.setUserEmail(userId, email);
      await _firestoreUsers.setUserPhoneNumber(userId, phoneNumber);
      await _firestoreUsers.setUserCollectionHubName(userId, collectionHubName);
      await _firestoreUsers.setUserAddress(userId, address);
    } catch (e) {
      return e.message;
    }
  }

  Future setMedicalFacilityInfo(String userId, String name, String email,
      String phoneNumber, String medicalFacilityName, String address) async {
    try {
      await _firestoreUsers.setUserName(userId, name);
      await _firestoreUsers.setUserEmail(userId, email);
      await _firestoreUsers.setUserPhoneNumber(userId, phoneNumber);
      await _firestoreUsers.setMedicalFacilityName(userId, medicalFacilityName);
      await _firestoreUsers.setUserAddress(userId, address);
    } catch (e) {
      return e.message;
    }
  }

  Future setMakerInfo(String userId, String name, String email,
      String phoneNumber, String address) async {
    try {
      await _firestoreUsers.setUserName(userId, name);
      await _firestoreUsers.setUserEmail(userId, email);
      await _firestoreUsers.setUserPhoneNumber(userId, phoneNumber);
      await _firestoreUsers.setUserAddress(userId, address);
    } catch (e) {
      return e.message;
    }
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(18.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showNameInput(),
              showEmailInput(),
              showPhoneNumberInput(),
              if (widget.label == 'Medical Facility') showMedicalFacilityNameInput(),
              if (widget.label == 'Collection Hub') showCollectionHubNameInput(),
              showAddressInput(),
              showPrimaryButton(),
              showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Last',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPhoneNumberInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone Number',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Phone number can\'t be empty' : null,
        onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showCollectionHubNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Collection Hub Name',
            icon: new Icon(
              Icons.business,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Collection hub name can\'t be empty' : null,
        onSaved: (value) => _collectionHubName = value.trim(),
      ),
    );
  }

  Widget showMedicalFacilityNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Medical Facility Name',
            icon: new Icon(
              Icons.business,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Medical facility name can\'t be empty' : null,
        onSaved: (value) => _medicalFacilityName = value.trim(),
      ),
    );
  }

  Widget showAddressInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Address',
            icon: new Icon(
              Icons.home,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
        onSaved: (value) => _address = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Color(0xFF313F84),
          child: new Text('Finish',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      ));
  }

  Widget showSecondaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.grey,
            child: new Text('Back',
                style: new TextStyle(fontSize: 20.0, color: Colors.black)),
            onPressed: backToUserType,
          ),
        ));
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        switch(widget.label) {
          case 'Medical Facility': {
            setMedicalFacilityInfo(widget.userId, _name, _email,
                _phoneNumber, _medicalFacilityName, _address);
            navigateToRootScreen(context, widget.userId);
          }
          break;
          case 'Maker': {
            setMakerInfo(widget.userId, _name, _email,
                _phoneNumber, _address);
            navigateToRootScreen(context, widget.userId);
          }
          break;
          case 'Collection Hub': {
            setCollectionHubInfo(widget.userId, _name, _email,
                _phoneNumber, _collectionHubName, _address);
            navigateToRootScreen(context, widget.userId);
          }
          break;
          default: {
          }
          break;
        }
      } catch (e) {
        print('Error: $e');

        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void backToUserType() {
    navigateToUserTypeScreen(context, widget.userId);
  }
}