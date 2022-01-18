import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import '../../products/screens/favorites_screen.dart';
import '../../../core/utils/app_constant.dart';
import '../../cart/provider/cart_provider.dart';
import 'home_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../../core/widgets/drawer.dart';

class TapScreen extends StatefulWidget {
  static const routeName = '/tap_screen';

  const TapScreen({Key key}) : super(key: key);

  @override
  _TapScreenState createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  final GlobalKey<ScaffoldState> _tapScaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  var _subscription;
  Connectivity _connectivity;

  List<Widget> _pages;

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
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _connectivity = Connectivity();

    _subscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          setState(() {});
        }
        if (result == ConnectivityResult.none) {
          return _showArrorDialog(translate("checkInternet", context));
        }
      },

      // onError: (e) =>
    );
    _pages = [
      HomeScreen(tapScaffoldKey: _tapScaffoldKey),
      CartScreen(tapScaffoldKey: _tapScaffoldKey),
      FavoritesScreen(tapScaffoldKey: _tapScaffoldKey),
    ];
  }

  int _selectedItemIndex = 0;

  @override
  dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final cart = Provider.of<Carts>(context);

    return Scaffold(
      key: _tapScaffoldKey,
      drawer: const AppDrawer(),
      body: PageView(
        controller: _pageController,
        children: _pages,
        // physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedItemIndex = index;
          });
        },
      ),
      // _pages[_selectedItemIndex],
      //  IndexedStack(
      //   index: _selectedItemIndex,
      //   children: _pages,
      // ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              spreadRadius: 0.5,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildBottomNavItem(
              mediaQuery / 3,
              translate("home", context),
              "assets/icons/home stroke.png",
              "assets/icons/Home Fill.png",
              0,
            ),
            _buildBottomNavItem(
              mediaQuery / 3,
              translate("cart", context),
              "assets/icons/cart stroke.png",
              "assets/icons/Cart Fill.png",
              1,
              redCircle: cart.items.isEmpty
                  ? const SizedBox()
                  : Positioned(
                      right: -5,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: AppColors.redColor,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              "${cart.itemCount}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            _buildBottomNavItem(
              mediaQuery / 3,
              translate("favorits", context),
              "assets/icons/wishlist stroke.png",
              "assets/icons/wishlist fill.png",
              2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      Size mediaQuery, String text, String icon, String icon2, int index,
      {Widget redCircle}) {
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(index);
        // setState(() {
        // _selectedItemIndex = index;
        // });
      },
      child: Container(
        height: 55,
        width: mediaQuery.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (index != _selectedItemIndex)
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset(
                      icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                  redCircle ?? const SizedBox(),
                ],
              ),
            if (index == _selectedItemIndex)
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset(
                      icon2,
                      fit: BoxFit.contain,
                    ),
                  ),
                  redCircle ?? const SizedBox(),
                ],
              ),
            const SizedBox(height: 3),
            Text(
              text,
              style: TextStyle(
                color: index == _selectedItemIndex ? Colors.green : Colors.grey,
                fontSize: index == _selectedItemIndex ? 12 : 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
