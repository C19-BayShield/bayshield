import 'package:flutter/material.dart';

class BayShieldAppBar extends StatelessWidget {
  final String title;
  BayShieldAppBar({Key key, @required this.title}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        title: new Text(title),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
    ); 
  }
}

class FullScreenCover extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
     return Container(
      height: screenSize.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_bg.png'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  // This widget is the root of your application.
  final VoidCallback submit;
  final String label;
  PrimaryButton({Key key, @required this.submit, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: new FlatButton(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        textColor: Colors.black,
        color: Color(0xFFD48032),
        child: new Text(label,
            style: new TextStyle(fontSize: 24.0),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        onPressed: submit,
      )
    );
  }
}


class SecondaryButton extends StatelessWidget {
  // This widget is the root of your application.
  final VoidCallback submit;
  final String label;
  SecondaryButton({Key key, @required this.submit, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     return Container(
      child: new FlatButton(
        textColor: Colors.white,
        child: new Text(label,
            style: new TextStyle(fontSize: 18.0, decoration: TextDecoration.underline),
        ),
        onPressed: submit,
      )
    );
  }
}

class BayShieldFormField extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final String hint;
  final IconData icon;
  final bool obscureText;
  BayShieldFormField({Key key, this.obscureText, @required this.validator, this.onSaved, this.hint, this.icon}) : super(key: key);

  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: new TextFormField(
        style: new TextStyle(
              color: Colors.white,
        ),
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: this.obscureText ?? false,
        decoration: new InputDecoration(
            hintText: hint,
            hintStyle:  new TextStyle(
              color: Colors.grey,
            ),
            icon: new Icon(
              icon,
              color: Colors.white,
            ),
            enabledBorder: UnderlineInputBorder(      
              borderSide: BorderSide(color: Colors.grey),   
              ),  
          ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
      
}