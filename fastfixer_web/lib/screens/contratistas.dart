import 'dart:io';

import 'package:fastfixer_web/theme/colors.dart';
import 'package:fastfixer_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
      theme: TAppTheme.lightTheme, // Usa el tema claro
      darkTheme: TAppTheme.darkTheme, // Usa el tema oscuro
      themeMode: ThemeMode
          .light, // Permite cambiar entre temas claro y oscuro automáticamente
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
  final _nempresaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String? _especialidad;
  bool _obscureText = true;
  List<PlatformFile>? _images = [];
  List<PlatformFile>? _documents = [];
  PlatformFile? _profileImage;

  final List<String> _especialidades = [
    'Electricista',
    'Plomero',
    'Llantero',
    'Cerrajeria',
    'Mantenimiento de celulares',
    'Mantenimiento de techos'
  ];

  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _documents = result.files;
      });
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _images = result.files;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _profileImage = result.files.first;
      });
    }
  }

  Widget _buildDocumentPreviews() {
    if (_documents == null || _documents!.isEmpty) {
      return Center(child: Text('No se han seleccionado documentos.'));
    }

    return Column(
      children: _documents!
          .map((file) => ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text(file.name),
              ))
          .toList(),
    );
  }

  Widget _buildImagePreviews() {
    if (_images == null || _images!.isEmpty) {
      return Center(child: Text('No se han seleccionado imágenes.'));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _images!.length,
      itemBuilder: (context, index) {
        final file = _images![index];
        return Image.memory(
          file.bytes!,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildProfileImagePreview() {
    if (_profileImage == null) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: tSecondaryColor,
        child: Icon(Icons.person, size: 50, color: tDarkColor),
      );
    }

    return CircleAvatar(
      radius: 50,
      backgroundImage: MemoryImage(_profileImage!.bytes!),
    );
  }

  Future<String> uploadFile(PlatformFile file) async {
    try {
      var storageReference =
          FirebaseStorage.instance.ref().child('uploads').child(Uuid().v4());

      final metadata = SettableMetadata(
        contentType: file.extension != null && file.extension!.isNotEmpty
            ? 'image/${file.extension}'
            : 'application/octet-stream',
        customMetadata: {'picked-file-path': file.name},
      );

      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) {
          throw Exception("No bytes available for the file.");
        }
        await storageReference.putData(Uint8List.fromList(bytes), metadata);
      } else {
        await storageReference.putFile(File(file.path!), metadata);
      }

      return await storageReference.getDownloadURL();
    } catch (e) {
      print("Error uploading file: $e");
      throw e;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Sube las imágenes a Firebase Storage
      List<String> imageUrls = [];
      if (_images != null) {
        for (var file in _images!) {
          String url = await uploadFile(file);
          imageUrls.add(url);
        }
      }

      // Sube los documentos a Firebase Storage
      List<String> documentUrls = [];
      if (_documents != null) {
        for (var file in _documents!) {
          String url = await uploadFile(file);
          documentUrls.add(url);
        }
      }

      // Sube la imagen de perfil a Firebase Storage
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await uploadFile(_profileImage!);
      }

      // Envía los datos a Firestore
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nombre_empresa': _nempresaController.text,
        'nombre': _nombreController.text,
        'apellidos': _apellidosController.text,
        'especialidad': _especialidad,
        'direccion': _direccionController.text,
        'telefono': _telefonoController.text,
        'correo': _correoController.text,
        'contrasena': _contrasenaController.text,
        'tipo': 'Contratista',
        'imagenes': imageUrls,
        'documentos': documentUrls,
        'perfil_avatar': profileImageUrl,
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );
    }
  }

  @override
  void dispose() {
    _nempresaController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Formulario de Registro',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    _buildProfileImagePreview(),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: _pickProfileImage,
                      child: Text('Seleccionar imagen de perfil'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _nempresaController,
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
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _nombreController,
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
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _apellidosController,
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
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Especialidad'),
                value: _especialidad,
                items: _especialidades
                    .map((especialidad) => DropdownMenuItem<String>(
                          value: especialidad,
                          child: Text(especialidad),
                        ))
                    .toList(),
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
              ),
              SizedBox(
                height: 15,
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
              SizedBox(
                height: 15,
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
              SizedBox(
                height: 15,
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
              SizedBox(
                height: 15,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDocuments,
                child: Text('Seleccionar documentos'),
              ),
              SizedBox(
                height: 15,
              ),
              _buildDocumentPreviews(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Seleccionar imágenes'),
              ),
              SizedBox(
                height: 15,
              ),
              _buildImagePreviews(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Registrar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
