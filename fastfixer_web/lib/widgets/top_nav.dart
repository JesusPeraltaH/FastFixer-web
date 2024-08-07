import 'package:fastfixer_web/constants/style.dart';
import 'package:fastfixer_web/helpers/responsiveness.dart';
import 'package:fastfixer_web/screens/home.dart';
import 'package:fastfixer_web/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) {
  return AppBar(
    leading: !ResponsiveWidget.isSmallSize(context)
        ? Padding(
            padding: EdgeInsets.only(left: 14),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF424242),
              child: Image.asset(
                "assets/icons/logo.png",
                height: 40, // Tamaño ajustado
                width: 40, // Tamaño ajustado
              ),
            ),
          )
        : IconButton(
            onPressed: () {
              if (key.currentState != null) {
                key.currentState!.openDrawer();
              }
            },
            icon: Icon(Icons.menu)),
    elevation: 0,
    title: Row(
      children: [
        Visibility(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: CustomText(
                text: "Fast Fixer Dash",
                size: 20,
                weight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Expanded(child: Container()),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            )),
        Stack(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
            Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: light, width: 2)),
                ))
          ],
        ),
        SizedBox(width: 24),
        CustomText(
            text: "Jesus",
            size: 18,
            weight: FontWeight.normal,
            color: Colors.white),
        SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundColor: light,
              child: Icon(
                Icons.person_outline,
                color: dark,
              ),
            ),
          ),
        ),
      ],
    ),
    iconTheme: IconThemeData(color: dark),
    backgroundColor: Color(0xFFFA9F16),
  );
}
