import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  LoginPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextField(
                controller : emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electronico',
                  hintText: 'Ingresa tu correo institucional',
                  ),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (){
                  String email = emailController.text.trim();

                  if ( email.endsWith('@unah.hn')){
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, ingresa un correo institucional valido.')),
                    );
                  }
                }, 
                child: const Text('Iniciar Sesion'))
            ],
          ),
      ),
    );
  }
}