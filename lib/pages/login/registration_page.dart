import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
    );
  }
}
