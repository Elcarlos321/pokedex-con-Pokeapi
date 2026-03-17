import 'package:flutter/material.dart';
import 'package:aplicacion_api/Pokemones/pokemon.dart';

class ventana_pokemon_detalle extends StatelessWidget {
  final Pokemon pokemon;

  const ventana_pokemon_detalle({super.key, required this.pokemon});

  Color _getTypeColor() {
    switch (pokemon.tipo) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow;
      case 'psychic':
        return Colors.deepPurple;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigoAccent;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pinkAccent;
      case 'poison':
        return Colors.deepPurpleAccent;
      case 'ground':
        return Colors.brown.shade300;
      case 'flying':
        return Colors.blueGrey;
      case 'bug':
        return Colors.lightGreenAccent;
      case 'rock':
        return Colors.grey.shade500;
      case 'ghost':
        return Colors.deepPurple.shade400;
      case 'steel':
        return Colors.blueGrey.shade300;
      case 'fighting':
        return Colors.red.shade800;
      case 'normal':
        return Colors.grey.shade400;
      default:
        return Colors.red;
    }
  }

  Widget _datospokemon(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _EstadisticasPokemon(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadisticas del pokemon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),

            _buildEstadistica(context, 'Hp', pokemon.hp, Colors.red, 255),
            const SizedBox(height: 8),

            _buildEstadistica(
              context,
              'Ataque',
              pokemon.hp,
              Colors.orange,
              255,
            ),
            const SizedBox(height: 8),

            _buildEstadistica(
              context,
              'Defensa',
              pokemon.hp,
              Colors.blueAccent,
              255,
            ),
            const SizedBox(height: 8),

            _buildEstadistica(
              context,
              'At. especial',
              pokemon.hp,
              Colors.purple,
              255,
            ),
            const SizedBox(height: 8),

            _buildEstadistica(
              context,
              'Df. especial',
              pokemon.hp,
              Colors.indigo,
              255,
            ),
            const SizedBox(height: 8),

            _buildEstadistica(
              context,
              'Velocidad',
              pokemon.hp,
              Colors.green,
              255,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadistica(
    BuildContext context,
    label,
    int value,
    Color color,
    int maxValue,
  ) {
    double porcentaje = value / maxValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: MediaQuery.of(context).size.width * 0.6 * porcentaje,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemon_tipo_colors = _getTypeColor();
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nombre_pokemonURL.toUpperCase()),
        backgroundColor: pokemon_tipo_colors,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pokemon_tipo_colors.withAlpha(77), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: pokemon_tipo_colors.withAlpha(77),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            pokemon.imagen,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          pokemon.nombre_pokemonURL.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: pokemon_tipo_colors,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pokemon.tipo.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _datospokemon(
                          'Peso',
                          '${pokemon.peso} Kg',
                          Icons.monitor_weight,
                        ),
                        const Divider(),
                        _datospokemon(
                          'Altura',
                          '${pokemon.altura} m',
                          Icons.height,
                        ),
                        const Divider(),
                        _datospokemon(
                          'habilidad',
                          '${pokemon.habilidad}',
                          Icons.bolt,
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _EstadisticasPokemon(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
