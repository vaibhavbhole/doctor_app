import 'dart:convert';

import 'package:doctor_app/services/model/service_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Manage Services",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/createservice');
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<ServiceItem>>(
          future: getServices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getList(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  ListView getList(List<ServiceItem> list) {
    return ListView.builder(
      itemBuilder: (buildContext, index) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            title: Text(list[index].title,
            style: const TextStyle(color: Colors.red),),
            subtitle: Row(
              children: [
                Expanded(child: Text(list[index].description)),
                Text(list[index].charges),
              ],
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}

Future<List<ServiceItem>> getServices() async {
  //TODO: add doctor id from shared preference.
  final response = await http.post(
    Uri.parse('http://3.14.153.182:8000/get_manage_service_api/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{"fk_doctor": "102"}),
  );

  if (response.statusCode == 200) {

    final List<ServiceItem> list = jsonDecode(response.body)["Service List"]
         .map<ServiceItem>((data) => ServiceItem.fromJson(data))
         .toList();

    return list;
  } else {
    throw Exception('Failed to Fetch Services.');
  }
}
