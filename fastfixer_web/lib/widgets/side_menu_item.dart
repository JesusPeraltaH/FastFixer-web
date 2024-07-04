import 'package:fastfixer_web/helpers/responsiveness.dart';
import 'package:fastfixer_web/widgets/horizontal_menu_item.dart';
import 'package:fastfixer_web/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final Function()? onTap;
  const SideMenuItem({super.key, required this.itemName, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context))
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );

    return HorizontalMenuItem(itemName: itemName, onTap: onTap);
  }
}
