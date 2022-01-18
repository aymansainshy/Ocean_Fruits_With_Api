import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ocean_fruits/app_blocs.dart';
import 'package:provider/provider.dart';

import 'src/core/utils/assets_utils.dart';
import 'src/modules/categories/provider/categories_manager.dart';
import 'src/modules/main-view/screens/animated_splash_screen.dart';
import 'src/modules/products/provider/products_provider.dart';
import 'src/modules/orders/provider/orders_provider.dart';
import 'src/modules/cart/provider/cart_provider.dart';
import 'src/modules/auth/provider/auth_provider.dart';
import 'src/core/utils/app_routes.dart';
import 'src/modules/lang/provider/language_provider.dart';
import 'src/modules/lang/app_locelazation.dart';
import 'src/modules/auth/screens/login_screen.dart';
import 'src/modules/main-view/screens/tap_screen.dart';
import 'src/core/utils/app_constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LanguageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriesManager(),
        ),

        ///[ProxyProvider]  the 'UserProvider' widget depends on  [Auth] & [ProductProvider]
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          update: (context, auth, __) => Products(auth.userId),
          create: (_) => null,
        ),

        ChangeNotifierProvider.value(
          value: Carts(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MultiBlocProvider(
        providers: AppBlocs.providers,
        child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, _) => FutureBuilder(
            future: languageProvider.fetchLocale(),
            builder: (context, snapShot) => Consumer<AuthProvider>(
              builder: (context, auth, _) => MaterialApp(
                title: "Osean Fruits",
                locale: languageProvider.appLocal,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'SA'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: appTheme,
                routes: routs,
                home: AnimatedSplashScreen(
                  home: auth.isAuth
                      ? const TapScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (context, authResult) =>
                              authResult.connectionState ==
                                      ConnectionState.waiting
                                  ? const Scaffold(
                                      body: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const LoginScreen(),
                        ),
                  duration: 2500, //
                  type: AnimatedSplashType.BackgroundProcess,
                  imagePath: AssetsUtils.oceanFruitsLogo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//                    HOME

//                    BlocConsumer<AppBloc, AppState>(
//                     listener: (context, appState) {
//                       if (appState is AppSetupInFailer) {
//                         return customeAlertDialoge(
//                           context: context,
//                           title: translate("error", context),
//                           errorMessage: translate("anErrorPleaseTryLater", context),
//                           fun: () {
//                             AppBlocs.appBloc.add(AppStarted());
//                           },
//                         );
//                       }
//                     },
//                     builder: (context, appState) {
//                       if (appState is AppSetupInComplete) {
//                         return BlocBuilder<AuthenticationBloc,
//                             AuthenticationState>(
//                           builder: (context, authState) {
//                             if (authState is AuthenticationSuccsess &&
//                                 authState.status == AuthStatus.AUTHENTICATED) {
//                               return TapsView();
//                             } else {
//                               return LogInView();
//                             }
//                           },
//                         );
//                       }
//                       return AnimatedSplashView(
//                         imagePath: "assets/svgs/mumayz_logo_icon.svg",
//                         duration: 500,
//                       );
//                     },
//                   ),