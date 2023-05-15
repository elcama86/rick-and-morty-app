import 'package:bloc/bloc.dart';
import 'package:rickandmorty_app/models/character.dart';
import 'package:flutter/material.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  static CharactersBloc? _instance;
  static CharactersBloc get instance{
    _instance ??= CharactersBloc();
    return _instance!;
  }
  CharactersBloc() : super(const CharactersInitialState()) {
    on<SetCharacters>(
        (event, emit) => emit(CharactersSetState(event.characters)));
    
    on<AddNewCharacters>((event, emit){
      final List<Result> results = [...state.characters!.results, ...event.results];
      emit(CharactersSetState(state.characters!.copyWith(info: event.info, results: results)));
    });
  }
}
