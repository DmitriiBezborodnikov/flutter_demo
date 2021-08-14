import "package:flutter/material.dart";
import 'package:myapp/HomePage.dart';
import 'package:myapp/ImagesStorage.dart';
import 'Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var phone = prefs.getString('phone');

  runApp(MaterialApp(
    initialRoute: phone == null ? '/login' : '/home',
    routes: <String, WidgetBuilder> {
      '/login': (BuildContext context) => new LoginPage(),
      '/home': (BuildContext context) => new HomePage(storage: ImagesStorage(),),
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: LoginPage());
  }
}