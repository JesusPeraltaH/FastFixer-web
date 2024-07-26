import 'dart:developer';

import 'package:fastfixer_web/layout.dart';
import 'package:fastfixer_web/screens/busqueda.dart';
import 'package:fastfixer_web/screens/contratistas.dart';
import 'package:fastfixer_web/screens/home.dart';
import 'package:fastfixer_web/screens/log.dart';
import 'package:fastfixer_web/screens/servicios.dart';
import 'package:fastfixer_web/widgets/small_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  Get.put(MenuController());
  Get.find<MenuController>();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyArBeH0J-SSFRdhlWR-Jv00dFTHMWEhQ_o",
        authDomain: "quickfix-c271f.firebaseapp.com",
        projectId: "quickfix-c271f",
        storageBucket: "quickfix-c271f.appspot.com",
        messagingSenderId: "48532468752",
        appId: "1:48532468752:web:bbeb5e1f81840680e2c695",
        measurementId: "G-SQETC0BHZN"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) =>LoginScreen(), // Ruta por defecto: SiteLayout como página principal
    '/pantalla': (context) => SiteLayout(),
    '/pantalla1': (context) => SearchPage(),
    '/pantalla2': (context) => Contratistas(),
    '/pantalla3': (context) => Servicios(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fast Fixer Dash ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }),
          primaryColor: Colors.blue),
      initialRoute: "/",
      routes: routes,
    );
  }
}
