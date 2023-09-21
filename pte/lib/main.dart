import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'connect/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTE',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Login(),
        ),
      ),
    );
  }
}


