import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aplicacion_api/Pokemones/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.white, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      home: const MyHomePage(title: 'Pokedex'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => pantalla_Inicial_pokedex();
}

class pantalla_Inicial_pokedex extends State<MyHomePage> {
  late Future<List<dynamic>> _datosdelPokemon;
  List<dynamic> listapokemones = [];
  List<dynamic> pokemonesencontrados = [];
  final List<Map<String, dynamic>> tiposPokemon = [
    {'nombre': 'fire', 'color': Colors.orange},
    {'nombre': 'water', 'color': Colors.blue},
    {'nombre': 'grass', 'color': Colors.green},
    {'nombre': 'electric', 'color': Colors.yellow},
    {'nombre': 'psychic', 'color': Colors.deepPurple},
    {'nombre': 'ice', 'color': Colors.cyan},
    {'nombre': 'dragon', 'color': Colors.indigoAccent},
    {'nombre': 'dark', 'color': Colors.brown},
    {'nombre': 'fairy', 'color': Colors.pinkAccent},
    {'nombre': 'poison', 'color': Colors.deepPurpleAccent},
    {'nombre': 'ground', 'color': Colors.brown.shade300},
    {'nombre': 'flying', 'color': Colors.blueGrey},
    {'nombre': 'bug', 'color': Colors.lightGreenAccent},
    {'nombre': 'rock', 'color': Colors.grey.shade500},
    {'nombre': 'ghost', 'color': Colors.deepPurple.shade400},
    {'nombre': 'steel', 'color': Colors.blueGrey.shade300},
    {'nombre': 'fighting', 'color': Colors.red.shade800},
    {'nombre': 'normal', 'color': Colors.grey.shade400},
  ];

  String? Tiposeleccionado;
  int selec_opcion = 0;

  @override
  void initState() {
    super.initState();
    _datosdelPokemon = ObtenerlistapokemonesRaw().then((data) {
      listapokemones = data;
      pokemonesencontrados = data;
      return data;
    });
  }

  Future<List<dynamic>> ObtenerlistapokemonesRaw() async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon?limit=220&offset=0',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dataPokemones = jsonDecode(response.body);
      return dataPokemones['results'];
    } else {
      throw Exception('error al cargar la aplicacion');
    }
  }

  List<Widget> _getpantallaspokedex() {
    return [_pantallapokedex(), _pantallabusqueda()];
  }

  Widget _pantallapokedex() {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _datosdelPokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(30),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: snapshot.data!.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final nombre_pokemon = snapshot.data![index]['name'];

                return Container(
                  key: ValueKey(nombre_pokemon),
                  child: FutureBuilder<Pokemon>(
                    future: Pokemon.fetch(nombre_pokemon),
                    builder: (context, pokemonsnapshot) {
                      if (pokemonsnapshot.hasData) {
                        return PokemonCard(pokemon: pokemonsnapshot.data!);
                      } else if (pokemonsnapshot.hasError) {
                        return Container(
                          height: 150,
                          color: Colors.redAccent,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _pantallabusqueda() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Tipos de pokemon',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Expanded(child: _TiposPokemon()),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: pokemonesencontrados.length,
            itemBuilder: (context, index) {
              final nombre = pokemonesencontrados[index]['name'];
              return FutureBuilder<Pokemon>(
                future: Pokemon.fetch(nombre),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PokemonCard(pokemon: snapshot.data!);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _TiposPokemon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: Tiposeleccionado,
        hint: const Text('Selecciona un tipo'),
        isExpanded: true,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.red),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('Todos', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...tiposPokemon.map((tipo) {
            return DropdownMenuItem<String>(
              value: tipo['nombre'],
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: tipo['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tipo['nombre'].toUpperCase(),
                    style: TextStyle(color: tipo['color']),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
        onChanged: (String? nuevoTipo) {
          if (nuevoTipo == null) {
            mostrarTodos();
          } else {
            filtrarPorTipo(nuevoTipo);
          }
        },
      ),
    );
  }

  void mostrarTodos() {
    setState(() {
      Tiposeleccionado = null;
      pokemonesencontrados = listapokemones;
    });
  }

  void filtrarPorTipo(String tipo) async {
    setState(() {
      Tiposeleccionado = tipo;
      pokemonesencontrados = [];
    });

    List<dynamic> pokemonsFiltrados = [];
    List<Future> resultadospokemones = [];

    for (var pokemonData in listapokemones) {
      var resultadopokemon = Pokemon.fetch(pokemonData['name'])
          .then((pokemon) {
            if (pokemon.tipo == tipo) {
              pokemonsFiltrados.add(pokemonData);
            }
          })
          .catchError((e) {
            print('error al cargar ${pokemonData['name']}: $e');
          });
      resultadospokemones.add(resultadopokemon);
    }

    await Future.wait(resultadospokemones);

    if (mounted) {
      setState(() {
        pokemonesencontrados = pokemonsFiltrados;
      });
    }
  }

  void filtrarpokemon(String Textobusqueda) {
    setState(() {
      if (Textobusqueda.isEmpty) {
        pokemonesencontrados = listapokemones;
      } else {
        pokemonesencontrados = listapokemones.where((pokemon) {
          final nombre = pokemon['name'];
          return nombre.toLowerCase().contains(Textobusqueda.toLowerCase());
        }).toList();
      }
    });
  }

  void _clickopcion(int index) {
    setState(() {
      selec_opcion = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.red),
      body: _getpantallaspokedex()[selec_opcion],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selec_opcion,
        onTap: _clickopcion,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokedex',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        ],
      ),
    );
  }
}
