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
  String? selectedCompany;
  String selectedContractorId = '';
  String serviceName = '';
  String serviceDescription = '';
  String? selectedEmployee;

  List<Map<String, String>> contractorsFromDatabase = [];
  List<String> uniqueCompanies = [];
  List<Map<String, String>> employeesFromDatabase = [];

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
    Set<String> companyNames = {};

    querySnapshot.docs.forEach((doc) {
      contractorsList.add({
        'id': doc.id,
        'nombre_empresa': doc['nombre_empresa'],
      });
      companyNames.add(doc['nombre_empresa']);
    });

    setState(() {
      contractorsFromDatabase = contractorsList;
      uniqueCompanies = companyNames.toList();
      selectedCompany = null;
      selectedContractorId = '';
      employeesFromDatabase = [];
      selectedEmployee = null;
    });
  }

  Future<void> fetchEmployeesFromDatabase(String companyName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nombre_empresa', isEqualTo: companyName)
        .get();

    List<Map<String, String>> employeesList = [];

    querySnapshot.docs.forEach((doc) {
      employeesList.add({
        'id': doc.id,
        'nombre': doc['nombre'],
        'apellidos': doc['apellidos'],
      });
    });

    setState(() {
      employeesFromDatabase = employeesList;
    });
  }

  Future<void> registerService() async {
    if (selectedSpecialty != null &&
        selectedCompany != null &&
        selectedEmployee != null &&
        serviceName.isNotEmpty &&
        serviceDescription.isNotEmpty) {
      CollectionReference services =
          FirebaseFirestore.instance.collection('servicios');
      await services.add({
        'especialidad': selectedSpecialty,
        'empresa': selectedCompany,
        'contratista_id': selectedContractorId,
        'nombre_empleado': selectedEmployee,
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
      child: SingleChildScrollView(
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
            // Combo Box de Empresa
            DropdownButton<String>(
              hint: Text('Seleccione una empresa'),
              value: selectedCompany,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCompany = newValue;
                  selectedContractorId = contractorsFromDatabase.firstWhere(
                      (contractor) => contractor['nombre_empresa'] == newValue)['id']!;
                  fetchEmployeesFromDatabase(newValue!);
                });
              },
              items: uniqueCompanies.map((companyName) {
                return DropdownMenuItem<String>(
                  value: companyName,
                  child: Text(companyName),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            // Combo Box de Empleados de la Empresa Seleccionada
            if (employeesFromDatabase.isNotEmpty)
              DropdownButton<String>(
                hint: Text('Seleccione un empleado'),
                value: selectedEmployee,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEmployee = newValue;
                    selectedContractorId = employeesFromDatabase.firstWhere(
                        (employee) => '${employee['nombre']} ${employee['apellidos']}' == newValue)['id']!;
                  });
                },
                items: employeesFromDatabase.map((employee) {
                  String fullName = '${employee['nombre']} ${employee['apellidos']}';
                  return DropdownMenuItem<String>(
                    value: fullName,
                    child: Text(fullName),
                  );
                }).toList(),
              ),
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
      ),
    );
  }
}
