import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplicacion_api/Pokemones/pokemon_detalles.dart';

class Pokemon {
  final String nombre_pokemonURL;
  final String imagen;
  final String tipo;
  final double altura;
  final double peso;
  final String habilidad;

  final int hp;
  final int ataque;
  final int defensa;
  final int ataqueEspecial;
  final int defensaEspecial;
  final int velocidad;

  Pokemon({
    required this.nombre_pokemonURL,
    required this.imagen,
    required this.tipo,
    required this.altura,
    required this.peso,
    required this.habilidad,
    required this.hp,
    required this.ataque,
    required this.defensa,
    required this.ataqueEspecial,
    required this.defensaEspecial,
    required this.velocidad,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    int getEstadisticas(String statName) {
      try {
        return json['stats'].firstWhere(
          (stat) => stat['stat']['name'] == statName,
        )['base_stat'];
      } catch (e) {
        return 0;
      }
    }

    return Pokemon(
      nombre_pokemonURL: json['name'],
      imagen: json['sprites']['front_default'],
      tipo: json['types'][0]['type']['name'],
      altura: json['height'] / 10,
      peso: json['weight'] / 10,
      habilidad: json['abilities'][0]['ability']['name'],
      hp: getEstadisticas('hp'),
      ataque: getEstadisticas('attack'),
      defensa: getEstadisticas('defense'),
      ataqueEspecial: getEstadisticas('special-attack'),
      defensaEspecial: getEstadisticas('special-defense'),
      velocidad: getEstadisticas('speed'),
    );
  }

  static Future<Pokemon> fetch(String name) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Pokemon.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'El pokemon no ha sido encontrado error(${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ventana_pokemon_detalle(pokemon: pokemon),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Image.network(
              pokemon.imagen,
              width: 190,
              height: 190,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
