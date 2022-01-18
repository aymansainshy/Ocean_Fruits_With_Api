import '../../modules/user-profile/screens/edit_profile_screen.dart';
import '../../modules/main-view/screens/home_screen.dart';
import '../../modules/products/screens/favorites_screen.dart';
import '../../modules/cart/screens/check_out_screen.dart';
import '/src/modules/lang/screens/language_screen.dart';
import '../../modules/auth/screens/sign_up_screen.dart';
import '../../modules/user-profile/screens/profile_screen.dart';
import '../../modules/auth/screens/login_screen.dart';
import '../../modules/orders/screens/order_screen.dart';
import '../../modules/products/screens/products_screen.dart';
import '../../modules/cart/screens/cart_screen.dart';
import '../../modules/main-view/screens/tap_screen.dart';

var routs = {
  TapScreen.routeName: (context) => const TapScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  OrderScreen.routeName: (context) => const OrderScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  LanguageScreen.routeName: (context) => const LanguageScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  CheckOutScreen.routeName: (context) => const CheckOutScreen(),
  FavoritesScreen.routeName: (context) => const FavoritesScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
};
