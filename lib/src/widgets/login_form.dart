import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/build_form_field.dart';
import '../providers/auth_provider.dart';
import '../models/http_exception.dart';
import '../screens/tap_screen.dart';
import '../utils/app_constant.dart';

class LoginForm extends StatefulWidget {
  final bool isSignUp;
  final bool isLandScape;
  final ScreenUtil screenUtil;

  LoginForm(
    this.isSignUp,
    this.isLandScape,
    this.screenUtil,
  );
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationController2;
  Animation<double> _opacity;
  Animation<Offset> _slidAnimation;
  Animation<Offset> _slidAnimation2;
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  var isVisible = false;
  var isPasswordHide = true;
  var isLoading = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController2,
        curve: Curves.ease,
      ),
    );
    _slidAnimation = Tween<Offset>(
      begin: Offset(-5, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
    _slidAnimation2 = Tween<Offset>(
      begin: Offset(5, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
    super.initState();
  }

  var logInData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  void _showArrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error accured "),
        content: Text(message),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"))
        ],
      ),
    );
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    print(logInData['email']);
    print(logInData['password']);
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        logInData['email'],
        logInData['password'],
      );
      setState(() {
        isLoading = false;
      });
      if (widget.isSignUp) {
        Navigator.of(context).pushReplacementNamed('/');
      }
      //  else {
      //   Navigator.of(context).pop();
      //   Navigator.of(context).pop();
      //   Navigator.of(context).pushReplacementNamed('/');
      // }
    } on HttpException catch (e) {
      var errorMessage = translate("anErrorPleaseTryLater", context);
      if (e.toString() == '0') {
        errorMessage = translate("thisPasswordInCorrect", context);
      } else if (e.toString() == '1') {
        errorMessage = translate("thisEmailInCorrect", context);
      }
      _showArrorDialog(errorMessage);
    } catch (e) {
      final errorMessage = translate("anErrorPleaseTryLater", context);
      _showArrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
    // _formKey.currentState.reset();
  }

  RegExp _isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    _animationController2.forward();
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SlideTransition(
              position: _slidAnimation2,
              child: BuilFormField(
                fieldName: translate("email", context),
                // prefixIcon: Icon(Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                contentPadding: 8.0,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return translate("pleaseEnterYourEmail", context);
                  }
                  if (!_isEmailValid.hasMatch(value)) {
                    return translate("enterYourValidEmail2", context);
                  }
                  return null;
                },
                onSaved: (value) {
                  logInData['email'] = value;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation,
              child: BuilFormField(
                contentPadding: 8.0,
                fieldName: translate("password", context),
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordHide,
                textInputAction: TextInputAction.done,
                focusNode: _passwordFocusNode,
                // prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                      isPasswordHide = !isPasswordHide;
                    });
                  },
                ),
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return translate("enterPassword", context);
                  }
                  if (value.toString().length < 6) {
                    return translate("passwordValidation", context);
                  }
                  return null;
                },
                onSaved: (value) {
                  logInData['password'] = value;
                },
              ),
            ),
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(translate("email", context)),
                    content: BuilFormField(
                      fieldName: translate("email", context),
                      // prefixIcon: Icon(Icons.mail_outline),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      contentPadding: 8.0,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return translate("pleaseEnterYourEmail", context);
                        }
                        if (!_isEmailValid.hasMatch(value.trim())) {
                          return translate("enterYourValidEmail2", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        logInData['email'] = value;
                      },
                    ),
                    actions: [
                      InkWell(
                        child: Text(translate("sentPassword", context)),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                "${translate("forget_password", context)} ",
                style: TextStyle(
                  fontSize: widget.isLandScape
                      ? widget.screenUtil.setSp(25)
                      : widget.screenUtil.setSp(35),
                  color: AppColors.primaryColor,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(80),
            ),
            FadeTransition(
              opacity: _opacity,
              child: Container(
                width: double.infinity,
                height: widget.isLandScape
                    ? widget.screenUtil.setHeight(230)
                    : widget.screenUtil.setHeight(130),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: AppColors.greenColor,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          translate("login", context),
                          style: TextStyle(
                            fontSize: widget.isLandScape
                                ? widget.screenUtil.setSp(25)
                                : widget.screenUtil.setSp(45),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  onPressed: () {
                    _saveForm();
                    // Navigator.of(context).pushNamed(TapScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
