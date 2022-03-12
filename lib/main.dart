import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Data> fetchData() async {
    final response = await http.get(Uri.parse('https://catfact.ninja/fact'));

    if (response.statusCode == 200) {
      return Data.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  /*
  Future<Pic> fetchPic() async {
    final response =
        await http.get(Uri.parse('https://placekitten.com/200/300'));

    if (response.statusCode == 200) {
      return Data.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
*/
  late Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    futureData = fetchData();
                  });
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(parent: null),
              child: FutureBuilder<Data>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Text(snapshot.data!.fact),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} \n an error happend',
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ));
  }
}

class Data {
  final String fact;

  const Data({
    required this.fact,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      fact: json['fact'],
    );
  }
}
