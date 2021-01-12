import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/favorites_screen.dart';
import '../utils/app_constant.dart';
import '../providers/cart_provider.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../widgets/drawer.dart';

class TapScreen extends StatefulWidget {
  static const routeName = '/tap_screen';

  @override
  _TapScreenState createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  final GlobalKey<ScaffoldState> _tapScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final _pageController = PageController();

  List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(tapScaffoldKey: _tapScaffoldKey),
      CartScreen(tapScaffoldKey: _tapScaffoldKey),
      FavoritesScreen(tapScaffoldKey: _tapScaffoldKey),
    ];
  }

  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final cart = Provider.of<Carts>(context);

    return Scaffold(
      key: _tapScaffoldKey,
      drawer: AppDrawer(),
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
        decoration: BoxDecoration(
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
                  ? SizedBox()
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
                              style: TextStyle(
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
        decoration: BoxDecoration(
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
                  Container(
                    height: 30,
                    child: Image.asset(
                      icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                  redCircle ?? SizedBox(),
                ],
              ),
            if (index == _selectedItemIndex)
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 30,
                    child: Image.asset(
                      icon2,
                      fit: BoxFit.contain,
                    ),
                  ),
                  redCircle ?? SizedBox(),
                ],
              ),
            SizedBox(height: 3),
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
