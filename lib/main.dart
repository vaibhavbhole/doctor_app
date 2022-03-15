import 'package:doctor_app/services/create_service.dart';
import 'package:doctor_app/services/services.dart';
import 'package:doctor_app/signup/create_account.dart';
import 'package:doctor_app/signup/create_profile.dart';
import 'package:doctor_app/signup/otp_screen.dart';
import 'package:doctor_app/signup/shift_availability.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'App Home Page'),
        '/signup': (context) => CreateAccount(),
        '/services': (context) => Services(),
        '/createservice' : (context) => CreateService(),
        '/otp_screen' : (context) => OtpScreen(),
        '/create_profile' : (context) => CreateProfile(),
        '/shift_availability': (context) => ShiftAvailability(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Sign Up"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueGrey)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/services');
                },
                child: const Text("Create Service"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueGrey)))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
