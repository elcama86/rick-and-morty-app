import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void goToPage(BuildContext context, String route, String element) {
    Navigator.of(context).pushNamed(
      route,
      arguments: ScreenArguments(title: element),
    );
  }

  Widget _options(
      BuildContext context, String assetName, String element, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () => goToPage(context, route, element),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(assetName),
              radius: 100.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  element,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 8.0,
          ),
          _options(
            context,
            "assets/images/all_characters.webp",
            "Personajes",
            "/characters",
          ),
          const SizedBox(
            height: 8.0,
          ),
          _options(
            context,
            "assets/images/episodes.jpg",
            "Episodios",
            "/episodes",
          ),
          const SizedBox(
            height: 8.0,
          ),
          _options(
            context,
            "assets/images/character.jpg",
            "Búsqueda por personaje",
            "/character",
          ),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty App"),
      ),
      body: _body(context),
    );
  }
}

class ScreenArguments {
  final String title;

  ScreenArguments({required this.title});
}
