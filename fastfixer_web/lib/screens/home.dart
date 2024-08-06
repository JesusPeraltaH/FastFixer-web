import 'package:flutter/material.dart';

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

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 2/1,
          children: <Widget>[
            DashboardCard(title: "Órdenes Pendientes", count: 0, icon: Icons.favorite),
            DashboardCard(title: "Órdenes Activas", count: 0, icon: Icons.shopping_cart),
            DashboardCard(title: "Órdenes Completas", count: 0, icon: Icons.local_shipping),
            DashboardCard(title: "Órdenes Canceladas", count: 0, icon: Icons.cancel),
            DashboardCard(title: "Categorías", count: 10, icon: Icons.category),
            DashboardCard(title: "Productos", count: 27, icon: Icons.shopping_basket),
            DashboardCard(title: "Promociones", count: 3, icon: Icons.campaign),
            DashboardCard(title: "Marcas", count: 4, icon: Icons.store),
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
