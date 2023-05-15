part of 'episodes_bloc.dart';

@immutable
abstract class EpisodesEvent {}

class SetEpisodes extends EpisodesEvent {
  final EpisodeResponse episodes;

  SetEpisodes(this.episodes);
}

class AddNewEpisodes extends EpisodesEvent {
  final Info info;
  final List<Result> results;

  AddNewEpisodes(
    this.info,
    this.results,
  );
}