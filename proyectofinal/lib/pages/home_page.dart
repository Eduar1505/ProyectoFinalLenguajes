// ignore_for_file: constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:proyectofinal/db/db_helper.dart';
import 'package:proyectofinal/pages/agregar_tarea.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _tareas = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
    _cargarTareas();
  }

  void _intializeNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
  }

  void _cargarTareas() async {
    final tareas = await DBHelper().obtenerTarea();
    setState(() {
      _tareas = tareas;
    });
  }

  void _agregarTarea(Map<String, dynamic> tarea) async {
    await DBHelper().insertarTarea(tarea);
    _scheduleNotification(tarea);
    _cargarTareas();
  }

  void _editarTarea(Map<String, dynamic> tarea) async {
    await DBHelper().actualizarTarea(tarea);
    _scheduleNotification(tarea);
    _cargarTareas();
  }

  void _eliminarTarea(int id) async {
    final tarea = _tareas.firstWhere((element) => element['id'] == id);
    await _cancelNotification(tarea['notificationId']);
    await DBHelper().eliminarTarea(id);
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario'),),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return ListTile(
                  title: Text(tarea['nombre']),
                  subtitle: Text(
                    'Fecha: ${DateTime.parse(tarea['fecha']).toLocal()} \nHora: ${tarea['hora']}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final tareaEditada = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgregarTareaPage(
                                tarea: tarea,
                                onTareaAgregada: (tareaEditada) async {
                                  _editarTarea(tareaEditada);
                                },
                              ),
                            ),
                          );
                          if (tareaEditada != null) {
                            _editarTarea(tareaEditada);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _eliminarTarea(tarea['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevaTarea = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarTareaPage(
                onTareaAgregada: (tarea) async {
                  _agregarTarea(tarea);
                },
              ),
            ),
          );
          if (nuevaTarea != null) {
            _agregarTarea(nuevaTarea);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _scheduleNotification(Map<String, dynamic> tarea) async {
    final notificationId = tarea['id'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final scheduledNotificationDateTime = DateTime.parse(tarea['fecha']).add(
      Duration(
        hours: int.parse(tarea['hora'].split(":")[0]),
        minutes: int.parse(tarea['hora'].split(":")[1]), 
        ),
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your chanel name',
        channelDescription: 'your chanel description',
    );

    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await _flutterLocalNotificationsPlugin.schedule(
      notificationId,
      tarea['nombre'], 
      tarea['descripcion'], 
      scheduledNotificationDateTime, 
      platformChannelSpecifics,
      );

      if(tarea['id'] == null){
        tarea['notificationId'] = notificationId;
        await DBHelper().actualizarTarea(tarea);
      }
  }

      Future<void> _cancelNotification(int? notificacionId) async {
        if (notificacionId != null) {
          await _flutterLocalNotificationsPlugin.cancel(notificacionId);
        }
      }




}
