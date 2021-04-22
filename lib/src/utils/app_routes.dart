import '../screens/edit_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/check_out_screen.dart';
import '../screens/language_screen.dart';
import '../screens/sign_up_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/order_screen.dart';
import '../screens/products_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/tap_screen.dart';

var routs = {
  TapScreen.routeName: (context) => TapScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  LanguageScreen.routeName: (context) => LanguageScreen(),
  ProductsScreen.routeName: (context) => ProductsScreen(),
  CheckOutScreen.routeName: (context) => CheckOutScreen(),
  FavoritesScreen.routeName: (context) => FavoritesScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
};
