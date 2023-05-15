part of 'characters_bloc.dart';

@immutable
abstract class CharactersEvent {}

class SetCharacters extends CharactersEvent {
  final CharacterResponse characters;

  SetCharacters(this.characters);
}

class AddNewCharacters extends CharactersEvent {
  final Info info;
  final List<Result> results;

  AddNewCharacters(
    this.info,
    this.results,
  );
}
