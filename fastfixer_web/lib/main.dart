import 'package:fastfixer_web/layout.dart';
import 'package:fastfixer_web/screens/contratistas.dart';
import 'package:fastfixer_web/screens/home.dart';
import 'package:fastfixer_web/widgets/small_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(MenuController());
  Get.find<MenuController>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) =>
        SiteLayout(), // Ruta por defecto: SiteLayout como página principal
    '/pantalla1': (context) => Contratistas(),
    '/pantalla2': (context) => Homepage(),
    '/pantalla3': (context) => SmallScreen(),
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
