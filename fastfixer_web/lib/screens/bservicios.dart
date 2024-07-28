import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPageSer extends StatefulWidget {
  @override
  _SearchPageSer createState() => _SearchPageSer();
}

class _SearchPageSer extends State<SearchPageSer> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Servicios'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, especialidad, empresa',
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
        stream: FirebaseFirestore.instance.collection('servicios').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var services = snapshot.data!.docs.where((doc) {
            var searchTerm = _searchController.text.toLowerCase();
            return doc['nombre_servicio']
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm) ||
                doc['especialidad']
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm) ||
                doc['empresa'].toString().toLowerCase().contains(searchTerm);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all<Color>(Colors.black),
              headingTextStyle: TextStyle(
                color: Colors.white,
              ),
              columns: [
                DataColumn(label: Text('Empresa')),
                DataColumn(label: Text('Especialidad')),
                DataColumn(label: Text('Servicio')),
                DataColumn(label: Text('Descripción')),
              ],
              rows: services.map((service) {
                return DataRow(cells: [
                  DataCell(Text(service['empresa'])),
                  DataCell(Text(service['especialidad'])),
                  DataCell(Text(service['nombre_servicio'])),
                  DataCell(Text(service['descripcion_servicio'])),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
