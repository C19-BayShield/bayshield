import 'package:flutter/material.dart';
import 'package:supplyside/screens/quantity_screen.dart';

class InfoQuestionScreen extends StatefulWidget {
  InfoQuestionScreen({this.key, this.selected, this.quantities});

  final Key key;
  final Map<String, bool> selected;
  final Map<String, int> quantities;

  @override
  State<StatefulWidget> createState() => new _InfoQuestionScreenState();

}

class _InfoQuestionScreenState extends State<InfoQuestionScreen>{

  String q1Ans;
  String q2Ans;
  String q3Ans;
  String q4Ans;

  final List<String> ppeQChoices = ["All of staff","75% of staff", "50% of staff", "25% of staff", "Less than 25% of staff"];
  final List<String> hasCasesQChoices = ["Yes, Less than 100","Yes, 100-500","Yes, Greater than 500","No"];
  final List<String> urgQChoices = ["As Soon As Possible", "Very Urgently", "Extremely Urgently"];
  final List<String> sizeQChoices = ["Less than 500","500-1,000","1,000-5,000", "5,000-10,000", "10,0000+"];

  Widget  _buildGenericDropDown({List<String> options, String value, Function(String) onChange, String hintText="Select Option"}) {
    return DropdownButton<String>(
      value: value,
      icon: Icon(Icons.arrow_downward),
      hint: Text(hintText),
      iconSize: 24,
      elevation: 16,
      isExpanded: false,
      style: TextStyle(
          color: Color(0xFFE6B819)
      ),
      underline: Container(
        height: 2,
        color: Color(0xFFD58032),
      ),
      onChanged: onChange,
      items:
      options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Request Parts Form', style: Theme.of(context).textTheme.headline2,),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('How much of your staff currently has protective equipment?'),
                        ),
                      ),
                      this._buildGenericDropDown(
                        options:ppeQChoices,
                        onChange:(String newValue) => setState((){q1Ans = newValue;}),
                        value: q1Ans,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('Does your facility have any reportes of highly infecious diseases, if so how many?'),
                        ),
                      ),
                      this._buildGenericDropDown(
                        options:hasCasesQChoices,
                        onChange:(String newValue) => setState((){q2Ans = newValue;}),
                        value: q2Ans,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('How soon do you require your protective equipment?'),
                        ),
                      ),
                      this._buildGenericDropDown(
                        options:urgQChoices,
                        onChange:(String newValue) => setState((){q3Ans = newValue;}),
                        value: q3Ans,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('How many patients of all types does your facility process each day?'),
                        ),
                      ),
                      this._buildGenericDropDown(
                        options:sizeQChoices,
                        onChange:(String newValue) => setState((){q4Ans = newValue;}),
                        value: q4Ans,
                      ),
                      RaisedButton(child: Text('Submit Request'), onPressed: () => null,),
                      RaisedButton(child: Text('Back'), color: Color(0xFF313F84), onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                          QuantityScreen(key: widget.key, selected: widget.selected)),
                        );
                      })
                  ],
                )]
                )
              ),
            ]
          )
        )
      ),
    );
  }
}