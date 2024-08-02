import 'package:fastfixer_web/screens/modificar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _deleteRecord(String documentId, String nombre, String apellidos,
      String especialidad, String telefono, String nombreEmpresa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Seguro que desea eliminar este registro?'),
                SizedBox(height: 10),
                Text('$nombre $apellidos'),
                Text('$especialidad'),
                Text('$telefono'),
                SizedBox(height: 10), // Espaciado adicional
                Text('Empresa: $nombreEmpresa'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(documentId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editRecord(String documentId, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditUserPage(documentId: documentId, userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text('Buscar Registros'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    'Buscar por nombre, apellidos, especialidad o empresa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {}); // Actualiza la búsqueda en tiempo real
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No hay datos disponibles.'));
          }

          // Filtrar los resultados basados en el texto de búsqueda
          final results =
              snapshot.data!.docs.where((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            String searchValue = _searchController.text.toLowerCase();
            return (data['nombre']
                        ?.toString()
                        ?.toLowerCase()
                        ?.contains(searchValue) ??
                    false) ||
                (data['apellidos']
                        ?.toString()
                        ?.toLowerCase()
                        ?.contains(searchValue) ??
                    false) ||
                (data['especialidad']
                        ?.toString()
                        ?.toLowerCase()
                        ?.contains(searchValue) ??
                    false) ||
                (data['nombre_empresa']
                        ?.toString()
                        ?.toLowerCase()
                        ?.contains(searchValue) ??
                    false);
          }).toList();

          if (results.isEmpty) {
            return Center(child: Text('No se encontraron resultados.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all<Color>(Colors.grey[800]!),
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                columns: const [
                  DataColumn(label: Text('Perfil')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Especialidad')),
                  DataColumn(label: Text('Teléfono')),
                  DataColumn(label: Text('Empresa')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: results.map((document) {
                  final data = document.data() as Map<String, dynamic>;
                  final imageUrl = data['perfil_avatar'];

                  return DataRow(
                    cells: [
                      DataCell(
                        CircleAvatar(
                          backgroundImage:
                              imageUrl != null && imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                          child: imageUrl == null || imageUrl.isEmpty
                              ? Icon(Icons.person)
                              : null,
                        ),
                      ),
                      DataCell(Text('${data['nombre']} ${data['apellidos']}')),
                      DataCell(Text('${data['especialidad']}')),
                      DataCell(Text('${data['telefono']}')),
                      DataCell(Text('${data['nombre_empresa']}')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editRecord(
                                  document.id,
                                  data,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteRecord(
                                  document.id,
                                  data['nombre'],
                                  data['apellidos'],
                                  data['especialidad'],
                                  data['telefono'],
                                  data['nombre_empresa'],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
