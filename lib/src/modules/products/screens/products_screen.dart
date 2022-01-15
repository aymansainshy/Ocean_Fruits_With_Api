import 'package:ocean_fruits/src/modules/categories/models/category_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/shared_product_item.dart';
import '../provider/products_provider.dart';
import '../../lang/provider/language_provider.dart';
import '../../cart/widgets/build_cart_stack.dart';
import '../../cart/provider/cart_provider.dart';
import '../../cart/screens/cart_screen.dart';
import '../../../core/utils/app_constant.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = 'fruits_screen';
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  final Category cat;

  const ProductsScreen({
    Key key,
    this.cat,
    this.tapScaffoldKey,
  }) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    // final cart = Provider.of<Carts>(context);

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
        actions: [
          Padding(
            padding: language == "ar"
                ? const EdgeInsets.only(left: 10)
                : const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Consumer<Carts>(
                  builder: (context, cart, child) =>
                      BuildCartStack(carts: cart)),
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
          language == "ar" ? widget.cat.arName : widget.cat.enName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false)
            .fetchCategoryProducts(widget.cat.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: sleekCircularSlider(context, screenUtil.setSp(100),
                  AppColors.greenColor, AppColors.scondryColor),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: screenUtil.setHeight(500),
                width: screenUtil.setWidth(700),
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    translate('anErrorOccurred', context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: _isLandScape
                          ? screenUtil.setSp(30)
                          : screenUtil.setSp(40),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      wordSpacing: 1,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Consumer<Products>(
              builder: (context, products, _) {
                return products.categoryProdocts.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          height: screenUtil.setHeight(500),
                          width: screenUtil.setWidth(700),
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              translate('sorryWeDontHave', context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: _isLandScape
                                    ? screenUtil.setSp(30)
                                    : screenUtil.setSp(40),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _isLandScape ? 5 : 15),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: _isLandScape ? 1 : 5,
                            mainAxisSpacing: _isLandScape ? 1 : 5,
                          ),
                          itemCount: products.categoryProdocts.length,
                          itemBuilder: (context, index) =>
                              ChangeNotifierProvider.value(
                            value: products.categoryProdocts[index],
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 5,
                                right: 5,
                              ),
                              child: const SharedProductItem(),
                            ),
                          ),
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}
