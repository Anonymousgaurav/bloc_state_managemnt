import 'package:bloc/bloc.dart';
import 'package:bloc_state_managment/main.dart';
import 'package:bloc_state_managment/models/FetchResult.dart';
import 'package:bloc_state_managment/models/Person.dart';
import 'package:bloc_state_managment/network/impl/LoadPersonApiImpl.dart';
import 'package:bloc_state_managment/network/repo/LoadActionRepo.dart';

class PersonsBloc extends Bloc<LoadActionRepo, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonApiImpl>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // we have the value in the cache
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          final persons = await getPersons(url.urlString);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
