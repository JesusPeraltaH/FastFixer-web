import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Servicios());
}

class Servicios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Registro de Servicio'),
          backgroundColor: Colors.white,
        ),
        body: ServiceForm(),
      ),
    );
  }
}

class ServiceForm extends StatefulWidget {
  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  String? selectedSpecialty;
  String? selectedContractor;
  String selectedContractorId = '';
  String serviceName = '';
  String serviceDescription = '';

  List<Map<String, String>> contractorsFromDatabase = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchContractorsFromDatabase(String specialty) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('especialidad', isEqualTo: specialty)
        .get();
    List<Map<String, String>> contractorsList = [];
    querySnapshot.docs.forEach((doc) {
      contractorsList.add({
        'id': doc.id,
        'nombre': doc['nombre'],
      });
    });
    setState(() {
      contractorsFromDatabase = contractorsList;
      selectedContractor = null;
      selectedContractorId = '';
    });
  }

  Future<void> registerService() async {
    if (selectedSpecialty != null &&
        selectedContractor != null &&
        serviceName.isNotEmpty &&
        serviceDescription.isNotEmpty) {
      CollectionReference services =
          FirebaseFirestore.instance.collection('servicios');
      await services.add({
        'especialidad': selectedSpecialty,
        'contratista': selectedContractor,
        'id': selectedContractorId,
        'nombre_servicio': serviceName,
        'descripcion_servicio': serviceDescription,
      });
      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Servicio registrado exitosamente')));
    } else {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, complete todos los campos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combo Box de Especialidad
          DropdownButton<String>(
            hint: Text('Seleccione una especialidad'),
            value: selectedSpecialty,
            onChanged: (String? newValue) {
              setState(() {
                selectedSpecialty = newValue;
                if (newValue != null) {
                  fetchContractorsFromDatabase(newValue);
                }
              });
            },
            items: [
              'Electricista',
              'Plomero',
              'Llantero',
              'Cerrajeria',
              'Mantenimiento de celulares',
              'Mantenimiento de techos'
            ].map((String specialty) {
              return DropdownMenuItem<String>(
                value: specialty,
                child: Text(specialty),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          // Combo Box de Contratista
          DropdownButton<String>(
            hint: Text('Seleccione un contratista'),
            value: selectedContractor,
            onChanged: (String? newValue) {
              setState(() {
                selectedContractor = newValue;
                selectedContractorId = contractorsFromDatabase.firstWhere(
                    (contractor) => contractor['nombre'] == newValue)['id']!;
              });
            },
            items: contractorsFromDatabase.map((contractor) {
              return DropdownMenuItem<String>(
                value: contractor['nombre'],
                child: Text(contractor['nombre']!),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          // Mostrar ID del contratista seleccionado
          if (selectedContractorId.isNotEmpty)
            Text('ID del contratista: $selectedContractorId'),
          SizedBox(height: 16.0),
          // Campo de Nombre del Servicio
          TextField(
            decoration: InputDecoration(
              labelText: 'Nombre del Servicio',
            ),
            onChanged: (text) {
              setState(() {
                serviceName = text;
              });
            },
          ),
          SizedBox(height: 16.0),
          // Campo de Descripción del Servicio
          TextField(
            decoration: InputDecoration(
              labelText: 'Descripción del Servicio',
            ),
            onChanged: (text) {
              setState(() {
                serviceDescription = text;
              });
            },
          ),
          SizedBox(height: 16.0),
          // Botón de Registrar Servicio
          ElevatedButton(
            onPressed: registerService,
            child: Text('Registrar Servicio'),
          ),
        ],
      ),
    );
  }
}
