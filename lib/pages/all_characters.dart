import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rickandmorty_app/bloc/characters/characters_bloc.dart';
import 'package:rickandmorty_app/components/custom_list.dart';
import 'package:rickandmorty_app/components/loading.dart';
import 'package:rickandmorty_app/components/text_message.dart';
import 'package:rickandmorty_app/models/character.dart';
import 'package:rickandmorty_app/pages/home_page.dart';
import 'package:rickandmorty_app/utils/global_utils.dart';

class AllCharacters extends StatefulWidget {
  const AllCharacters({Key? key}) : super(key: key);

  @override
  State<AllCharacters> createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters> with GlobalUtils {
  String initialUrl = 'https://rickandmortyapi.com/api/character/';

  bool isPageLoading = false;
  bool isFinalPage = false;
  bool isLoading = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (CharactersBloc.instance.state.characters == null) {
      isLoading = true;
      getData(initialUrl).then((data) {
        if (data != null) {
          CharacterResponse characters = CharacterResponse.fromJson(data);
          CharactersBloc.instance.add(SetCharacters(characters));
        }
        setState(() {
          isLoading = false;
        });
      });
    } else {
      isFinalPage = CharactersBloc.instance.state.characters!.info.next == null
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
        CharacterResponse characters = CharacterResponse.fromJson(data);
        if (getCurrentPage(url) == characters.info.pages!) isFinalPage = true;
        CharactersBloc.instance
            .add(AddNewCharacters(characters.info, characters.results));
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
      loadMore(CharactersBloc.instance.state.characters!.info.next!);
    }
    return isFinalPage;
  }

  Widget _body() {
    return BlocBuilder<CharactersBloc, CharactersState>(
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
