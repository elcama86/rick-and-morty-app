import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty_app/bloc/characters/characters_bloc.dart';
import 'package:rickandmorty_app/bloc/episodes/episodes_bloc.dart';
import 'package:rickandmorty_app/pages/character.dart';
import 'package:rickandmorty_app/pages/all_characters.dart';
import 'package:rickandmorty_app/pages/episodes.dart';
import 'package:rickandmorty_app/pages/home_page.dart';

Future main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Future.delayed(const Duration(seconds: 4));
  // FlutterNativeSplash.remove();
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
          "/characters": (context) => const AllCharacters(),
          "/episodes": (context) => const Episodes(),
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
