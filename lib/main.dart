import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './src/screens/animated_splash_screen.dart';
import './src/providers/products_provider.dart';
import './src/providers/orders_provider.dart';
import './src/providers/cart_provider.dart';
import './src/providers/auth_provider.dart';
import './src/lang/language_provider.dart';
import './src/lang/app_locelazation.dart';
import './src/screens/login_screen.dart';
import './src/screens/tap_screen.dart';
import './src/utils/app_constant.dart';
import './src/utils/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LanguageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Carts(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) => FutureBuilder(
          future: languageProvider.fetchLocale(),
          builder: (context, snapShot) => Consumer<AuthProvider>(
            builder: (context, auth, _) => MaterialApp(
              title: "Osean Fruits",
              locale: languageProvider.appLocal,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ar', 'SA'),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              routes: routs,
              home: AnimatedSplashScreen(
                home: auth.isAuth
                    ? TapScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, authResult) =>
                            authResult.connectionState ==
                                    ConnectionState.waiting
                                ? Scaffold(
                                    body: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : LoginScreen(),
                      ),
                duration: 2500,
                type: AnimatedSplashType.StaticDuration,
                imagePath:
                    "assets/images/Ocean Agriculture fruit & Vegetables-01.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
