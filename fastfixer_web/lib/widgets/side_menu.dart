// side_menu.dart

import 'package:flutter/material.dart';
import 'package:fastfixer_web/constants/style.dart';
import 'package:fastfixer_web/widgets/custom_text.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: light,
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(width: 16),
                  CustomText(
                    text: "Dash",
                    size: 18,
                    weight: FontWeight.normal,
                    color: active,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Divider(color: lightGrey.withOpacity(0.1)),
          ListTile(
            title: Text("Busqueda"),
            onTap: () {
              Navigator.pushNamed(
                  context, '/pantalla1'); // Navega a la pantalla 1
            },
          ),
          ListTile(
            title: Text("Registro"),
            onTap: () {
              Navigator.pushNamed(
                  context, '/pantalla2'); // Navega a la pantalla 2
            },
          ),
          ListTile(
            title: Text("Servicios"),
            onTap: () {
              Navigator.pushNamed(
                  context, '/pantalla3'); // Navega a la pantalla 3
            },
          ),
        ],
      ),
    );
  }
}
