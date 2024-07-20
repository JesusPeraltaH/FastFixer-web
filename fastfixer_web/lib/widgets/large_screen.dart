import 'package:fastfixer_web/screens/bservicios.dart';
import 'package:fastfixer_web/screens/busqueda.dart';
import 'package:fastfixer_web/screens/servicios.dart';
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
          _currentPage = SearchPage();
          break;
        case 'Contratista 2':
          _currentPage = Contratistas();
          break;
        case 'Contratista 3':
          _currentPage = Servicios();
          break;
        case 'Contratista 4':
          _currentPage = SearchPageSer();
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
                        text: "Buscar Contratistas",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 2'),
                      child: CustomText(
                        text: "Registrar C",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 3'),
                      child: CustomText(
                        text: "Registrar Servicios",
                        size: 24,
                        color: Colors.black,
                        weight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo('Contratista 4'),
                      child: CustomText(
                        text: "Buscar Servicios",
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
