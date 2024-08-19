import 'package:flutter/material.dart';
import 'package:proyectofinal/pages/calendar_page.dart';
import 'package:proyectofinal/pages/notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const NotesPage(),
    const CalendarPage(),
  ];
  
  // ignore: unused_element
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MiAgenda'),),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendaio',
              )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        ),
    );
  }
  
}
