import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _validateUserName = false;
  bool _validatePassword = false;
  bool _validatePhone = false;
  bool _isButtonDisabled = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black,),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Enter your details information',
                  style: TextStyle(fontSize: 15,),
                )),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Name*',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validateUserName ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Password*',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                obscuringCharacter: "*",
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validatePassword ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Mobile Number*',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validatePhone ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.where_to_vote_outlined,color: Colors.red,),
              title: Text("I have accepted Terms & Condition"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                  if (userNameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    createDoctorAccount(
                        userNameController.text,
                        passwordController.text,
                        phoneController.text).then((value) => {
                      Navigator.popAndPushNamed(context, '/otp_screen',arguments: value)
                    });
                  } else {
                    setState(() {
                      _isButtonDisabled=false;
                      userNameController.text.isEmpty
                          ? _validateUserName = true
                          : _validateUserName = false;
                      passwordController.text.isEmpty
                          ? _validatePassword = true
                          : _validatePassword = false;
                      phoneController.text.isEmpty
                          ? _validatePhone = true
                          : _validatePhone = false;
                    });
                  }
                },
                child: const Text("Register"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.red)))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(30,10,30,10),
              child: Divider(
                thickness: 2.0,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(FontAwesomeIcons.google,size: 30.0,), onPressed: () {  },),
                IconButton(icon: Icon(FontAwesomeIcons.facebook,size: 30.0,), onPressed: () {  },),
                IconButton(icon: Icon(FontAwesomeIcons.apple,size: 30.0,), onPressed: () {  },),

              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<String> createDoctorAccount(String username,String password,String phone_no) async {

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString("user_name", username);
  await sharedPreferences.setString("password", password);
  await sharedPreferences.setString("mobile_no", phone_no);

  final response = await http.post(
    Uri.parse('http://3.14.153.182:8000/Doctor_Signup_api/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "mobile_no": phone_no,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)["mobile_otp"];
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to Login.');
  }
}