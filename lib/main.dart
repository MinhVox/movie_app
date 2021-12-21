// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/page/authen/sign_in/views/sign_in_page.dart';
import 'package:final_training_aia/page/authen/sign_up/views/sign_up_page.dart';
import 'package:final_training_aia/page/detail/artist_detail/views/aritist_img.dart';
import 'package:final_training_aia/page/detail/artist_detail/views/artist_detail_page.dart';
import 'package:final_training_aia/page/detail/movie_detail/views/movie_detail_page.dart';
import 'package:final_training_aia/page/detail/movie_detail/views/trailer_page.dart';
import 'package:final_training_aia/page/main/onboarding/views/onboarding_page.dart';
import 'package:final_training_aia/page/main/tabbar/views/main_tab_bar_page.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationSesson.shared.loadSession();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    initConnectivity();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: intialRoute(),
      routes: {
        Routers.signIn: (context) => SignInPage(),
        Routers.signUp: (context) => SignUpPage(),
        Routers.onBoarding: (context) => OnboardingPage(),
        Routers.main: (context) => MainTabBar(),
        Routers.movieDetail: (context) => MovieDetailPage(),
        Routers.artistDetail: (context) => ArtistDetailPage(),
        Routers.artistImg: (context) => ArtistImg(),
        Routers.trailer: (context) => TrailerPage(),
      },
    );
  }

  String intialRoute() {
    final credential = ApplicationSesson.shared.credential;
    print(credential?.email ?? '');
    if (credential == null) {
      return Routers.signIn;
    }
    return Routers.main;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        ApplicationSesson.shared.isOnline = true;
        print("You are online");
        break;
      case ConnectivityResult.none:
        ApplicationSesson.shared.isOnline = false;
        print("You are offline");
        break;
      default:
        ApplicationSesson.shared.isOnline = true;
        print("You are online");
        break;
    }
  }
}

