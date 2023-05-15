part of 'episodes_bloc.dart';

@immutable
abstract class EpisodesState{
  final EpisodeResponse? episodes;

  const EpisodesState({this.episodes,});
}

class EpisodesInitialState extends EpisodesState {
  const EpisodesInitialState()
      : super(
          episodes: null,
        );
}

class EpisodesSetState extends EpisodesState {
  final EpisodeResponse newEpisode;

  const EpisodesSetState(this.newEpisode)
      : super(
          episodes: newEpisode,
        );
}