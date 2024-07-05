import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Importa este paquete para inputFormatters

class EditUserPage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> userData;

  EditUserPage({required this.documentId, required this.userData});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidosController;
  late TextEditingController _especialidadController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _contrasenaController;
  late String _tipo;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.userData['nombre']);
    _apellidosController = TextEditingController(text: widget.userData['apellidos']);
    _especialidadController = TextEditingController(text: widget.userData['especialidad']);
    _direccionController = TextEditingController(text: widget.userData['direccion']);
    _telefonoController = TextEditingController(text: widget.userData['telefono']);
    _correoController = TextEditingController(text: widget.userData['correo']);
    _contrasenaController = TextEditingController(text: widget.userData['contrasena']);
    _tipo = widget.userData['tipo'];
  }

  void _updateUser() {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseFirestore.instance.collection('usuarios').doc(widget.documentId).update({
        'nombre': _nombreController.text,
        'apellidos': _apellidosController.text,
        'especialidad': _especialidadController.text,
        'direccion': _direccionController.text,
        'telefono': _telefonoController.text,
        'correo': _correoController.text,
        'contrasena': _contrasenaController.text,
        'tipo': _tipo,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario actualizado exitosamente')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidosController,
                decoration: InputDecoration(labelText: 'Apellidos'),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los apellidos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _especialidadController,
                decoration: InputDecoration(labelText: 'Especialidad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la especialidad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _correoController,
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
              ),
              TextFormField(
                controller: _contrasenaController,
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
              ),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: ['Contratista']
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipo = value ?? 'Contratista';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el tipo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Actualizar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
