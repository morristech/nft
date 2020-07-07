import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nft/generated/l10n.dart';
import 'package:nft/pages/base/content_page.dart';
import 'package:nft/pages/counter/counter_page.dart';
import 'package:nft/pages/home/home_page.dart';
import 'package:nft/pages/home/home_provider.dart';
import 'package:nft/pages/tutorial/tutorial_page.dart';
import 'package:nft/services/app_loading.dart';
import 'package:nft/services/local_storage.dart';
import 'package:nft/services/remote/auth_api.dart';
import 'package:nft/utils/app_asset.dart';
import 'package:nft/utils/app_constant.dart';
import 'package:nft/utils/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> myMain() async {
  // Start services later
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  // Run Application
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        Provider<AuthApi>(create: (_) => AuthApi()),
        Provider<LocalStorage>(create: (_) => LocalStorage()),
        Provider<AppLoadingProvider>(create: (_) => AppLoadingProvider()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<AppThemeProvider>(
            create: (_) => AppThemeProvider()),
        ChangeNotifierProvider<HomeProvider>(
            create: (BuildContext context) =>
                HomeProvider(context.read<AuthApi>())),
      ],
      child: Consumer<LocaleProvider>(
        builder: (BuildContext context, LocaleProvider localeProvider,
            Widget child) {
          return MaterialApp(
            locale: localeProvider.locale,
            supportedLocales: S.delegate.supportedLocales,
            // ignore: always_specify_types, prefer_const_literals_to_create_immutables
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: AppFonts.roboto,
                pageTransitionsTheme: buildPageTransitionsTheme()),
            initialRoute: AppConstant.rootPageRoute,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case AppConstant.rootPageRoute:
                  return MaterialPageRoute<dynamic>(
                      builder: (_) => const ContentPage(body: HomePage()));
                case AppConstant.tutorialPageRoute:
                  return TutorialPage();
                case AppConstant.counterPageRoute:
                  return MaterialPageRoute<dynamic>(
                      builder: (_) => ContentPage(
                          body: CounterPage(
                              argument: settings.arguments as String)));
                default:
                  return MaterialPageRoute<dynamic>(
                      builder: (_) => const ContentPage(body: HomePage()));
              }
            },
          );
        },
      ),
    );
  }

  // Custom page transitions theme
  PageTransitionsTheme buildPageTransitionsTheme() {
    return const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
      },
    );
  }
}

class LocaleProvider with ChangeNotifier {
  Locale locale = Locale(ui.window.locale?.languageCode ?? ' en');

  Future<void> updateLocale(Locale locale) async {
    this.locale = locale;
    notifyListeners();
  }
}
