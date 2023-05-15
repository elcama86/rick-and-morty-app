import 'package:bloc/bloc.dart';
import 'package:rickandmorty_app/models/episode.dart';
import 'package:flutter/material.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  static EpisodesBloc? _instance;
  static EpisodesBloc get instance{
    _instance ??= EpisodesBloc();
    return _instance!;
  }
  EpisodesBloc() : super(const EpisodesInitialState()) {
    on<SetEpisodes>(
        (event, emit) => emit(EpisodesSetState(event.episodes)));
    
    on<AddNewEpisodes>((event, emit){
      final List<Result> results = [...state.episodes!.results, ...event.results];
      emit(EpisodesSetState(state.episodes!.copyWith(info: event.info, results: results)));
    });
  }
}