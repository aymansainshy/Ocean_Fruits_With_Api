// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/drawer.dart';
import '../../../core/utils/app_constant.dart';
import '../../cart/screens/cart_screen.dart';
import '../../lang/provider/language_provider.dart';
import '../../products/screens/products_screen.dart';
import '../../cart/provider/cart_provider.dart';
import '../../cart/widgets/build_cart_stack.dart';
import '../../products/widgets/home_product_item.dart';
import '../../products/provider/products_provider.dart';
import '../../categories/provider/categories_manager.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  const HomeScreen({
    Key key,
    this.tapScaffoldKey,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  var isLoading = false;
  bool _keepAlive = false;

  Future<void> _showArrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate("errorOccurred", context)),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    print('_HomeScreenState initState');
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        _showArrorDialog(translate("anErrorOccurred", context));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showArrorDialog(translate("anErrorOccurred", context));
    }
    _doAsyncStuff();
  }

  Future<void> _doAsyncStuff() async {
    _keepAlive = true;
    updateKeepAlive();
    // Keeping alive...

    await Future.delayed(Duration(minutes: 100));

    _keepAlive = false;
    updateKeepAlive();
    // Can be disposed whenever now.
  }

  @override
  bool get wantKeepAlive => _keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var mediaQuery = MediaQuery.of(context).size;
    var products = Provider.of<Products>(context, listen: false);
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    final cart = Provider.of<Carts>(context);

    final categories =
        Provider.of<CategoriesManager>(context, listen: false).categories;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: language == "ar"
                ? const EdgeInsets.only(left: 10)
                : const EdgeInsets.only(right: 10),
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
            offset: const Offset(6, 0),
            child: IconButton(
              padding: language == "ar"
                  ? const EdgeInsets.only(right: 15)
                  : const EdgeInsets.all(0.0),
              onPressed: () => widget.tapScaffoldKey.currentState.openDrawer(),
              icon: SizedBox(
                // color: Colors.teal,
                height: 30,
                width: 50,
                child: language == "ar"
                    ? Image.asset(
                        "assets/icons/Menu icon2.png",
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/icons/Menu icon.png",
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ),
        title: SizedBox(
          width: mediaQuery.width / 3,
          child: Image.asset(
            AssetsUtils.oceanFruitsLogo,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: sleekCircularSlider(context, screenUtil.setSp(100),
                  AppColors.greenColor, AppColors.scondryColor),
            )
          : RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                await Provider.of<Products>(context, listen: false)
                    .fetchProducts();
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    color: AppColors.primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                    width: mediaQuery.width,
                                    height: isLandScape
                                        ? screenUtil.setHeight(700)
                                        : screenUtil.setHeight(480),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: products.adsImage == null
                                        ? Image.asset(
                                            "assets/images/offer.png",
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            products.adsImage,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: true,
                              elevation: 0.0,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _buildRaisedBattom(
                                      language == "ar"
                                          ? categories[i].arName
                                          : categories[i].enName,
                                      mediaQuery,
                                      () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductsScreen(
                                              cat: categories[i],
                                            ),
                                          ),
                                        );
                                      },
                                      screenUtil,
                                      isLandScape,
                                    ),
                                  );
                                },
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     _buildRaisedBattom(
                              //         translate("fruits", context), mediaQuery,
                              //         () {
                              //       Navigator.of(context).pushNamed(
                              //         FruitsScreen.routeName,
                              //       );
                              //     }, screenUtil, isLandScape),
                              //     SizedBox(width: 10),
                              //     _buildRaisedBattom(
                              //         translate("vegetabel", context),
                              //         mediaQuery, () {
                              //       Navigator.of(context).pushNamed(
                              //         VegetableScreen.routeName,
                              //       );
                              //     }, screenUtil, isLandScape),
                              //   ],
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Divider(thickness: 3),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          translate(
                                              "featuredProducts", context),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(thickness: 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    ChangeNotifierProvider.value(
                                  value: products.recommendeProducts[index],
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: const ProductItem(),
                                  ),
                                ),
                                childCount: products.recommendeProducts.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.97,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 4,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, indext) => Container(
                                  height: 10,
                                ),
                                childCount: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRaisedBattom(String title, Size mediaQuery, Function function,
      ScreenUtil screenUtil, bool isLandScape) {
    return Container(
      width: mediaQuery.width / 3,
      height:
          isLandScape ? screenUtil.setHeight(200) : screenUtil.setHeight(130),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: AppColors.primaryColor,
        textColor: Colors.white,
        child: Text(
          title,
          style: TextStyle(
            fontSize: isLandScape ? screenUtil.setSp(30) : screenUtil.setSp(37),
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: function,
      ),
    );
  }
}
