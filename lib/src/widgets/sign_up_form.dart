import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/build_form_field.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';

class SignUpForm extends StatefulWidget {
  final bool isLandScape;
  final ScreenUtil screenUtil;
  final bool isLogin;

  SignUpForm(
    this.isLogin,
    this.isLandScape,
    this.screenUtil,
  );
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationController2;
  Animation<double> _opacity;
  Animation<Offset> _slidAnimation;
  Animation<Offset> _slidAnimation2;

  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var isVisible = false;
  var isPasswordHide = true;
  var isLoading = false;

  var signUpData = {
    'name': '',
    'address': '',
    'email': '',
    'password': '',
    'phoneNumber': '',
  };

  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'SD';
  PhoneNumber number = PhoneNumber(isoCode: 'SD');

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
        curve: Curves.easeIn,
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

  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'SD');

  //   setState(() {
  //     this.number = number;
  //   });
  // }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _animationController.dispose();
    _animationController2.dispose();
    _phoneNumberController?.dispose();
    super.dispose();
  }

  // void _showArrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text("an error accured"),
  //       content: Text(message),
  //       actions: [
  //         FlatButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Ok"))
  //       ],
  //     ),
  //   );
  // }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    print('user name : ' + signUpData['name']);
    print('user address : ' + signUpData['address']);
    print('user phoneNumber : ' + signUpData['phoneNumber']);
    print('user email : ' + signUpData['email']);
    print('user password : ' + signUpData['password']);

    // _formKey.currentState.reset();
  }

  RegExp _isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    _animationController2.forward();

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SlideTransition(
              position: _slidAnimation2,
              child: BuilFormField(
                fieldName: translate("fullName", context),
                contentPadding: 8.0,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // prefixIcon: Icon(Icons.person_outline),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return translate("pleaseEnterYourName", context);
                  }
                  return null;
                },
                onSaved: (value) {
                  signUpData['name'] = value;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation,
              child: BuilFormField(
                fieldName: translate("address", context),
                contentPadding: 8.0,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // prefixIcon: Icon(Icons.location_on),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return translate("enterYourFullAddress", context);
                  }
                  return null;
                },
                onSaved: (value) {
                  signUpData['address'] = value;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation2,
              child: BuilFormField(
                fieldName: translate("email", context),
                contentPadding: 8.0,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                // prefixIcon: Icon(Icons.mail_outline),
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
                  signUpData['email'] = value;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation,
              child: BuilFormField(
                fieldName: translate("password", context),
                contentPadding: 8.0,
                obscureText: isPasswordHide,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                // prefixIcon: Icon(Icons.lock_outline),
                focusNode: _passwordFocusNode,
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
                  FocusScope.of(context)
                      .requestFocus(_confirmPasswordFocusNode);
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
                  signUpData['password'] = value;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation2,
              child: BuilFormField(
                fieldName: translate("confirmPassword", context),
                contentPadding: 8.0,
                obscureText: isPasswordHide,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                // prefixIcon: Icon(Icons.lock_outline),
                focusNode: _confirmPasswordFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneFocusNode);
                },
                validator: (value) {
                  if (value != _passwordController.text) {
                    return translate("passwordDontMatch", context);
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(50),
            ),
            SlideTransition(
              position: _slidAnimation,
              child: InternationalPhoneNumberInput(
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                focusNode: _phoneFocusNode,
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.grey.shade700),
                initialValue: number,
                textFieldController: _phoneNumberController,
                formatInput: false,
                inputDecoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.all(8.0),
                  hintText: translate("phone", context),
                  fillColor: AppColors.primaryColor,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 0.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return translate("enterYourPhoneNumber", context);
                  }

                  if (value.toString().length < 10) {
                    return translate("PhoneNumberValid", context);
                  }

                  // if (!value.toString().startsWith('+') &&
                  //     !value.toString().startsWith('0')) {
                  //   return translate("validPhone", context);
                  // }

                  return null;
                },
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                onSaved: (value) {
                  signUpData['phoneNumber'] = number.phoneNumber;
                  print("Valuuuuuuuueeeeee... " + value.toString());
                },
              ),
            ),
            SizedBox(
              height: widget.screenUtil.setHeight(60),
            ),
            FadeTransition(
              opacity: _opacity,
              child: Container(
                width: double.infinity,
                height: widget.isLandScape
                    ? widget.screenUtil.setHeight(220)
                    : widget.screenUtil.setHeight(130),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    translate("register", context),
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
