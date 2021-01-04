import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../widgets/shared_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/build_cart_stack.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';

class VegetableScreen extends StatefulWidget {
  static const routeName = 'vegetable_screen';
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  const VegetableScreen({
    Key key,
    this.tapScaffoldKey,
  }) : super(key: key);

  @override
  _VegetableScreenState createState() => _VegetableScreenState();
}

class _VegetableScreenState extends State<VegetableScreen> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    var _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    final cart = Provider.of<Carts>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        automaticallyImplyLeading: false,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        // backgroundColor: Color.fromARGB(0, 0, 0, 1),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: language == "ar"
                ? EdgeInsets.only(left: 10)
                : EdgeInsets.only(right: 10),
            child: IconButton(
              icon: BuildCartStack(carts: cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartScreen(isTap: true),
                ));
              },
            ),
          ),
        ],
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
          translate("vegetabel", context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _isLandScape ? 5 : 15),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: _isLandScape ? 1 : 5,
            mainAxisSpacing: _isLandScape ? 1 : 5,
          ),
          itemCount: products.vegetableProduct.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: products.vegetableProduct[index],
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: SharedProductItem(),
            ),
          ),
        ),
      ),
    );
  }
}
