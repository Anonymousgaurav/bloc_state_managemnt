import 'package:bloc_state_managment/models/Person.dart';
import 'package:flutter/material.dart';

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });
}
