import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateService extends StatefulWidget {
  const CreateService({Key? key}) : super(key: key);

  @override
  State<CreateService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController chargesController = TextEditingController();
  bool _validateTitle = false;
  bool _validateDesc = false;
  bool _validateCharges = false;
  String dropdownvalue = 'CAT';
  bool _isButtonDisabled = false;

  var items = [
    'CAT',
    'DOG',
    'RABBIT',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    chargesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Create Service",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            const Center(
              child: Text("Add Services which you offered to customer"),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Title',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w200),
                  errorText: _validateTitle ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w200),
                  errorText: _validateDesc ? "Value Can\'t be empty" : null,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Pet Type',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: DropdownButton(
                // Initial Value
                value: dropdownvalue,
                style: TextStyle(color: Colors.black),
                // Down Arrow Icon
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'Charges',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: chargesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Charges',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w200),
                  errorText: _validateCharges ? "Value Can\'t be empty" : null,
                ),
              ),
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
                        if (titleController.text.isNotEmpty &&
                            descController.text.isNotEmpty &&
                            chargesController.text.isNotEmpty) {
                          createDoctorService(
                              titleController.text,
                              descController.text,
                              dropdownvalue,
                              chargesController.text).then((value) => {
                                Navigator.popAndPushNamed(context, '/services')
                          });
                        } else {
                          setState(() {
                            _isButtonDisabled=false;
                            titleController.text.isEmpty
                                ? _validateTitle = true
                                : _validateTitle = false;
                            descController.text.isEmpty
                                ? _validateDesc = true
                                : _validateDesc = false;
                            chargesController.text.isEmpty
                                ? _validateCharges = true
                                : _validateCharges = false;
                          });
                        }
                      },
                child: const Text("Create"),
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

Future<int> createDoctorService(
    String title, String desc, String pet_type, String charges) async {

  //TODO: get doctor_id from shared preference.
  final response = await http.post(
    Uri.parse('http://3.14.153.182:8000/Doctor_service_api/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "fk_doctor": "102",
      "title": title,
      "description": desc,
      "pet_type": pet_type,
      "charges": charges
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)["service_id"];
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to Login.');
  }
}
