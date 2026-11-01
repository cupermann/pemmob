import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/auth_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FixoraApp());
}

class FixoraApp extends StatelessWidget {
  const FixoraApp({super.key});
  @override Widget build(BuildContext context)=>MaterialApp(
    title:'Fixora Mobile',
    debugShowCheckedModeBanner:false,
    theme:Fx.theme(),
    home:const WelcomePage(),
  );
}
