import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheel/controllers/spin_wheel_controller.dart';
import 'package:spin_wheel/screens/spin_wheel_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpinWheelController(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SpinWheelScreen(),
      ),
    );
  }
}
