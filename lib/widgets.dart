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
          image: AssetImage('assets/images/landingcover.jpg'),
          fit: BoxFit.cover,
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
     return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 30.0,
          child: new FlatButton(
            child: new Text(label,
                style: new TextStyle(fontSize: 20.0, color: Color(0xFFF4BA5B))),
            onPressed: submit,
          ),
        ));
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
              color: Colors.black,
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
              color: Colors.grey[700],
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