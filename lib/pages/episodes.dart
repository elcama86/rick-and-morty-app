import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rickandmorty_app/bloc/episodes/episodes_bloc.dart';
import 'package:rickandmorty_app/components/custom_list.dart';
import 'package:rickandmorty_app/components/loading.dart';
import 'package:rickandmorty_app/components/text_message.dart';
import 'package:rickandmorty_app/models/episode.dart';
import 'package:rickandmorty_app/pages/home_page.dart';
import 'package:rickandmorty_app/utils/global_utils.dart';

class Episodes extends StatefulWidget {
  const Episodes({Key? key}) : super(key: key);

  @override
  State<Episodes> createState() => _EpisodesState();
}

class _EpisodesState extends State<Episodes> with GlobalUtils {
  String initialUrl = 'https://rickandmortyapi.com/api/episode/';

  bool isPageLoading = false;
  bool isFinalPage = false;
  bool isLoading = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (EpisodesBloc.instance.state.episodes == null) {
      isLoading = true;
      getData(initialUrl).then((data) {
        if (data != null) {
          EpisodeResponse episodes = EpisodeResponse.fromJson(data);
          EpisodesBloc.instance.add(SetEpisodes(episodes));
        }
        setState(() {
          isLoading = false;
        });
      });
    } else {
      isFinalPage = EpisodesBloc.instance.state.episodes!.info.next == null
          ? true
          : false;
    }
  }

  void loadMore(String url) async {
    setState(() {
      isPageLoading = true;
    });
    getData(url).then((data) {
      if (data != null) {
        EpisodeResponse episodes = EpisodeResponse.fromJson(data);
        if (getCurrentPage(url) == episodes.info.pages!) isFinalPage = true;
        EpisodesBloc.instance
            .add(AddNewEpisodes(episodes.info, episodes.results));
      }

      setState(() {
        isPageLoading = false;
      });
    });
  }

  bool _onNotificationScroller(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
        !isFinalPage &&
        scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !isPageLoading) {
      loadMore(EpisodesBloc.instance.state.episodes!.info.next!);
    }
    return isFinalPage;
  }

  Widget _body() {
    return BlocBuilder<EpisodesBloc, EpisodesState>(
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
