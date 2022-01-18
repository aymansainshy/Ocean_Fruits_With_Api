import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../lang/provider/language_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/build_form_field.dart';
import '../provider/auth_provider.dart';
import '../../../core/errors/http_exception.dart';
import '../../main-view/screens/tap_screen.dart';
import '../../../core/utils/app_constant.dart';

class LoginForm extends StatefulWidget {
  final bool isSignUp;
  final bool isLandScape;
  final ScreenUtil screenUtil;

  const LoginForm(
    this.isSignUp,
    this.isLandScape,
    this.screenUtil, {
    Key key,
  }) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  var isVisible = false;
  var isPasswordHide = true;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  var logInData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _showArrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate("anErrorPleaseTryLater", context)),
        content: Text(message),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate("ok", context)))
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
      Navigator.of(context).pushReplacementNamed(TapScreen.routeName);
      // if (widget.isSignUp) {
      //   Navigator.of(context).pushReplacementNamed('/');
      // }
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

  final RegExp _isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            BuilFormField(
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
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            BuilFormField(
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
            SizedBox(
              height: widget.screenUtil.setHeight(80),
            ),
            SizedBox(
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
                        child: sleekCircularSlider(
                            context,
                            widget.screenUtil.setSp(80),
                            AppColors.greenColor,
                            AppColors.scondryColor),
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
            const SizedBox(height: 20),
            Padding(
              padding: language == "ar"
                  ? const EdgeInsets.only(left: 10)
                  : const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(TapScreen.routeName),
                child: Text(
                  translate("skip", context),
                  style: const TextStyle(
                    color: AppColors.scondryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
