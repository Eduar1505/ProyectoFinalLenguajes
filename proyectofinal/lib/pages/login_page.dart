import 'package:flutter/material.dart';
import 'package:proyectofinal/componentes/login_textfield.dart';
import 'package:proyectofinal/componentes/my_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  // Texto
  final usernameController = TextEditingController();
  final paswordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 125,
              ),
              const Icon(
                Icons.person,
                size: 100,
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                'Bienvenido a Tarea Login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // Username o correo TextField
              MyTextField(
                controller: usernameController,
                hintText: 'Correo Institucional',
                obscureText: false,
              ),

              const SizedBox(
                height: 15,
              ),

              // Contraseña TextField
              MyTextField(
                controller: paswordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 187, 185, 185),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(
                height: 25,
              ),

              // todo debe ir dentro de children
            ],
          ),
        ),
      ),
    );
  }
}
