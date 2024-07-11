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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, apellidos, especialidad o empresa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final results =
              snapshot.data!.docs.where((DocumentSnapshot document) {
            String searchValue = _searchController.text.toLowerCase();
            return document['nombre']
                    .toString()
                    .toLowerCase()
                    .contains(searchValue) ||
                document['apellidos']
                    .toString()
                    .toLowerCase()
                    .contains(searchValue) ||
                document['especialidad']
                    .toString()
                    .toLowerCase()
                    .contains(searchValue) ||
                document['nombre_empresa']
                    .toString()
                    .toLowerCase()
                    .contains(searchValue);
          }).toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final document = results[index];
              return ListTile(
                title: Text('${document['nombre']} ${document['apellidos']}'),
                subtitle: Text(
                  '${document['especialidad']}, ${document['correo']}, ${document['telefono']}, ${document['direccion']}\n\nEmpresa: ${document['nombre_empresa']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editRecord(document.id,
                            document.data() as Map<String, dynamic>);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteRecord(
                          document.id,
                          document['nombre'],
                          document['apellidos'],
                          document['especialidad'],
                          document['telefono'],
                          document['nombre_empresa'],
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Detalles del Registro'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text(
                                  'Nombre: ${document['nombre']} ${document['apellidos']}'),
                              Text('Especialidad: ${document['especialidad']}'),
                              Text('Dirección: ${document['direccion']}'),
                              Text('Teléfono: ${document['telefono']}'),
                              Text('Correo: ${document['correo']}'),
                              Text('Tipo: ${document['tipo']}'),
                              SizedBox(height: 10), // Espaciado adicional
                              Text('Empresa: ${document['nombre_empresa']}'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
