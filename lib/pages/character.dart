import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rickandmorty_app/components/custom_list.dart';
import 'package:rickandmorty_app/components/loading.dart';
import 'package:rickandmorty_app/components/text_message.dart';
import 'package:rickandmorty_app/models/character.dart';
import 'package:rickandmorty_app/pages/home_page.dart';
import 'package:rickandmorty_app/utils/global_utils.dart';

class Character extends StatefulWidget {
  const Character({Key? key}) : super(key: key);

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> with GlobalUtils {
  TextEditingController searchController = TextEditingController();

  bool isSearchFieldEmpty = true;
  bool isSearching = false;

  List<Result>? searchResults;

  @override
  void initState() {
    super.initState();
    searchController.addListener(verifyField);
  }

  void verifyField() {
    if (searchController.text.isEmpty) {
      setState(() {
        isSearchFieldEmpty = true;
      });
    } else {
      setState(() {
        isSearchFieldEmpty = false;
      });
    }
  }

  void _searchCharacter() {
    setState(() {
      isSearching = true;
      searchResults = null;
    });

    String character = searchController.text;
    String searchCharacterUrl =
        "https://rickandmortyapi.com/api/character/?name=$character";

    getData(searchCharacterUrl).then((data) {
      List<Result> results = [];
      if (data != null) {
        CharacterResponse characters = CharacterResponse.fromJson(data);
        results = characters.results;
      }
      if (mounted) {
        setState(() {
          searchResults = results;
          isSearching = false;
        });
      }
    });
  }

  _clearSearchController() {
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _characterSearchResult() {
    if (searchResults!.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          Text("Se encontraron ${searchResults!.length} resultados"),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: CustomList(
              list: searchResults!,
              firstIcon: FontAwesomeIcons.marsAndVenus,
              secondIcon: FontAwesomeIcons.dna,
              origin: "characters",
            ),
          ),
        ],
      );
    } else {
      return const TextMessage(
        message: "No existen resultados para la búsqueda indicada",
      );
    }
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: TextField(
        controller: searchController,
        cursorColor: Colors.blueGrey,
        decoration: InputDecoration(
          suffixIcon: !isSearchFieldEmpty
              ? IconButton(
                  onPressed: !isSearching ? _clearSearchController : null,
                  icon: const Icon(Icons.clear),
                )
              : null,
          suffixIconColor: Colors.blueGrey,
          hintText: "Introduzca su búsqueda aquí",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.blueGrey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchButton() {
    return TextButton.icon(
      onPressed:
          isSearchFieldEmpty || isSearching ? null : () => _searchCharacter(),
      icon: const Icon(Icons.search),
      label: const Text("Buscar"),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        elevation: 5.0,
        shadowColor: Colors.black,
        disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _searchField(),
        _searchButton(),
        if (isSearching)
          const Expanded(
            child: Loading(),
          ),
        if (searchResults != null)
          Expanded(
            child: _characterSearchResult(),
          ),
      ],
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
