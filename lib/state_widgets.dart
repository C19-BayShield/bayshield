import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/firestore_users.dart';

class ProfileSettings extends StatefulWidget {
  
  ProfileSettings({Key key, @required this.user, @required this.title}) : super(key: key);

  final User user;
  final String title;

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
    String name = widget.user.getName() ?? "";
    String email = widget.user.getEmail() ?? "";
    String phoneNo = widget.user.getPhoneNumber() ?? "";
    String address = widget.user.getAddress() ?? "";

    return new Padding (
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: new Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(widget.title, style: 
                  TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    textAlign: TextAlign.left,),
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
                    child: new Text(name, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                      textAlign: TextAlign.left,),
                  ),
                if (_editButtonPressed)
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new EditFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        hint: name,
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
                      child: new Text(email, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new EditFormField(
                          controller: emailController,
                          type: TextInputType.text,
                          hint: email,
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
                      child: new Text(phoneNo, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new EditFormField(
                          controller: phoneNumberController,
                          type: TextInputType.number,
                          hint: phoneNo,
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
                      child: new Text(address, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                      child: new EditFormField(
                        controller: addressController,
                        type: TextInputType.text,
                        hint: address,
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

class MedorgsStatus extends StatefulWidget {
  
  MedorgsStatus({Key key, @required this.user}) : super(key: key);

  final MedicalFacility user;

  @override
  State<StatefulWidget> createState() => new _MedorgsStatusState();
}

class _MedorgsStatusState extends State<MedorgsStatus>{
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();
  bool _editButtonPressed = false;
  TextEditingController staffController = TextEditingController();
  TextEditingController casesController = TextEditingController();
  // Under Supply
  TextEditingController shieldSupplyController = TextEditingController();
  TextEditingController gownSupplyController = TextEditingController();
  TextEditingController gloveSupplyController = TextEditingController();
  TextEditingController maskSupplyController = TextEditingController();

  void _onEditButtonPressed() {
    _editButtonPressed = !_editButtonPressed;
    clearControllers();
    build(context);
  }

  void clearControllers() {
    staffController.clear();
    casesController.clear();
    shieldSupplyController.clear();
    gownSupplyController.clear();
    gloveSupplyController.clear();
    maskSupplyController.clear(); 
  }

  void updateUser() async {
    await _firestoreUsers.setOrgDetails(widget.user.id,
      int.parse(staffController.text), 
      int.parse(casesController.text),
      int.parse(shieldSupplyController.text),
      int.parse(gownSupplyController.text),
      int.parse(gloveSupplyController.text),
      int.parse(maskSupplyController.text)
      );
    clearControllers();
  }

  Widget build(BuildContext context) {
    int staff = widget.user.getStaff() ?? 0;
    int cases = widget.user.getCases() ?? 0;
    var supply = widget.user.getSupply() ?? [0, 0, 0, 0];

    return new Padding (
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: new Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Organization Details", style: 
                  TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    textAlign: TextAlign.left,),
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
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: new Text("Number of Personnel", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,)
                ),
                if (!_editButtonPressed)
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: new Text(staff.toString(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                      textAlign: TextAlign.left,),
                  ),
                if (_editButtonPressed)
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new EditFormField(
                        controller: staffController,
                        type: TextInputType.number,
                        hint: staff.toString(),
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Text("Reported Cases", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,)
                  ),
                  if (!_editButtonPressed)
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new Text(cases.toString(), style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
                        textAlign: TextAlign.left,),
                    ),
                  if (_editButtonPressed)
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: new EditFormField(
                          controller: casesController,
                          type: TextInputType.text,
                          hint: cases.toString(),
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: new Text("Current Supply", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,)
                  ),
                ]
            ),
            SizedBox(height: 10),
            new Container(margin: new EdgeInsets.only(left: 16.0),
              child: new Column (children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: new Text("Face Shields", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,)
                      ),
                      if (!_editButtonPressed)
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: new Text(supply[0].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,),
                        ),
                      if (_editButtonPressed)
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                          child: new EditFormField(
                            controller: shieldSupplyController,
                            type: TextInputType.text,
                            hint: supply[0].toString(),
                            maxLines: 1,
                          )
                        ),
                    ]
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: new Text("Gowns", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,)
                      ),
                      if (!_editButtonPressed)
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: new Text(supply[1].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,),
                        ),
                      if (_editButtonPressed)
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                          child: new EditFormField(
                            controller: gownSupplyController,
                            type: TextInputType.text,
                            hint: supply[1].toString(),
                            maxLines: 1,
                          )
                        ),
                    ]
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: new Text("Gloves", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,)
                      ),
                      if (!_editButtonPressed)
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: new Text(supply[2].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,),
                        ),
                      if (_editButtonPressed)
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                          child: new EditFormField(
                            controller: gloveSupplyController,
                            type: TextInputType.text,
                            hint: supply[2].toString(),
                            maxLines: 1,
                          )
                        ),
                    ]
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: new Text("Masks", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,)
                      ),
                      if (!_editButtonPressed)
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: new Text(supply[3].toString(), style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                            textAlign: TextAlign.left,),
                        ),
                      if (_editButtonPressed)
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                          child: new EditFormField(
                            controller: maskSupplyController,
                            type: TextInputType.text,
                            hint: supply[3].toString(),
                            maxLines: 1,
                          )
                        ),
                    ]
                ),
            ])),
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