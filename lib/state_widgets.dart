import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/util/firestore_users.dart';

class ProfileSettings extends StatefulWidget {
  
  ProfileSettings({Key key, @required this.user, @required this.title, this.callback}) : super(key: key);

  final User user;
  final String title;
  final VoidCallback callback;

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
              ),
            if (_editButtonPressed) SizedBox(height: 20),
            new Padding (
              padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: new Container(
                  width: MediaQuery.of(context).size.width - 110,
                  decoration: BoxDecoration(
                      color: Color(0xFF283568),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: new FlatButton(
                    child: new Text("Sign Out",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                    onPressed: () {
                      widget.callback();
                    },
                  )
              ),
            ),
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

class InventoryPage extends StatefulWidget {
  InventoryPage({Key key, @required this.user}) : super(key: key);

  final CollectionHub user;

  @override
  State<StatefulWidget> createState() => new _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();

  bool _inventoryEditButtonPressed = false;

  int faceShieldUCSFA1;
  int faceShieldUCSFC1;
  int maskCloth;
  int maskN95;
  int maskSurgical;
  int glovesSurgical;
  int glovesNitrile;
  int glovesNeoprene;
  int gogglesSurgical;
  int gown;
  int handSanitizer;

  TextEditingController faceShieldController1 = TextEditingController();
  TextEditingController faceShieldController2 = TextEditingController();
  TextEditingController maskController1 = TextEditingController();
  TextEditingController maskController2 = TextEditingController();
  TextEditingController maskController3 = TextEditingController();
  TextEditingController glovesController1 = TextEditingController();
  TextEditingController glovesController2 = TextEditingController();
  TextEditingController glovesController3 = TextEditingController();
  TextEditingController gogglesController = TextEditingController();
  TextEditingController gownController = TextEditingController();
  TextEditingController handSanitizerController = TextEditingController();

  void _onInventoryEditButtonPressed() {
    _inventoryEditButtonPressed = !_inventoryEditButtonPressed;
    clearControllers();
    build(context);
  }

  void clearControllers() {
    faceShieldController1.clear();
    faceShieldController2.clear();
    maskController1.clear();
    maskController2.clear();
    maskController3.clear();
    glovesController1.clear();
    glovesController2.clear();
    glovesController3.clear();
    gogglesController.clear();
    gownController.clear();
    handSanitizerController.clear();
  }

  Widget showInventoryCards(bool edit) {

    List<Widget> list = new List<Widget>();

    faceShieldUCSFA1 = widget.user.getSupply("Face Shield", "UCSF A1") ?? 0;
    faceShieldUCSFC1 = widget.user.getSupply("Face Shield", "UCSF C1") ?? 0;
    maskCloth = widget.user.getSupply("Mask", "Cloth") ?? 0;
    maskN95 = widget.user.getSupply("Mask", "N95") ?? 0;
    maskSurgical = widget.user.getSupply("Mask", "Surgical") ?? 0;
    glovesSurgical = widget.user.getSupply("Gloves", "Surgical") ?? 0;
    glovesNitrile = widget.user.getSupply("Gloves", "Nitrile") ?? 0;
    glovesNeoprene = widget.user.getSupply("Gloves", "Neoprene") ?? 0;
    gogglesSurgical = widget.user.getSupply("Goggles", "Surgical") ?? 0;
    gown = widget.user.getSupply("Gown", "Regular") ?? 0;
    handSanitizer = widget.user.getSupply("Hand Sanitizer", "Regular") ?? 0;

    if (faceShieldUCSFA1 > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/face_shield_card.png",
            itemName: "Face Shield", quantity: faceShieldUCSFA1, itemType: "UCSF A1", controller: faceShieldController1));
      } else {
        list.add(InventoryCard(asset: "assets/images/face_shield_card.png",
            itemName: "Face Shield", quantity: faceShieldUCSFA1, itemType: "UCSF A1"));
      }
    }

    if (faceShieldUCSFC1 > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/face_shield_card.png",
            itemName: "Face Shield", quantity: faceShieldUCSFC1, itemType: "UCSF C1", controller: faceShieldController2));
      } else {
        list.add(InventoryCard(asset: "assets/images/face_shield_card.png",
            itemName: "Face Shield", quantity: faceShieldUCSFC1, itemType: "UCSF C1"));
      }
    }

    if (maskCloth > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskCloth, itemType: "Cloth", controller: maskController1));
      } else {
        list.add(InventoryCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskCloth, itemType: "Cloth"));
      }
    }

    if (maskN95 > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskN95, itemType: "N95", controller: maskController2));
      } else {
        list.add(InventoryCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskN95, itemType: "N95"));
      }
    }

    if (maskSurgical > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskSurgical, itemType: "Surgical", controller: maskController3));
      } else {
        list.add(InventoryCard(asset: "assets/images/n95_card.png",
            itemName: "Mask", quantity: maskSurgical, itemType: "Surgical"));
      }
    }

    if (glovesSurgical > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesSurgical, itemType: "Surgical", controller: glovesController1));
      } else {
        list.add(InventoryCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesSurgical, itemType: "Surgical"));
      }
    }

    if (glovesNitrile > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesNitrile, itemType: "Nitrile", controller: glovesController2));
      } else {
        list.add(InventoryCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesNitrile, itemType: "Nitrile"));
      }
    }

    if (glovesNeoprene > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesNeoprene, itemType: "Neoprene", controller: glovesController3));
      } else {
        list.add(InventoryCard(asset: "assets/images/gloves_card.png",
            itemName: "Gloves", quantity: glovesNeoprene, itemType: "Neoprene"));
      }
    }

    if (gogglesSurgical > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/goggles_card.png",
            itemName: "Goggles", quantity: gogglesSurgical, itemType: "Surgical", controller: gogglesController));
      } else {
        list.add(InventoryCard(asset: "assets/images/goggles_card.png",
            itemName: "Goggles", quantity: gogglesSurgical, itemType: "Surgical"));
      }
    }

    if (gown > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/gown_card.png",
            itemName: "Gown", quantity: gown, itemType: "Regular", controller: gownController));
      } else {
        list.add(InventoryCard(asset: "assets/images/gown_card.png",
            itemName: "Gown", quantity: gown, itemType: "Regular"));
      }
    }

    if (handSanitizer > 0) {
      if (edit) {
        list.add(InventoryEditCard(asset: "assets/images/sanitizer_card.png",
            itemName: "Hand Sanitizer", quantity: handSanitizer, itemType: "Regular", controller: handSanitizerController));
      } else {
        list.add(InventoryCard(asset: "assets/images/sanitizer_card.png",
            itemName: "Hand Sanitizer", quantity: handSanitizer, itemType: "Regular"));
      }
    }

    return new Column(children: list);
  }

  void updateInventory() async {
    _firestoreUsers.setHubInventory(widget.user.id, "Gown", "Regular", gownController.text == "" ? gown : int.parse(gownController.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Face Shield", "UCSF A1", faceShieldController1.text == "" ? faceShieldUCSFA1 : int.parse(faceShieldController1.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Face Shield", "UCSF C1", faceShieldController2.text == "" ? faceShieldUCSFC1 : int.parse(faceShieldController2.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Mask", "Cloth", maskController1.text == "" ? maskCloth : int.parse(maskController1.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Mask", "N95", maskController2.text == "" ? maskN95 : int.parse(maskController2.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Mask", "Surgical", maskController3.text == "" ? maskSurgical : int.parse(maskController3.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Gloves", "Surgical", glovesController1.text == "" ? glovesSurgical : int.parse(glovesController1.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Gloves", "Nitrile", glovesController2.text == "" ? glovesNitrile : int.parse(glovesController2.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Gloves", "Neoprene", glovesController3.text == "" ? glovesNeoprene : int.parse(glovesController3.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Goggles", "Surgical", gogglesController.text == "" ? gogglesSurgical : int.parse(gogglesController.text));
    _firestoreUsers.setHubInventory(widget.user.id, "Hand Sanitizer", "Regular", handSanitizerController.text == "" ? handSanitizer : int.parse(handSanitizerController.text));
  }

  Widget build(BuildContext context) {
    return new Padding (
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: new Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new IconButton(
                    onPressed: _onInventoryEditButtonPressed,
                    icon: Image.asset("assets/images/edit_button.png", height: 26, alignment: Alignment.centerRight),
                  )
                ]
            ),
            if (!_inventoryEditButtonPressed) showInventoryCards(false),
            if (_inventoryEditButtonPressed) showInventoryCards(true),
            if (_inventoryEditButtonPressed) new Row (
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
                          updateInventory();
                          clearControllers();
                          _inventoryEditButtonPressed = false;
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
                        _inventoryEditButtonPressed = false;
                        build(context);
                      },
                    )
                  ),
                ]
              )
            ]
          )
      ),
    );
  }
}

class PickupPage extends StatefulWidget {

  PickupPage({Key key, @required this.user}) : super(key: key);

  final Maker user;

  @override
  State<StatefulWidget> createState() => new _PickupPageState();
}

class _PickupPageState extends State<PickupPage>{

  int _itemValue;
  int _materialValue;
  int _newQuantity;

  String _date = "";
  String _time = "";

  bool _bootiesChosen = false;
  bool _faceShieldChosen = false;
  bool _gownChosen = false;
  bool _maskChosen = false;

  List<DropdownMenuItem<dynamic>> items = [
    DropdownMenuItem(
      child: Text("Booties"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Face Shield"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Gown"),
      value: 2
    ),
    DropdownMenuItem(
      child: Text("Mask"),
      value: 3
    ),
  ];

  List<DropdownMenuItem<dynamic>> faceShieldMaterials = [
    DropdownMenuItem(
      child: Text("PETG"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Acrylic"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Other"),
      value: 2
    ),
  ];

  List<DropdownMenuItem<dynamic>> otherMaterials = [
    DropdownMenuItem(
      child: Text("Cloth"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Wool"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("Synthetic Fibers"),
      value: 2
    ),
    DropdownMenuItem(
      child: Text("Other"),
      value: 3
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new Padding(
                      child: new Text("New Pickup", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      padding: EdgeInsets.only(top: 30, bottom: 25)
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new Padding(
                      child: new Text("ITEM TO BE PICKED UP", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      padding: EdgeInsets.only(top: 15)
                  )
              ),
              new DropDownMenu(
                value: _itemValue,
                hint: "Select Item",
                items: items,
                onChanged: (value) {
                  setState(() {
                    _itemValue = value;
                    _materialValue = null;
                    _bootiesChosen = _itemValue == 0;
                    _faceShieldChosen = _itemValue == 1;
                    _gownChosen = _itemValue == 2;
                    _maskChosen = _itemValue == 3;
                  });
                }
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new Padding(
                      child: new Text("MATERIAL", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      padding: EdgeInsets.only(top: 15)
                  )
              ),
              if (_faceShieldChosen) new DropDownMenu(
                value: _materialValue,
                hint: "Select Type",
                items: faceShieldMaterials,
                onChanged: (value) {
                  setState(() {
                    _materialValue = value;
                  });
                }
              ),
              if (!_bootiesChosen && !_faceShieldChosen && !_gownChosen && !_maskChosen) new DropDownMenu(
                  value: _materialValue,
                  hint: "Select Type",
                  items: [
                    DropdownMenuItem(
                    child: Text("Please first choose an item"))
                  ],
                  onChanged: (value) {
                  }
              ),
              if (!_faceShieldChosen && (_bootiesChosen || _gownChosen || _maskChosen)) new DropDownMenu(
                  value: _materialValue,
                  hint: "Select Type",
                  items: otherMaterials,
                  onChanged: (value) {
                    setState(() {
                      _materialValue = value;
                    });
                  }
              ),
              new Container(
                width: MediaQuery.of(context).size.width - 110,
                child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding (
                        padding: EdgeInsets.only(top: 15),
                        child: new Text("QUANTITY", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,),
                      ),
                      new Container (
                        child: new TextField(
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          scrollPadding: EdgeInsets.symmetric(horizontal: 16),
                          maxLines: 1,
                          autofocus: false,
                          decoration: new InputDecoration(
                              labelText: "Ex. 100",
                              labelStyle: TextStyle(fontSize: 15,
                                  color: Color(0xFFB3B3B3)
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black, width: 1,)
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black, width: 1,)
                              )
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            _newQuantity = int.parse(value);
                          },
                        ),
                      ),
                    ]
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new Padding(
                      child: new Text("DATE AND TIME", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),
                      padding: EdgeInsets.only(top: 15, bottom: 15)
                  )
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 110,
                  color: Colors.transparent,
                  child: new Row (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text("Date:", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto',), textAlign: TextAlign.left,),
                        new Container(
                          child: new FlatButton(
                            child: new Text("Choose",
                              style: TextStyle(color: Color(0xFF283568), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(Duration(days: 1)),
                                lastDate: DateTime(DateTime.now().year + 1),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: Color(0xFF283568),
                                      accentColor: Color(0xFF283568)
                                    ),
                                    child: child,
                                  );
                                },
                              ).then((date) {
                                setState(() {
                                  DateTime unformatted = DateTime.parse(date.toString());
                                  _date = "${unformatted.month}/${unformatted.day}/${unformatted.year}";
                                });
                              });
                            },
                          ),
                        ),
                        new Text(_date, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                      ]
                  ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 110,
                color: Colors.transparent,
                child: new Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text("Time:", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                      new Container(
                        child: new FlatButton(
                          child: new Text("Choose",
                            style: TextStyle(color: Color(0xFF283568), fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,),
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                      primaryColor: Color(0xFF283568),
                                      accentColor: Color(0xFF283568)
                                  ),
                                  child: child,
                                );
                              },
                            ).then((time) {
                              setState(() {
                                _time = time.format(context).toString();
                              });
                            });
                          },
                        )
                      ),
                      new Text(_time, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Roboto'), textAlign: TextAlign.left),
                    ]
                ),
              ),
              SizedBox(height: 30),
              new RequestButton(onPressed: null),
              SizedBox(height: 20),
            ],
          )
      )
    );
  }
}

class OrderSuppliesPage extends StatefulWidget {

  OrderSuppliesPage({Key key, @required this.user}) : super(key: key);

  final Maker user;

  @override
  State<StatefulWidget> createState() => new _OrderSuppliesPageState();
}

class _OrderSuppliesPageState extends State<OrderSuppliesPage>{

  int _itemValue;
  int _materialValue;
  int _newQuantity;

  List<DropdownMenuItem<dynamic>> items = [
    DropdownMenuItem(
      child: Text("3-D Printing - ABS Filament"),
      value: 0
    ),
    DropdownMenuItem(
      child: Text("3-D Printing - PLA Filament"),
      value: 1
    ),
    DropdownMenuItem(
      child: Text("3-D Printing - PETG Filament"),
      value: 2
    ),
    DropdownMenuItem(
      child: Text("3-D Printing - Ziplock Bags"),
      value: 3
    ),
    DropdownMenuItem(
      child: Text("Sewing - Cloth Material"),
      value: 4
    ),
    DropdownMenuItem(
      child: Text("Sewing - Elastic Banding"),
      value: 5
    ),
    DropdownMenuItem(
      child: Text("Sewing - Needles"),
      value: 6
    ),
    DropdownMenuItem(
      child: Text("Sewing - Sewing Thread"),
      value: 7
    ),
    DropdownMenuItem(
      child: Text("Laser Cutting - PETG Plastic Sheet"),
      value: 8
    ),
    DropdownMenuItem(
      child: Text("Laser Cutting - Acrylic Sheet"),
      value: 9
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - Xacto Knife Blades"),
      value: 10
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - Scissors"),
      value: 11
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - Cloth Material"),
      value: 12
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - PETG Plastic Sheet"),
      value: 13
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - Acrylic Sheet"),
      value: 14
    ),
    DropdownMenuItem(
      child: Text("Hand Cutting - Elastic Banding"),
      value: 15
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    color: Colors.transparent,
                    child: new Padding(
                        child: new Text("Order Supplies", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,),
                        padding: EdgeInsets.only(top: 30, bottom: 25)
                    )
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 110,
                    color: Colors.transparent,
                    child: new Padding(
                        child: new Text("WHAT DO YOU NEED?", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,),
                        padding: EdgeInsets.only(top: 15)
                    )
                ),
                new DropDownMenu(
                    value: _itemValue,
                    hint: "Select Item",
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        _itemValue = value;
                      });
                    }
                ),
                new Container(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding (
                          padding: EdgeInsets.only(top: 15),
                          child: new Text("QUANTITY", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,),
                        ),
                        new Container (
                          child: new TextField(
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.left,
                            scrollPadding: EdgeInsets.symmetric(horizontal: 16),
                            maxLines: 1,
                            autofocus: false,
                            decoration: new InputDecoration(
                                labelText: "Ex. 100",
                                labelStyle: TextStyle(fontSize: 15,
                                    color: Color(0xFFB3B3B3)
                                ),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.black, width: 1,)
                                ),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.black, width: 1,)
                                )
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              _newQuantity = int.parse(value);
                            },
                          ),
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 20),
                new RequestButton(onPressed: null),
                SizedBox(height: 20),
              ],
            )
        )
    );
  }
}

class AddMethodPage extends StatefulWidget {

  AddMethodPage({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  State<StatefulWidget> createState() => new _AddMethodPageState();
}

class _AddMethodPageState extends State<AddMethodPage>{

  int _methodValue;
  int _materialValue;
  int _ppeValue;
  int _newQuantity;

  bool _printingChosen = false;
  bool _sewingChosen = false;
  bool _laserCuttingChosen = false;
  bool _handCuttingChosen = false;

  List<DropdownMenuItem<dynamic>> cuttingMaterials = [
    DropdownMenuItem(
      child: Text("PETG"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Acrylic"),
      value: 1,
    ),
    DropdownMenuItem(
        child: Text("Other"),
        value: 2
    ),
  ];

  List<DropdownMenuItem<dynamic>> laserCuttingPPE = [
    DropdownMenuItem(
      child: Text("USCF Shield"),
    ),
  ];

  List<DropdownMenuItem<dynamic>> handCuttingPPE = [
    DropdownMenuItem(
      child: Text("USCF Shield"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Elastic Shield Band"),
      value: 1,
    ),
  ];

  List<DropdownMenuItem<dynamic>> sewingMaterials = [
    DropdownMenuItem(
      child: Text("Cloth"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Wool"),
      value: 1,
    ),
    DropdownMenuItem(
        child: Text("Synthetic Fibers"),
        value: 2
    ),
    DropdownMenuItem(
        child: Text("Other"),
        value: 3
    ),
  ];

  List<DropdownMenuItem<dynamic>> sewingPPE = [
    DropdownMenuItem(
      child: Text("Face Mask"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Surgical Gown"),
      value: 1,
    ),
    DropdownMenuItem(
        child: Text("Booties"),
        value: 2
    ),
    DropdownMenuItem(
        child: Text("Coveralls"),
        value: 3
    ),
  ];

  List<DropdownMenuItem<dynamic>> printingMaterials = [
    DropdownMenuItem(
      child: Text("ABS"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("PLA"),
      value: 1,
    ),
    DropdownMenuItem(
        child: Text("PETG"),
        value: 2
    ),
  ];

  List<DropdownMenuItem<dynamic>> printingPPE = [
    DropdownMenuItem(
      child: Text("USCF Shield A1"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("USCF Shield C1"),
      value: 1,
    ),
  ];

  List<DropdownMenuItem<dynamic>> methods = [
    DropdownMenuItem(
      child: Text("3D Printing"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("Sewing"),
      value: 1,
    ),
    DropdownMenuItem(
        child: Text("Laser Cutting"),
        value: 2
    ),
    DropdownMenuItem(
        child: Text("Hand Cutting"),
        value: 3
    ),
  ];

  Widget build(BuildContext context) {

    return new Padding (
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
            width: MediaQuery.of(context).size.width - 100,
            child: new Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width - 110,
                      color: Colors.transparent,
                      child: new Padding(
                          child: new Text("Add Method", style: TextStyle(color: Colors.black, fontSize: 45, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,),
                          padding: EdgeInsets.only(top: 30, bottom: 25)
                      )
                  ),
                  new DropDownMenu(
                      value: _methodValue,
                      hint: "Select Item",
                      items: methods,
                      onChanged: (value) {
                        setState(() {
                          _methodValue = value;
                          _materialValue = null;
                          _ppeValue = null;
                          _printingChosen = _methodValue == 0;
                          _sewingChosen = _methodValue == 1;
                          _laserCuttingChosen = _methodValue == 2;
                          _handCuttingChosen = _methodValue == 3;
                        });
                      }
                  ),
                  if (_handCuttingChosen || _laserCuttingChosen) new DropDownMenu(
                      value: _materialValue,
                      hint: "Select Material",
                      items: cuttingMaterials,
                      onChanged: (value) {
                        setState(() {
                          _materialValue = value;
                        });
                      }
                  ),
                  if (_handCuttingChosen) new DropDownMenu(
                      value: _ppeValue,
                      hint: "Type of PPE",
                      items: handCuttingPPE,
                      onChanged: (value) {
                        setState(() {
                          _ppeValue = value;
                        });
                      }
                  ),
                  if (_laserCuttingChosen) new DropDownMenu(
                      value: _ppeValue,
                      hint: "Type of PPE",
                      items: laserCuttingPPE,
                      onChanged: (value) {
                        setState(() {
                          _ppeValue = value;
                        });
                      }
                  ),
                  if (_sewingChosen) new DropDownMenu(
                      value: _materialValue,
                      hint: "Select Material",
                      items: sewingMaterials,
                      onChanged: (value) {
                        setState(() {
                          _materialValue = value;
                        });
                      }
                  ),
                  if (_sewingChosen) new DropDownMenu(
                      value: _ppeValue,
                      hint: "Type of PPE",
                      items: sewingPPE,
                      onChanged: (value) {
                        setState(() {
                          _ppeValue = value;
                        });
                      }
                  ),
                  if (_printingChosen) new DropDownMenu(
                      value: _materialValue,
                      hint: "Select Material",
                      items: printingMaterials,
                      onChanged: (value) {
                        setState(() {
                          _materialValue = value;
                        });
                      }
                  ),
                  if (_printingChosen) new DropDownMenu(
                      value: _ppeValue,
                      hint: "Type of PPE",
                      items: printingPPE,
                      onChanged: (value) {
                        setState(() {
                          _ppeValue = value;
                        });
                      }
                  ),
                  if (_handCuttingChosen || _laserCuttingChosen || _sewingChosen || _printingChosen) new Container(
                    width: MediaQuery.of(context).size.width - 110,
                    child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container (
                            child: new TextField(
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.left,
                              scrollPadding: EdgeInsets.symmetric(horizontal: 16),
                              maxLines: 1,
                              autofocus: false,
                              decoration: new InputDecoration(
                                  labelText: "Estimated Weekly Output",
                                  labelStyle: TextStyle(fontSize: 15,
                                      color: Color(0xFFB3B3B3)
                                  ),
                                  enabledBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black, width: 1,)
                                  ),
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.black, width: 1,)
                                  )
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                _newQuantity = int.parse(value);
                              },
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width - 110,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF283568),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        child: new FlatButton(
                          child: new Text("Save Method",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,),
                          onPressed: null,
                        )
                    ),
                  )
                ]
            )
        )
    );
  }
}
