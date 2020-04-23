import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplyside/screens/info_question_screen.dart';
import 'package:supplyside/screens/consumer_request_screen.dart';

class QuantityScreen extends StatefulWidget {
  QuantityScreen({this.key, this.selected});

  final Key key;
  final Map<String, bool> selected;

  @override
  State<StatefulWidget> createState() => new _QuantityScreenState();

}

class _QuantityScreenState extends State<QuantityScreen>{

  Map<String, int> quantities= {
    "Aersol Box": 0,
    "Body Suit": 0,
    "Face Shield": 0,
    "Gloves": 0,
    "Goggles": 0,
    "N95 Regular": 0,
    "N95 Small": 0,
    "Sanitizer": 0,
    "Surgical Mask": 0,
    "Wipes": 0,
  };

  bool _zeroQuantity = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Builder(
          builder: (BuildContext context)
    {
      return SafeArea(
        child: Center(
            child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('Request Parts Form', style: Theme
                                .of(context)
                                .textTheme
                                .headline2,),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Input quantities for item(s)',
                                  style: TextStyle(
                                    fontSize: 18.0, color: Color(0xFFE6B819),),)
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Aerosol Box"] ==
                                      true) _createForm("Aerosol Box"),
                                  if (widget.selected["Aerosol Box"] ==
                                      true) _quantityForm("Aerosol Box"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Body Suit"] ==
                                      true) _createForm("Body Suit"),
                                  if (widget.selected["Body Suit"] ==
                                      true) _quantityForm("Body Suit"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Face Shield"] ==
                                      true) _createForm("Face Shield"),
                                  if (widget.selected["Face Shield"] ==
                                      true) _quantityForm("Face Shield"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Gloves"] ==
                                      true) _createForm("Gloves"),
                                  if (widget.selected["Gloves"] ==
                                      true) _quantityForm("Gloves"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Goggles"] ==
                                      true) _createForm("Goggles"),
                                  if (widget.selected["Goggles"] ==
                                      true) _quantityForm("Goggles"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["N95 Regular"] ==
                                      true) _createForm("N95 Regular"),
                                  if (widget.selected["N95 Regular"] ==
                                      true) _quantityForm("N95 Regular"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["N95 Small"] ==
                                      true) _createForm("N95 Small"),
                                  if (widget.selected["N95 Small"] ==
                                      true) _quantityForm("N95 Small"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Sanitizer"] ==
                                      true) _createForm("Sanitizer"),
                                  if (widget.selected["Sanitizer"] ==
                                      true) _quantityForm("Sanitizer"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Surgical Mask"] ==
                                      true) _createForm("Surgical Mask"),
                                  if (widget.selected["Surgical Mask"] ==
                                      true) _quantityForm("Surgical Mask"),
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.selected["Wipes"] ==
                                      true) _createForm("Wipes"),
                                  if (widget.selected["Wipes"] ==
                                      true) _quantityForm("Wipes"),
                                ]
                            ),
                            RaisedButton(child: Text('Next'), onPressed: () {
                              if (_zeroQuantity) {
                                showSnackBar(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      InfoQuestionScreen(key: widget.key,
                                          selected: widget.selected,
                                          quantities: quantities)),
                                );
                              }
                            }
                            ),
                            RaisedButton(child: Text('Back'),
                                color: Color(0xFF313F84),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        OrderRequestPage(key: widget.key)),
                                  );
                                }
                            )
                          ],
                        ),
                      ])
                  )
                ]
              )
            ),
          );
        }
      )
    );
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Quantity cannot be zero for any item.'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  IntrinsicWidth _quantityForm(tag) {
    double c_width = MediaQuery.of(context).size.width;
    return IntrinsicWidth(
      child: Container(
        width: c_width * .35,
        height: 100,
        child: TextField(
          textAlign: TextAlign.center,
          scrollPadding: EdgeInsets.symmetric(horizontal: 16),
          maxLines: 1,
          autofocus: false,
          maxLength: 4,
          maxLengthEnforced: true,
          decoration: new InputDecoration(
            labelText: "Quantity",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (value) {
            _zeroQuantity = false;
            quantities[tag] = int.parse(value);
            quantities.forEach((k,v) => { if (widget.selected[k] == true && quantities[k] == 0) _zeroQuantity = true });
            setState(() {});
          }, // Only numbers can be entered
        ),
      ),
    );
  }

  Column _createForm(String tag) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(tag, style: Theme.of(context).textTheme.headline4,),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: 140.0,
              height: 140.0,
              color: Colors.white,
              child: _chooseImage(tag)
          ),
        ),
      ],
    );
  }

  Image _chooseImage(String tag) {
    if (tag == "Aerosol Box") {
      return Image.asset('assets/images/aerosol_box.png');
    } else if (tag == "Body Suit") {
      return Image.asset('assets/images/body_suit.jpg');
    } else if (tag == "Face Shield") {
      return Image.asset('assets/images/face_shield.jpeg');
    } else if (tag == "Gloves") {
      return Image.asset('assets/images/gloves.jpg');
    } else if (tag == "Goggles") {
      return Image.asset('assets/images/goggles.jpeg');
    } else if (tag == "N95 Regular") {
      return Image.asset('assets/images/n95_regular.jpg');
    } else if (tag == "N95 Small") {
      return Image.asset('assets/images/n95_small.jpeg');
    } else if (tag == "Sanitizer") {
      return Image.asset('assets/images/hand_sanitizer.jpeg');
    } else if (tag == "Surgical Mask") {
      return Image.asset('assets/images/surgical_mask.png');
    } else if (tag == "Wipes") {
      return Image.asset('assets/images/wipes.jpg');
    }
  }
}