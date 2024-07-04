import 'package:fastfixer_web/constants/style.dart';
import 'package:fastfixer_web/controllers/menu_controller.dart';
import 'package:fastfixer_web/helpers/responsiveness.dart';
import 'package:fastfixer_web/routing/routes.dart';
import 'package:fastfixer_web/widgets/custom_text.dart';
import 'package:fastfixer_web/widgets/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallSize(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: _width / 48),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Image.asset("assets/icons/logo.png"),
                    ),
                    Flexible(
                        child: CustomText(
                            text: "Dash",
                            size: 18,
                            weight: FontWeight.normal,
                            color: active)),
                    SizedBox(width: _width / 48),
                  ],
                ),
              ],
            ),
          SizedBox(height: 40),
          Divider(color: lightGrey.withOpacity(0.1)),
          Column(mainAxisSize: MainAxisSize.min, children: [])
        ],
      ),
    );
  }
}
