import 'package:flutter/material.dart';
import 'package:supplyside/screens/root_screen.dart';
import 'package:supplyside/screens/user_type_screen.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/datamodels/user.dart';

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

  String _phoneNumber;
  String _collectionHubName;
  String _medicalFacilityName;
  String _address;

  String _errorMessage;
  bool _isLoading;
  User user;

  Future getUser() async {
   User currUser = await _firestoreUsers.getUser(widget.userId);
    if (currUser != null) {
      if (!mounted) return;
      setState(() {
        user = currUser;
      });
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    Size screenSize = MediaQuery.of(context).size;
    
    if (user == null) {
      return buildWaitingScreen();
    } else { 
      String name = user.getName() ?? "";
      return Scaffold(
        body: Stack(
          children: <Widget>[
            new FullScreenCover(),
            SafeArea(
              child: ListView(
                children: <Widget>[
                    SizedBox(
                  height: screenSize.height / 6.0,
                  ),
                  Container(
                    margin: new EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/logo_small.png', height: 100, width: 100),
                        new UserTypeTagBlue(userTag: widget.label),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Hi " + name + "!",
                          style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                          ),
                        _showForm(),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      );
    }
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

  Future setCollectionHubInfo(String userId, 
      String phoneNumber, String collectionHubName, String address) async {
    try {
      await _firestoreUsers.setUserPhoneNumber(userId, phoneNumber);
      await _firestoreUsers.setUserCollectionHubName(userId, collectionHubName);
      await _firestoreUsers.setUserAddress(userId, address);
    } catch (e) {
      return e.message;
    }
  }

  Future setMedicalFacilityInfo(String userId, 
      String phoneNumber, String medicalFacilityName, String address) async {
    try {
      await _firestoreUsers.setUserPhoneNumber(userId, phoneNumber);
      await _firestoreUsers.setMedicalFacilityName(userId, medicalFacilityName);
      await _firestoreUsers.setUserAddress(userId, address);
    } catch (e) {
      return e.message;
    }
  }

  Future setMakerInfo(String userId, 
      String phoneNumber, String address) async {
    try {
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
              // showNameInput(),
              // showEmailInput(),
              showPhoneNumberInput(),
              if (widget.label == 'Medical Organization') showMedicalFacilityNameInput(),
              if (widget.label == 'Collection Hub') showCollectionHubNameInput(),
              showAddressInput(),
              new SizedBox(height: 24),
              new PrimaryButton(submit: validateAndSubmit, label: "Get Started"),
            ],
          ),
        ));
  }

  // Widget showNameInput() {
  //   return new BayShieldFormField(
  //     hint: 'First Last', 
  //     icon: Icons.account_circle,
  //     validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
  //     onSaved: (value) => _name = value.trim(),
  //   );
  // }

  // Widget showEmailInput() {
  //   return new BayShieldFormField(
  //     hint: 'Email',
  //     icon: Icons.mail,
  //     validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
  //     onSaved: (value) => _email = value.trim(),
  //   );
  // }

  Widget showPhoneNumberInput() {
    return new BayShieldFormField(
      hint: 'Phone Number',
      icon: Icons.phone,
      validator: (value) => value.isEmpty ? 'Phone number can\'t be empty' : null,
      onSaved: (value) => _phoneNumber = value.trim(),
    );
  }

  Widget showCollectionHubNameInput() {
    return new BayShieldFormField(
      hint: 'Collection Hub Name',
      icon: Icons.business,
      validator: (value) => value.isEmpty ? 'Collection hub name can\'t be empty' : null,
      onSaved: (value) => _collectionHubName = value.trim(),
    );
  }

  Widget showMedicalFacilityNameInput() {
    return new BayShieldFormField(
      hint: 'Medical Facility Name',
      icon: Icons.business,
      validator: (value) => value.isEmpty ? 'Medical facility name can\'t be empty' : null,
      onSaved: (value) => _medicalFacilityName = value.trim(),
    );
  }

  Widget showAddressInput() {
    return new BayShieldFormField(
      hint: 'Address',
      icon: Icons.home,
      validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
      onSaved: (value) => _address = value.trim(),
    );
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        switch(widget.label) {
          case 'Medical Organization': {
            setMedicalFacilityInfo(widget.userId, 
                _phoneNumber, _medicalFacilityName, _address);
            navigateToRootScreen(context, widget.userId);
          }
          break;
          case 'Maker': {
            setMakerInfo(widget.userId, 
                _phoneNumber, _address);
            navigateToRootScreen(context, widget.userId);
          }
          break;
          case 'Collection Hub': {
            setCollectionHubInfo(widget.userId,
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