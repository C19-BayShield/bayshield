import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/firestore_users.dart';

class ProfileSettings extends StatefulWidget {
  
  ProfileSettings({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  State<StatefulWidget> createState() => new _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSettings>{
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  bool _editButtonPressed = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void _onEditButtonPressed() {
    _editButtonPressed = !_editButtonPressed;
    clearControllers();
    build(context);
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    addressController.clear();
  }

  void updateUser() async {
    await _firestoreUsers.setUserName(widget.user.id, nameController.text == "" ? 
      widget.user.getName() : nameController.text);
    await _firestoreUsers.setUserEmail(widget.user.id, emailController.text == "" ? 
      widget.user.getEmail() : emailController.text);
    await _firestoreUsers.setUserPhoneNumber(widget.user.id, phoneNumberController.text == "" ?
      widget.user.getPhoneNumber() : phoneNumberController.text);
    await _firestoreUsers.setUserAddress(widget.user.id, addressController.text == "" ? 
      widget.user.getAddress() : addressController.text);
    clearControllers();
  }

  Widget build(BuildContext context) {
    return new Padding (
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: new Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new IconButton(
                  onPressed: _onEditButtonPressed,
                  icon: Image.asset("assets/images/edit_button.png", height: 26, alignment: Alignment.centerRight),
                )
              ]
            ),
            SizedBox(height: 5),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: new Text("Name", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,)
                ),
                if (!_editButtonPressed)
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: new Text(widget.user.getName(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                      textAlign: TextAlign.left,),
                  ),
                if (_editButtonPressed)
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new EditFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        hint: widget.user.getName(),
                        maxLines: 1,
                      )
                  ),
              ]
            ),
            SizedBox(height: 10),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new Text("Email", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,)
                  ),
                  if (!_editButtonPressed)
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Text(widget.user.getEmail(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new EditFormField(
                          controller: emailController,
                          type: TextInputType.text,
                          hint: widget.user.getEmail(),
                          maxLines: 1,
                        )
                    ),
                ]
            ),
            SizedBox(height: 10),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new Text("Phone", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,)
                  ),
                  if (!_editButtonPressed)
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Text(widget.user.getPhoneNumber(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new EditFormField(
                          controller: phoneNumberController,
                          type: TextInputType.number,
                          hint: widget.user.getPhoneNumber(),
                          formatter: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          maxLines: 1,
                        )
                    ),
                ]
            ),
            SizedBox(height: 10),
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new Text("Address", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,)
                  ),
                  if (!_editButtonPressed)
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Text(widget.user.getAddress(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                      child: new EditFormField(
                        controller: addressController,
                        type: TextInputType.text,
                        hint: widget.user.getAddress(),
                        maxLines: 1,
                      )
                    ),
                ]
            ),
            SizedBox(height: 20),
            if (_editButtonPressed)
              new Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding (
                      padding: EdgeInsets.only(right: 4),
                      child: new Container(
                          width: (MediaQuery.of(context).size.width - 120) * 0.5,
                          child: new FlatButton(
                            child: new Text("Save",
                              style: TextStyle(color: Color(0xFF283568), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,),
                            onPressed: () {
                              updateUser();
                              _editButtonPressed = false;
                              build(context);
                            },
                          )
                      ),
                    ),
                    new Container(
                        width: (MediaQuery.of(context).size.width - 120) * 0.5,
                        child: new FlatButton(
                          child: new Text("Cancel",
                            style: TextStyle(color: Color(0xFFD48032), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,),
                          onPressed: () {
                            _editButtonPressed = false;
                            clearControllers();
                            build(context);
                          },
                        )
                    ),
                  ]
              )
          ]
        )
      )
    );
  }
}