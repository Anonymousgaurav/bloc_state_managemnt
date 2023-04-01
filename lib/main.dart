import 'dart:convert';
import 'dart:io';

import 'package:bloc_state_managment/business/bloc/PersonsBloc.dart';
import 'package:bloc_state_managment/models/FetchResult.dart';
import 'package:bloc_state_managment/models/Person.dart';
import 'package:bloc_state_managment/network/impl/LoadPersonApiImpl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage(),
      ),
    ),
  );
}

enum PersonUrl { persons1, persons2 }

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return "http://127.0.0.1:5500/api/persons1.json";

      case PersonUrl.persons2:
        return "http://127.0.0.1:5500/api/persons2.json";
    }
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(
                          const LoadPersonApiImpl(
                            url: PersonUrl.persons1,
                          ),
                        );
                  },
                  child: const Text(
                    'Load json #1',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(
                          const LoadPersonApiImpl(
                            url: PersonUrl.persons2,
                          ),
                        );
                  },
                  child: const Text(
                    'Load json #2',
                  ),
                ),
              ],
            ),
            BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
                return previousResult?.persons != currentResult?.persons;
              },
              builder: ((context, fetchResult) {
                /// fetchResult?.log();
                final persons = fetchResult?.persons;
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ));
  }
}
