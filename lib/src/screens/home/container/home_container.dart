import 'package:flutter/material.dart';
import 'package:pokedex/src/error/failure.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/repo/pokemon_repo.dart';
import 'package:pokedex/src/screens/details/container/detail_container.dart';
import 'package:pokedex/src/screens/home/pages/home_error.dart';
import 'package:pokedex/src/screens/home/pages/home_loading.dart';
import 'package:pokedex/src/screens/home/pages/home_page.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
    required this.repository,
    required this.onItemTap,
  }) : super(key: key);
  final IPokemonRepository repository;
  final Function(String, DetailArguments) onItemTap;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: repository.getAllPokemons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HomeLoading();
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return HomePage(
            list: snapshot.data!,
            onItemTap: onItemTap,
          );
        }

        if (snapshot.hasError) {
          return HomeError(
            error: (snapshot.error as Failure).message!,
          );
        }

        return Container();
      },
    );
  }
}