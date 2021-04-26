import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_alert_not_autherazed.dart';
import '../widgets/custom_alert_order.dart';
import '../providers/products_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/build_form_field.dart';
import '../providers/cart_provider.dart';
import '../lang/language_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/order_screen.dart';
import '../utils/app_constant.dart';

class CheckOutScreen extends StatefulWidget {
  static const routeName = '/check_out_screen';

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<ScaffoldState> _checkScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _phoneFocusNode = FocusNode();
  var userInfo = {
    'adderss': '',
    'phoneNumber': '',
  };
  AuthProvider userData;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    userData = Provider.of<AuthProvider>(context, listen: false);
    userInfo['phone'] = userData.userPhone;
    userInfo['address'] = userData.userAddress;
  }

  int _selectedDeliveryDate;
  int _selectedDeliveryTime;
  bool noDateDeliverySelected = false;
  bool noTimeDeliverySelected = false;

  final ScrollController _scrollController = ScrollController();

  // void _jumpTo(BuildContext context) {
  //   _scrollController.addListener(() {
  //     if (!_scrollController.position.atEdge) {
  //       if (_scrollController.position.pixels != 0) {
  //         _scrollController.jumpTo(
  //           _scrollController.position.maxScrollExtent,
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final DateTime _dateTimeNow = DateTime.now();
    final DateTime _today =
        DateTime(_dateTimeNow.year, _dateTimeNow.month, _dateTimeNow.day);
    final DateTime _tomorrow =
        DateTime(_dateTimeNow.year, _dateTimeNow.month, _dateTimeNow.day + 1);
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final cart = Provider.of<Carts>(context, listen: false);
    var mediaQuery = MediaQuery.of(context).size;

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    final productProvider = Provider.of<Products>(context, listen: false);

    return Scaffold(
      key: _checkScaffoldKey,
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
            offset: Offset(6, 0),
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () => Navigator.of(context).pop(),
              icon: Container(
                // color: Colors.teal,
                height: 30,
                width: 50,
                child: language == "ar"
                    ? Image.asset(
                        "assets/icons/arrow_back2.png",
                        fit: BoxFit.contain,
                        color: Colors.white,
                      )
                    : Image.asset(
                        "assets/icons/arrow_back.png",
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
        title: Text(
          translate("checkout", context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: double.infinity,
          height: isLandScape
              ? screenUtil.setHeight(240)
              : screenUtil.setHeight(140),
          child: RaisedButton(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            onPressed: () async {
              final isValid = _formKey.currentState.validate();
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
              if (!isValid) {
                return;
              }

              _formKey.currentState.save();

              if (!userData.isAuth) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertNotAutherazed(
                    color: Colors.yellow[800],
                    topText: translate("notAuthorized", context),
                    bottomText: translate("please", context),
                    iconData: Icons.priority_high,
                  ),
                );

                return;
              }
              if (_selectedDeliveryDate == null) {
                setState(() {
                  noDateDeliverySelected = true;
                });
                return;
              }
              if (_selectedDeliveryTime == null) {
                setState(() {
                  noTimeDeliverySelected = true;
                });
                return;
              }
              setState(() {
                isLoading = true;
              });
              try {
                print("Delivery Date  " + _selectedDeliveryDate.toString());
                print(
                    "Delivery Time  " + (_selectedDeliveryTime + 1).toString());
                print("Delivery Fee  " + productProvider.delveryFee.toString());

                await Provider.of<Orders>(context, listen: false).addOrder(
                  userId: userData.userId,
                  userName: userData.userName,
                  deliveryFee: productProvider.delveryFee.toString(),
                  dileveryDate: _selectedDeliveryDate.toString(),
                  dileveryTime: (_selectedDeliveryTime + 1).toString(),
                  address: userInfo['address'],
                  phoneNumber: userInfo['phone'],
                  paymentMethod: "0",
                  cartProducts: cart.items.values.toList(),
                );

                Provider.of<Carts>(context, listen: false).clear();

                setState(() {
                  isLoading = false;
                });

                showDialog(
                  context: context,
                  builder: (context) => CustomAlertOrder(
                    topText: translate("yorOrderDone", context),
                    bottomText: translate("thanksUsingApp", context),
                    color: Colors.green,
                    iconData: Icons.check,
                    function: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(OrderScreen.routeName);
                    },
                  ),
                );
              } catch (e) {
                setState(() {
                  isLoading = false;
                });
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertOrder(
                    topText: translate("yourOrderFailed", context),
                    bottomText: translate("checkYourInternet", context),
                    color: Colors.redAccent,
                    iconData: Icons.clear,
                    function: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    },
                  ),
                );
              }
            },

            color: AppColors.scondryColor,
            textColor: Colors.white,
            child: isLoading
                ? Center(
                    child: sleekCircularSlider(context, screenUtil.setSp(80),
                        AppColors.primaryColor, AppColors.primaryColor),
                  )
                : Text(
                    translate("placeOrder", context),
                    style: TextStyle(
                      fontSize: isLandScape
                          ? screenUtil.setSp(30)
                          : screenUtil.setSp(45),
                    ),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate("orderDetails", context),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  fontSize:
                      isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(45),
                ),
              ),
              SizedBox(height: 5),
              Card(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        // color: Colors.red,
                        height: isLandScape
                            ? screenUtil.setHeight(150 * cart.items.length)
                            : screenUtil.setHeight(60 * cart.items.length),
                        child: ListView.builder(
                          itemCount: cart.itemCount,
                          itemBuilder: (context, i) => _buildRow(
                            isLandScape,
                            screenUtil,
                            context,
                            cart.items.values.toList()[i].productTitle,
                            cart.items.values
                                .toList()[i]
                                .productPrice
                                .toString(),
                            cart.items.values.toList()[i].quantity.toString(),
                            cart.items.values.toList()[i].unitTitle,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black45,
                      ),
                      _buildRow2(
                        isLandScape,
                        screenUtil,
                        context,
                        translate("delliveryFee", context),
                        67,
                        40,
                        Colors.grey.shade700,
                      ),
                      _buildRow2(
                        isLandScape,
                        screenUtil,
                        context,
                        translate("discount", context),
                        cart.totalDiscount,
                        45,
                        Colors.grey.shade700,
                      ),
                      _buildRow2(
                        isLandScape,
                        screenUtil,
                        context,
                        translate("totalPrice", context),
                        cart.totalAmount,
                        50,
                        Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: screenUtil.setHeight(35),
              ),

              Text(
                translate("deliverTo", context),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize:
                      isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(45),
                ),
              ),
              SizedBox(height: 5),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    BuilFormField(
                      fieldName: translate('address', context),
                      contentPadding: 8.0,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(Icons.location_on),
                      initialValue: userInfo['address'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return translate("enterYourFullAddress", context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userInfo['address'] = value;
                      },
                    ),
                    SizedBox(
                      height: screenUtil.setHeight(20),
                    ),
                    BuilFormField(
                      fieldName: translate('phone', context),
                      focusNode: _phoneFocusNode,
                      contentPadding: 8.0,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icon(Icons.phone),
                      initialValue: userInfo['phone'],
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
                        userInfo['phoneNumber'] = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenUtil.setHeight(35),
              ),
              /////////////////
              Text(
                translate("deliveryDate", context),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize:
                      isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(45),
                ),
              ),
              Row(
                children: [
                  _buildDelivryDateContainer(
                      mediaQuery / 3, translate("Today", context), 0, _today),
                  _buildDelivryDateContainer(mediaQuery / 3,
                      translate("Tomorrow", context), 1, _tomorrow),
                ],
              ),
              if (noDateDeliverySelected)
                Text(
                  translate("pleasSelcetDate", context),
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: screenUtil.setHeight(35),
              ),
              Text(
                translate("deliveryTime", context),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize:
                      isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(45),
                ),
              ),
              Container(
                height: 70,
                width: mediaQuery.width,
                // color: Colors.green,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.dileveryTime.length,
                  itemBuilder: (context, i) {
                    return _buildDelivryTimeContainer(
                      mediaQuery / 3.5,
                      productProvider.dileveryTime[i].startTime,
                      productProvider.dileveryTime[i].endTime,
                      i,
                    );
                  },
                ),
              ),
              if (noTimeDeliverySelected)
                Text(
                  translate("pleasSelcetTime", context),
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(
                height: screenUtil.setHeight(35),
              ),
              Text(
                translate("paymentMethod", context),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize:
                      isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(45),
                ),
              ),
              SizedBox(height: 5),
              Card(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      onChanged: (value) {
                        // setState(() {
                        //   pymentMethod = value;
                        // });
                        // print(value);
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text(translate("cashOnDelivery", context)),
                          // value: 0,
                        ),
                        // DropdownMenuItem(
                        //   child: Text("Visa Card"),
                        //   value: 1,
                        // ),
                        // DropdownMenuItem(
                        //   child: Text("Credit Card"),
                        //   value: 2,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDelivryDateContainer(
    Size mediaQuery,
    String text,
    int index,
    DateTime date,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryDate = index;
          noDateDeliverySelected = false;
        });
      },
      child: Container(
        height: 70,
        width: mediaQuery.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: index == _selectedDeliveryDate
            ? Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.scondryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${date.year}/${date.month}/${date.day}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${date.year}/${date.month}/${date.day}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDelivryTimeContainer(
    Size mediaQuery,
    String startTime,
    String endTime,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryTime = index;
          noTimeDeliverySelected = false;
        });
      },
      child: Container(
        height: 90,
        width: mediaQuery.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: index == _selectedDeliveryTime
            ? Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.scondryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          startTime,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          translate("To", context),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          endTime,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          startTime,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          translate("To", context),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          endTime,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildRow(
      bool isLandScape,
      ScreenUtil screenUtil,
      BuildContext context,
      String text,
      String price,
      String quantity,
      String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize:
                  isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(40),
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "$quantity  $unit",
            style: TextStyle(
              fontSize:
                  isLandScape ? screenUtil.setSp(23) : screenUtil.setSp(35),
              color: Colors.black,
            ),
          ),
        ),
        // SizedBox(width: 5),
        // Text(
        //   unit,
        //   style: TextStyle(
        //     fontSize: isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(40),
        //     color: Colors.black,
        //   ),
        // ),
        SizedBox(width: screenUtil.setWidth(80)),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: double.parse(price).toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isLandScape
                        ? screenUtil.setSp(28)
                        : screenUtil.setSp(35),
                    color: AppColors.scondryColor,
                  ),
                ),
                TextSpan(
                  text: translate("SDG", context),
                  style: TextStyle(
                    // fontFamily: "Cairo",
                    color: Colors.red,
                    fontSize: isLandScape
                        ? screenUtil.setSp(20)
                        : screenUtil.setSp(25),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Row _buildRow2(bool isLandScape, ScreenUtil screenUtil, BuildContext context,
    String text, double amount, int size, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: isLandScape ? screenUtil.setSp(35) : screenUtil.setSp(size),
          color: color,
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: amount.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isLandScape ? screenUtil.setSp(35) : screenUtil.setSp(size),
                color: AppColors.scondryColor,
              ),
            ),
            TextSpan(
              text: translate("SDG", context),
              style: TextStyle(
                // fontFamily: "Cairo",
                color: Colors.red,
                fontSize:
                    isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(30),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
