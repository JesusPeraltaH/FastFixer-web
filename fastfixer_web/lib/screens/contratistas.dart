import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Importa este paquete para inputFormatters

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Contratistas());
}

class Contratistas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulario de Registro',
      home: RegistrationForm(),
      color: Colors.white,
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String _nempresa = '';
  String _nombre = '';
  String _apellidos = '';
  String? _especialidad;
  String _direccion = '';
  String _telefono = '';
  String _correo = '';
  String _contrasena = '';
  String _tipo = 'Contratista';
  bool _obscureText = true;

  // Lista de especialidades
  final List<String> _especialidades = [
    'Electricista',
    'Plomero',
    'Llantero',
    'Cerrajeria',
    'Mantenimiento de celulares',
    'Mantenimiento de techos'
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Envía los datos a Firestore
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nombre_empresa': _nempresa,
        'nombre': _nombre,
        'apellidos': _apellidos,
        'especialidad': _especialidad,
        'direccion': _direccion,
        'telefono': _telefono,
        'correo': _correo,
        'contrasena': _contrasena,
        'tipo': _tipo,
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Formulario de Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la Empresa'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nempresa = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombre = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellidos'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los apellidos';
                  }
                  return null;
                },
                onSaved: (value) {
                  _apellidos = value ?? '';
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Especialidad'),
                value: _especialidad,
                items: _especialidades.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una especialidad';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _especialidad = value;
                  });
                },
                onSaved: (value) {
                  _especialidad = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
                onSaved: (value) {
                  _direccion = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
                onSaved: (value) {
                  _telefono = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor ingrese un correo válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _correo = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contrasena = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                readOnly: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
