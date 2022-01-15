import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '/src/core/utils/app_constant.dart';
import '../../lang/provider/language_provider.dart';

// enum ImageType {
//   GALLERY,
//   CAMERA,
// }

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-screen';

  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var isVisible = false;
  var isPasswordHide = true;
  var isLoading = false;
  AuthProvider _userData;
  // String _userImage;

  void _showArrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate("errorOccurred", context)),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              translate("ok", context),
            ),
          ),
        ],
      ),
    );
  }

  final _editedData = {
    'name': '',
    'address': '',
    'email': '',
    'password': '',
    'phoneNumber': '',
  };

  @override
  void initState() {
    _userData = Provider.of<AuthProvider>(context, listen: false);
    _editedData['name'] = _userData.userName;
    _editedData['email'] = _userData.userEmail;
    _editedData['address'] = _userData.userAddress;
    _editedData['password'] = _userData.password;
    _editedData['phoneNumber'] = _userData.userPhone;
    // _userImage = _userData.imageUrl;

    super.initState();
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).updataUser(
        userId: _userData.userId,
        userName: _editedData['name'],
        userEmail: _editedData['email'],
        userPassword: _editedData['password'],
        userAddress: _editedData['address'],
        userPhone: _editedData['phoneNumber'],
        // image: _storedImage,
      );
      // if (_storedImage != null) {
      //   await Provider.of<AuthProvider>(context, listen: false).uploadImage(
      //     _storedImage,
      //     _userData.userId,
      //   );
      // }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      if (e.toString() == '12') {
        _showArrorDialog("Image is too larg");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      var errorMessage = translate("anErrorPleaseTryLater", context);
      if (e.toString() == '12') {
        errorMessage = translate("imagIsTooLarg", context);
      }
      _showArrorDialog(errorMessage);
      setState(() {
        isLoading = false;
      });
    }

    // _formKey.currentState.reset();
  }

  // File _storedImage;
  // final _picker = ImagePicker();
  // Future _picImage() async {
  //   final pickedFile = await _picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _storedImage = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  final RegExp _isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();

    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        // backgroundColor: Color.fromARGB(0, 0, 0, 1),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => Transform.translate(
            offset: const Offset(6, 0),
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () => Navigator.of(context).pop(),
              icon: SizedBox(
                // color: Colors.teal,
                height: 30,
                width: 50,
                child: language == "ar"
                    ? Image.asset(
                        AssetsUtils.arrowBackIcon,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      )
                    : Image.asset(
                        AssetsUtils.arrowBackIcon2,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
        title: Text(
          translate("editProfile", context),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: AppColors.primaryColor,
        icon: Text(
          translate("save", context),
          style: TextStyle(
            fontSize: isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(35),
          ),
        ),
        label: isLoading
            ? Center(
                child: sleekCircularSlider(context, screenUtil.setSp(80),
                    AppColors.greenColor, AppColors.scondryColor),
              )
            : Icon(
                Icons.check,
                size: isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(40),
              ),
        onPressed: isLoading ? null : _saveForm,
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        isExtended: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 80),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        labelText: translate('userName', context),
                      ),
                      cursorColor: Colors.grey.shade300,
                      initialValue: _userData.userName,
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterYourFullName", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedData['name'] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        labelText: translate('address', context),
                      ),
                      cursorColor: Colors.grey.shade300,
                      initialValue: _userData.userAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterYourFullAddress", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedData['address'] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        labelText: translate('email', context),
                      ),
                      cursorColor: Colors.grey.shade300,
                      initialValue: _userData.userEmail,
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterYourValidEmail", context);
                        }
                        if (!_isEmailValid.hasMatch(value)) {
                          return translate("enterYourValidEmail2", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedData['email'] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: isPasswordHide,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        labelText: translate('password', context),
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
                      ),
                      cursorColor: Colors.grey.shade300,
                      initialValue: _userData.password,
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterPassword", context);
                        }
                        if (value.toString().length < 6) {
                          return translate("enterValidPassword", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedData['password'] = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(4),
                        labelText: translate('phone', context),
                      ),
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.grey.shade300,
                      initialValue: _userData.userPhone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterYourPhoneNumber", context);
                        }

                        if (value.toString().length < 8) {
                          return translate("PhoneNumberValid", context);
                        }

                        if (!value.toString().startsWith('+') &&
                            !value.toString().startsWith('0')) {
                          return translate("validPhone", context);
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedData['phoneNumber'] = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
