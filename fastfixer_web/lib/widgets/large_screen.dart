import 'package:flutter/material.dart';
import 'package:fastfixer_web/screens/contratistas.dart';
import 'package:fastfixer_web/screens/home.dart';
import 'package:fastfixer_web/widgets/small_screen.dart';
import 'package:fastfixer_web/constants/style.dart';
import 'package:fastfixer_web/widgets/custom_text.dart';

class LargeScreen extends StatefulWidget {
  const LargeScreen({Key? key}) : super(key: key);

  @override
  _LargeScreenState createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  Widget _currentPage = Homepage(); // Página por defecto

  void _navigateTo(String page) {
    setState(() {
      switch (page) {
        case 'Contratista 1':
          _currentPage = SmallScreen();
          break;
        case 'Contratista 2':
          _currentPage = Contratistas();
          break;
        case 'Contratista 3':
          _currentPage = SmallScreen();
          break;
        default:
          _currentPage =
              Homepage(); // Página por defecto si no se encuentra ninguna coincidencia
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: light,
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 1'),
                      child: CustomText(
                        text: "Contratista 1",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 2'),
                      child: CustomText(
                        text: "Contratista 2",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 3'),
                      child: CustomText(
                        text: "Contratista 3",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.blue,
            child: Center(
              child:
                  _currentPage, // Mostrar la página actual según la selección
            ),
          ),
        ),
      ],
    );
  }
}
