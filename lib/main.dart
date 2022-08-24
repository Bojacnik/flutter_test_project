import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.deepPurple.shade700,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple.shade400,
          secondary: Colors.deepPurple.shade300,
          shadow: Colors.deepPurple.shade100,
          background: Colors.deepPurple.shade700,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
