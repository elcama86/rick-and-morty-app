part of 'characters_bloc.dart';

@immutable
abstract class CharactersState {
  final CharacterResponse? characters;

  const CharactersState({
    this.characters,
  });
}

class CharactersInitialState extends CharactersState {
  const CharactersInitialState()
      : super(
          characters: null,
        );
}

class CharactersSetState extends CharactersState {
  final CharacterResponse newCharacter;

  const CharactersSetState(this.newCharacter)
      : super(
          characters: newCharacter,
        );
}
