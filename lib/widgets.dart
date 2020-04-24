import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/datamodels/order.dart';

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

class ItemDisplay extends StatelessWidget {
  final Item item;
  final Function(int) onPressed;
  final List<bool> isSelected;
  ItemDisplay({Key key, @required this.item, this.onPressed, this.isSelected}) : super(key: key);

  Widget build(BuildContext context) {
     return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            item.name, style: Theme
              .of(context)
              .textTheme
              .headline4,),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: ToggleButtons(
            children: <Widget>[
              Container(
                width: 140.0,
                height: 140.0,
                color: Colors.white,
                child: Image.asset(
                    item.imageUrl),
              ),
            ],
            selectedBorderColor: Color(
                0xFFE6B819),
            borderColor: Color(0xFF313F84),
            borderWidth: 8.0,
            onPressed: onPressed,
            isSelected: isSelected,
          ),
        ),
      ],
    );
  }
}

class OrderDisplay extends StatelessWidget {
  final TextStyle orderStyle = TextStyle(fontSize: 16.0,letterSpacing: .5, color: Color(0xFF263151));
  final TextStyle orderSubtitleStyle = TextStyle(fontSize: 14.0,letterSpacing: .5, color: Color(0xFFA5A9B4));
  final SupplyRequest req;
  OrderDisplay({Key key, @required this.req}) : super(key: key);

  String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
    ? myString
    : '${myString.substring(0, cutoff)}...';
}

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
        Container(
          width: c_width * .8,
          color: Color(0xFF313F84),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    req.item.imageUrl,
                    width: 64, 
                    height: 64,
                    fit: BoxFit.fill
                  ),
                ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(mainAxisSize: MainAxisSize.min,children: <Widget>[Text(req.item.name, style: Theme.of(context).textTheme.headline3,), SizedBox(width: 16),],),
                    Text('${req.amtOrdered.toString()} Ordered', style: Theme.of(context).textTheme.subtitle2 ),
                    Text('${req.statusToString()}', style: Theme.of(context).textTheme.subtitle2)
                  ],
                )
              ],
            ),
          ),
        Container(
          color: Color(0xFFFFFFFF),
          width: c_width * .85,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Order ${truncateWithEllipsis(7, req.requestNo)}', style: this.orderStyle,),
                Text('Order Date - 06 May 2020', style: this.orderSubtitleStyle)
              ],
            )
          ),
        )
        ]
      );
  }
}