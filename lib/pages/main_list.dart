import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rickandmorty_app/bloc/characters/characters_bloc.dart';
import 'package:rickandmorty_app/bloc/episodes/episodes_bloc.dart';
import 'package:rickandmorty_app/components/custom_list.dart';
import 'package:rickandmorty_app/components/loading.dart';
import 'package:rickandmorty_app/components/text_message.dart';
import 'package:rickandmorty_app/models/character.dart';
import 'package:rickandmorty_app/models/episode.dart';
import 'package:rickandmorty_app/pages/home_page.dart';
import 'package:rickandmorty_app/utils/global_utils.dart';

class MainList extends StatefulWidget {
  final bool isCharacters;
  const MainList({Key? key, required this.isCharacters}) : super(key: key);

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> with GlobalUtils {
  bool isPageLoading = false;
  bool isFinalPage = false;
  bool isLoading = false;
  late bool isCharacters;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isCharacters = widget.isCharacters;
    setData();
  }

  void checkDataResponse(dynamic data, bool isInitialData, String url) {
    if (data != null) {
      dynamic response = isCharacters
          ? CharacterResponse.fromJson(data)
          : EpisodeResponse.fromJson(data);
      if (isInitialData) {
        isCharacters
            ? CharactersBloc.instance.add(SetCharacters(response))
            : EpisodesBloc.instance.add(SetEpisodes(response));
      } else {
        if (getCurrentPage(url) == response.info.pages) isFinalPage = true;
        isCharacters
            ? CharactersBloc.instance
                .add(AddNewCharacters(response.info, response.results))
            : EpisodesBloc.instance
                .add(AddNewEpisodes(response.info, response.results));
      }
    }
  }

  void setData() {
    final dynamic list = isCharacters
        ? CharactersBloc.instance.state.characters
        : EpisodesBloc.instance.state.episodes;
    if (list == null) {
      String initialUrl = isCharacters
          ? 'https://rickandmortyapi.com/api/character/'
          : 'https://rickandmortyapi.com/api/episode/';
      isLoading = true;
      getData(initialUrl).then((data) {
        checkDataResponse(data, isLoading, initialUrl);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      isFinalPage = list.info.next == null ? true : false;
    }
  }

  void loadMore(String url) {
    setState(() {
      isPageLoading = true;
    });
    getData(url).then((data) {
      checkDataResponse(data, isLoading, url);
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
  }

  bool _onNotificationScroller(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
        !isFinalPage &&
        scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !isPageLoading) {
      String url = isCharacters
          ? CharactersBloc.instance.state.characters!.info.next!
          : EpisodesBloc.instance.state.episodes!.info.next!;
      loadMore(url);
    }
    return isFinalPage;
  }

  Widget _body() {
    return isCharacters
        ? BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              return !isLoading
                  ? state.characters != null
                      ? CustomList(
                          list: state.characters!.results,
                          onNotificationScroller: _onNotificationScroller,
                          scrollController: scrollController,
                          isPageLoading: isPageLoading,
                          firstIcon: FontAwesomeIcons.marsAndVenus,
                          secondIcon: FontAwesomeIcons.dna,
                          origin: "characters",
                          isFinalPage: isFinalPage,
                        )
                      : const TextMessage(
                          message: "No se pudieron obtener los personajes",
                        )
                  : const Loading();
            },
          )
        : BlocBuilder<EpisodesBloc, EpisodesState>(
            builder: (context, state) {
              return !isLoading
                  ? state.episodes != null
                      ? CustomList(
                          list: state.episodes!.results,
                          onNotificationScroller: _onNotificationScroller,
                          scrollController: scrollController,
                          isPageLoading: isPageLoading,
                          firstIcon: FontAwesomeIcons.calendarDay,
                          secondIcon: FontAwesomeIcons.video,
                          origin: "episodes",
                          isFinalPage: isFinalPage,
                        )
                      : const TextMessage(
                          message: "No se pudieron obtener los episodios",
                        )
                  : const Loading();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: _body(),
    );
  }
}
