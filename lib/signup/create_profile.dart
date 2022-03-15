import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  bool _validateEmail = false;
  bool _isButtonDisabled = false;


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    aboutMeController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    super.dispose();
  }
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
                  'Create Your Profile',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 15,
            ),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blueGrey,
              child: const Text('Upload Profile Picture'),
            ),
            SizedBox(height: 15,),
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
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Email',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validateEmail ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'About Me',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Business Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: businessNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Business Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: businessAddressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Click Here to select Location',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                  if (emailController.text.isNotEmpty) {
                    saveProfileInfo(
                        nameController.text,
                        emailController.text,
                        aboutMeController.text,
                    businessNameController.text,businessAddressController.text).then((value) => {
                      Navigator.pushNamed(context, '/shift_availability')
                    });
                  } else {
                    setState(() {
                      _isButtonDisabled=false;
                      emailController.text.isEmpty
                          ? _validateEmail = true
                          : _validateEmail = false;
                    });
                  }
                },
                child: const Text("Next"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.red)))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> saveProfileInfo(String name,String email,String aboutMe,String businessName,String businessAddress) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString("name", name);
  await sharedPreferences.setString("email", email);
  await sharedPreferences.setString("about_me", aboutMe);
  await sharedPreferences.setString("bussiness_name", aboutMe);
  await sharedPreferences.setString("bussiness_address", aboutMe);
  return true;
}
