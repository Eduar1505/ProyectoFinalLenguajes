import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 100, color: Colors.blue,),
            SizedBox(height: 20,),
            Text('MiAgenda', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
          ]
        ),
      ),
    );
  }
}