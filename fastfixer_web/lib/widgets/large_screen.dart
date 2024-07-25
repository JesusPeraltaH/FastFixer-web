import 'package:flutter/material.dart';
import 'package:fastfixer_web/screens/bservicios.dart';
import 'package:fastfixer_web/screens/busqueda.dart';
import 'package:fastfixer_web/screens/servicios.dart';
import 'package:fastfixer_web/screens/contratistas.dart';
import 'package:fastfixer_web/screens/home.dart';
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
            color: Colors.black, // Color de fondo de la barra lateral
            child: ListView(
              children: [
                ExpansionTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: CustomText(
                    text: "Contratistas",
                    size: 18,
                    color: Colors.white,
                    weight: FontWeight.normal,
                  ),
                  iconColor: Colors.white, // Color del ícono
                  collapsedIconColor:
                      Colors.white, // Color del ícono cuando está colapsado
                  childrenPadding: EdgeInsets.zero, // Quitar el padding interno
                  tilePadding: EdgeInsets.zero, // Quitar el padding del título
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.search,
                            color: Colors.white), // Icono a la izquierda
                        title: CustomText(
                          text: "Busqueda",
                          size: 18,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                        onTap: () => _navigateTo('Contratista 1'),
                        contentPadding:
                            EdgeInsets.zero, // Quitar el padding del contenido
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.person_add,
                            color: Colors.white), // Icono a la izquierda
                        title: CustomText(
                          text: "Registro",
                          size: 18,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                        onTap: () => _navigateTo('Contratista 2'),
                        contentPadding:
                            EdgeInsets.zero, // Quitar el padding del contenido
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: CustomText(
                    text: "Servicios",
                    size: 18,
                    color: Colors.white,
                    weight: FontWeight.normal,
                  ),
                  iconColor: Colors.white, // Color del ícono
                  collapsedIconColor:
                      Colors.white, // Color del ícono cuando está colapsado
                  childrenPadding: EdgeInsets.zero, // Quitar el padding interno
                  tilePadding: EdgeInsets.zero, // Quitar el padding del título
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.search,
                            color: Colors.white), // Icono a la izquierda
                        title: CustomText(
                          text: "Busqueda",
                          size: 18,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                        onTap: () => _navigateTo('Contratista 4'),
                        contentPadding:
                            EdgeInsets.zero, // Quitar el padding del contenido
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListTile(
                        leading: Icon(Icons.person_add,
                            color: Colors.white), // Icono a la izquierda
                        title: CustomText(
                          text: "Registro",
                          size: 18,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                        onTap: () => _navigateTo('Contratista 3'),
                        contentPadding:
                            EdgeInsets.zero, // Quitar el padding del contenido
                      ),
                    ),
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
