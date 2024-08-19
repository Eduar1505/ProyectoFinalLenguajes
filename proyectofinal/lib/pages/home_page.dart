import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      
      body: const Center(
        child: Text('Aqui ira el calendario.'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){

          },
          child: const Icon(Icons.add),
          ),
    );
  }
}
