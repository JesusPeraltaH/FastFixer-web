import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Stream<List<Map<String, dynamic>>> _dataStream;
  late StreamController<List<Map<String, dynamic>>> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<Map<String, dynamic>>>();
    _dataStream = _streamController.stream;
    _startFetchingData();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _startFetchingData() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 10));
      if (_streamController.isClosed) return false;
      final data = await _fetchData();
      _streamController.add(data);
      return true;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final queueSnapshot =
        await FirebaseFirestore.instance.collection('queue').get();
    final userSnapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();

    final List<Map<String, dynamic>> queueData = queueSnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data(),
            })
        .toList();

    final List<Map<String, dynamic>> userData =
        userSnapshot.docs.map((doc) => {'uid': doc.id, ...doc.data()}).toList();

    List<Map<String, dynamic>> combinedData = [];

    for (var queueDoc in queueData) {
      Map<String, dynamic> userDoc = userData.firstWhere(
        (user) => user['uid'] == queueDoc['data']?['contratistaId'],
        orElse: () => <String, dynamic>{},
      );

      if (userDoc.isNotEmpty) {
        combinedData.add({
          'nombre_empresa': userDoc['nombre_empresa'] ?? '',
          'especialidad': userDoc['especialidad'] ?? '',
          'isContacted':
              ((queueDoc['data'] as Map<String, dynamic>?)?['isContacted'] ??
                      false)
                  ? 'Confirmado'
                  : 'Pendiente por confirmar',
          'queueId': queueDoc['id'],
        });
      }
    }

    return combinedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 2 / 1,
                children: <Widget>[
                  DashboardCard(
                      title: "Órdenes Pendientes",
                      count: 0,
                      icon: Icons.favorite),
                  DashboardCard(
                      title: "Órdenes Activas",
                      count: 0,
                      icon: Icons.shopping_cart),
                  DashboardCard(
                      title: "Órdenes Completas",
                      count: 0,
                      icon: Icons.local_shipping),
                  DashboardCard(
                      title: "Órdenes Canceladas",
                      count: 0,
                      icon: Icons.cancel),
                  DashboardCard(
                      title: "Categorías", count: 10, icon: Icons.category),
                  DashboardCard(
                      title: "Productos",
                      count: 27,
                      icon: Icons.shopping_basket),
                  DashboardCard(
                      title: "Promociones", count: 3, icon: Icons.campaign),
                  DashboardCard(title: "Marcas", count: 4, icon: Icons.store),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No se encontraron resultados.'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre Empresa')),
                        DataColumn(label: Text('Especialidad')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(data['nombre_empresa'] ?? '')),
                            DataCell(Text(data['especialidad'] ?? '')),
                            DataCell(Text(data['isContacted'])),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  // Acción del botón
                                },
                                child: Text('%'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  DashboardCard({required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.0),
            Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Icon(icon, size: 30.0),
          ],
        ),
      ),
    );
  }
}
