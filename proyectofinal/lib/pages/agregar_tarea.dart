// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AgregarTareaPage extends StatefulWidget {
  final Map<String, dynamic>? tarea;
  final Function(Map<String, dynamic>) onTareaAgregada;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  AgregarTareaPage({required this.onTareaAgregada, this.tarea});

  @override
  // ignore: library_private_types_in_public_api
  _AgregarTareaPageState createState() => _AgregarTareaPageState();
}

class _AgregarTareaPageState extends State<AgregarTareaPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _descripcion = '';
  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  // bool _notificar = false;
 
  @override
  void initState() {
    super.initState();
    // Si estamos editando una tarea, inicializamos los campos con sus valores.
    if (widget.tarea != null) {
      _nombre = widget.tarea!['nombre'];
      _descripcion = widget.tarea!['descripcion'];
      _fecha = DateTime.parse(widget.tarea!['fecha']);
      _hora = TimeOfDay(hour: int.parse(widget.tarea!['hora'].split(":")[0]), minute: int.parse(widget.tarea!['hora'].split(":")[1]));
      // _notificar = widget.tarea!['notificacionId'] != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tarea == null ? 'Agregar Tarea' : 'Editar Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _nombre = value;
                      });
                    },
                    initialValue: _nombre,
                  ),
                  TextFormField(
                    initialValue: _descripcion,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) {
                      setState(() {
                        _descripcion = value;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Fecha: ${_fecha.toLocal()}'.split(' ')[0]),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ListTile(
                    title: Text('Hora: ${_hora.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                  /* Row(
                    children: [
                      const Text('Notificarme'),
                      Switch(
                        value: _notificar,
                        onChanged: (value) {
                          setState(() {
                            _notificar = value;
                          });
                        },
                      )
                    ],
                    ), */
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _agregarTarea(context),
                    child: const Text('Guardar Tarea'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
 

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101),
      );
      if(picked != null && picked != _fecha){
        setState(() {
          _fecha = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _hora,
    );
    if (picked != null && picked != _hora) {
      setState(() {
        _hora = picked;
      });
    }
  }

void _agregarTarea(BuildContext context) {
  if(_formKey.currentState!.validate()) {
    final tarea = {
      'nombre': _nombre,
      'descripcion': _descripcion,
      'fecha': _fecha.toIso8601String(),
      'hora': _formatHora(_hora),
    };

    /* if(_notificar){
      _programarNotificacion(tarea);
    }*/

    widget.onTareaAgregada(tarea);

    Navigator.pop(context);
    }
  }


String _formatHora(TimeOfDay hora){
  return "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}"; 
}

   Future<void> _programarNotificacion(Map<String, dynamic> tarea) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final notificationId = tarea['id'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final scheduledNotificationDateTime = DateTime(
      _fecha.year,
      _fecha.month,
      _fecha.day,
      _hora.hour,
      _hora.minute,
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high
    );
    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      notificationId,
      tarea['nombre'],
      tarea['descripcion'],
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );

    tarea['notificacionId'] = notificationId;
  }
  
}