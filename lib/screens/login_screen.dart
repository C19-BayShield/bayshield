import 'package:flutter/material.dart';
import 'package:supplyside/util/authentication.dart';
import 'package:supplyside/screens/user_type_screen.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/datamodels/user.dart';
import 'package:supplyside/locator.dart';
import 'package:supplyside/widgets.dart';

class LoginSignupScreen extends StatefulWidget {
  LoginSignupScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupScreenState();
}


class _LoginSignupScreenState extends State<LoginSignupScreen>{
  final _formKey = new GlobalKey<FormState>();
  final FirestoreUsers _firestoreUsers = locator<FirestoreUsers>();

  String _email;
  String _password;
  String _name;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Go to user type screen when succesfully signed up
  Future navigateToUserType(context, String userId) async {
    if (userId.length > 0 && userId != null) {
      widget.loginCallback();
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserTypeScreen(userId: userId,
      auth: widget.auth,
      )
      ))
    ;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
          setState(() {
            _isLoading = false;
          });
        } else {
          // Sign up process
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
          setState(() {
            _isLoading = false;
          });
          await widget.auth.signIn(_email, _password);
          await _firestoreUsers.createUser(User(id: userId, email: _email, type: "",));
          await _firestoreUsers.setUserName(userId, _name);
          navigateToUserType(context, userId);
        }
        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
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


  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

 @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "BAYSHIELD",
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            ),
                          new SizedBox(height: 30),
                          _showForm(),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              _showCircularProgress(),
            ],
          ),
      );
    }

  Widget _showForm() {
  return new Container(
      padding: new EdgeInsets.only(left: 22.0, right: 22.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showNameImput(),
            showEmailInput(),
            showPasswordInput(),
            new SizedBox(height: 32),
            new PrimaryButton(  
              submit: validateAndSubmit, 
              label: _isLoginForm ? 'Sign In' : 'Sign Up'
            ),
            new SecondaryButton(  
              submit: toggleFormMode,
              label: _isLoginForm ? 'or Sign Up' : 'Already a member? Sign in now',
            ),
            showErrorMessage(),
          ],
        ),
      ));
}

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showNameImput() {
    if (!_isLoginForm) {
      return new BayShieldFormField(
        hint: 'Full Name',
        icon: Icons.account_circle,
        validator: (value) => value.isEmpty ? 'Full Name can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      );
    } else {
      return new Container(width: 0.0, height: 0.0);
    }
    
  }

  Widget showEmailInput() {
    return new BayShieldFormField(
      hint: 'Email',
      icon: Icons.email,
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value.trim(),
    );
  }

  Widget showPasswordInput() {
    return new BayShieldFormField(
      obscureText: true,
      hint: 'Password',
      icon: Icons.lock,
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value.trim(),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}