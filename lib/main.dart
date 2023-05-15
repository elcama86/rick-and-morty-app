import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty_app/bloc/characters/characters_bloc.dart';
import 'package:rickandmorty_app/bloc/episodes/episodes_bloc.dart';
import 'package:rickandmorty_app/pages/character.dart';
import 'package:rickandmorty_app/pages/home_page.dart';
import 'package:rickandmorty_app/pages/main_list.dart';

Future main() async{
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersBloc>(
          create: (_) => CharactersBloc.instance,
        ),
        BlocProvider<EpisodesBloc>(
          create: (_) => EpisodesBloc.instance,
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty App',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const HomePage(),
          "/characters": (context) => const MainList(isCharacters: true,),
          "/episodes": (context) => const MainList(isCharacters: false,),
          "/character": (context) => const Character(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
