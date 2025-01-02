import 'package:albums/locator.dart';
import 'package:albums/screens/about.dart';
import 'package:albums/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '1001 Albums',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white //here you can give the text color
            ),
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        AboutPage.routeName: (BuildContext context) => const AboutPage(),
      },
    );
  }
}
