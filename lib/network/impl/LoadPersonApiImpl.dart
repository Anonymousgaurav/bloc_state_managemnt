import 'package:bloc_state_managment/main.dart';
import 'package:bloc_state_managment/network/repo/LoadActionRepo.dart';
import 'package:flutter/material.dart';

@immutable
class LoadPersonApiImpl extends LoadActionRepo {
  final PersonUrl url;

  const LoadPersonApiImpl({required this.url}) : super();
}
