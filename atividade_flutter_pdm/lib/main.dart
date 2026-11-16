import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    title: 'Places',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      )
    ),
    home: const MyHomePage(
      title: 'Discovery',
    ),
  ));
}

class Lugar {
  final String id;
  final String nome;
  final String categoria;
  final String endereco;
  final String descricao;
  final LatLng? localizacao;
  final IconData icone;

  const Lugar({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.endereco,
    required this.descricao,
    required this.localizacao,
    required this.icone,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indicePagina = 1;
  List<Lugar> _lugaresSalvos = [];

  final List<Lugar> _lugares = const [
    Lugar(
      id: 'oxente',
      nome: 'Oxente Restobar',
      categoria: 'Bars & Hotels',
      endereco: 'Rua Álvaro Mendes, Centro',
      descricao: 'Restaurante e pizzaria na região central de Teresina.',
      localizacao: LatLng(-5.087541, -42.807425),
      icone: Icons.local_bar,
    ),
    Lugar(
      id: 'deguste',
      nome: 'Deguste Refeições',
      categoria: 'Fine Dining',
      endereco: 'Rua Desembargador Pires de Castro, 250',
      descricao: 'Restaurante de refeições no Centro de Teresina.',
      localizacao: LatLng(-5.0856941, -42.8066129),
      icone: Icons.restaurant,
    ),
    Lugar(
      id: 'cafe_paraiba',
      nome: 'Café Paraíba',
      categoria: 'Cafes',
      endereco: 'Rua Senador Teodoro Pacheco, Centro',
      descricao: 'Cafeteria na região central de Teresina.',
      localizacao: LatLng(-5.0927374, -42.8157954),
      icone: Icons.local_cafe,
    ),
    Lugar(
      id: 'cup_lanches',
      nome: 'Cup Lanches & Self-Service',
      categoria: 'Fast Foods',
      endereco: 'Rua Rui Barbosa, 36, Centro',
      descricao: 'Lanchonete e self-service no Centro de Teresina.',
      localizacao: LatLng(-5.0903028, -42.8167762),
      icone: Icons.fastfood,
    ),
    Lugar(
      id: 'sabor_brasil',
      nome: 'Sabor Brasil',
      categoria: 'Featured Foods',
      endereco: 'Rua Dezenove de Novembro, 43, Centro',
      descricao: 'Restaurante self-service de comida brasileira.',
      localizacao: LatLng(-5.086642, -42.803882),
      icone: Icons.local_pizza,
    ),
  ];

  void _alternarSalvo(Lugar lugar) {
    setState(() {
      if (_lugaresSalvos.any((item) => item.id == lugar.id)) {
        _lugaresSalvos.removeWhere((item) => item.id == lugar.id);
      } else {
        _lugaresSalvos.add(lugar);
      }
    });
  }

  void _abrirCategoria(String categoria) {
    final lugaresCategoria = _lugares
        .where((lugar) => lugar.categoria == categoria)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaLugares(
          titulo: categoria,
          lugares: lugaresCategoria,
          lugaresSalvos: _lugaresSalvos,
          onSalvar: _alternarSalvo,
          mostrarMapa: true,
        ),
      ),
    );
  }

  void _abrirNearby() {
    Navigator.push(
      context,
      MaterialPageRoute(
                builder: (context) => PaginaNearby(lugares: _lugares),
      ),
    );
  }

  Widget _construirCard(String titulo, String quantidade, IconData icone) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: () {
            _abrirCategoria(titulo);
          },
          child: SizedBox(
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icone,
                  size: 40,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quantidade,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirCardNearby() {
    return Expanded(
      child: Card(
        color: Colors.amber,
        child: InkWell(
          onTap: _abrirNearby,
          child: SizedBox(
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.place,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nearby',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '5 Places',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirDiscovery() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Explore different places',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a category to find a place',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _construirCard('Bars & Hotels', '1 place', Icons.local_bar),
                  _construirCard('Fine Dining', '1 place', Icons.restaurant),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _construirCard('Cafes', '1 place', Icons.local_cafe),
                  _construirCardNearby(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _construirCard('Fast Foods', '1 place', Icons.fastfood),
                  _construirCard('Featured Foods', '1 place', Icons.local_pizza),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirPaginaAtual() {
    if (_indicePagina == 0) {
      return PaginaHome(
        onDiscovery: () {
          setState(() {
            _indicePagina = 1;
          });
        },
        onNearby: _abrirNearby,
        lugarDestaque: _lugares[0],
        lugaresSalvos: _lugaresSalvos,
        onSalvar: _alternarSalvo,
      );
    } else if (_indicePagina == 1) {
      return _construirDiscovery();
    } else if (_indicePagina == 2) {
      return PaginaLugares(
        titulo: 'Bookmarks',
        lugares: _lugaresSalvos,
        lugaresSalvos: _lugaresSalvos,
        onSalvar: _alternarSalvo,
        onDiscovery: () {
          setState(() {
            _indicePagina = 1;
          });
        },
      );
    } else if (_indicePagina == 3) {
      return PaginaLugares(
        titulo: 'Top Places',
        lugares: _lugares,
        lugaresSalvos: _lugaresSalvos,
        onSalvar: _alternarSalvo,
        mostrarNota: true,
      );
    } else {
      return PaginaPerfil(quantidadeSalvos: _lugaresSalvos.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _construirPaginaAtual(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indicePagina,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (indice) {
          setState(() {
            _indicePagina = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Top Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PaginaLugares extends StatefulWidget {
  const PaginaLugares({
    super.key,
    required this.titulo,
    required this.lugares,
    required this.lugaresSalvos,
    required this.onSalvar,
    this.mostrarNota = false,
    this.mostrarMapa = false,
    this.onDiscovery,
  });

  final String titulo;
  final List<Lugar> lugares;
  final List<Lugar> lugaresSalvos;
  final Function(Lugar) onSalvar;
  final bool mostrarNota;
  final bool mostrarMapa;
  final VoidCallback? onDiscovery;

  @override
  State<PaginaLugares> createState() => _PaginaLugaresState();
}

class _PaginaLugaresState extends State<PaginaLugares> {
  Set<String> _salvos = {};

  @override
  void initState() {
    super.initState();
    _salvos = widget.lugaresSalvos.map((lugar) => lugar.id).toSet();
  }

  void _alternarSalvo(Lugar lugar) {
    setState(() {
      if (_salvos.contains(lugar.id)) {
        _salvos.remove(lugar.id);
      } else {
        _salvos.add(lugar.id);
      }
    });
    widget.onSalvar(lugar);
  }

  Widget _construirLista() {
    if (widget.lugares.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border, size: 60, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Nenhum lugar salvo ainda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              if (widget.onDiscovery != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: widget.onDiscovery,
                  child: const Text('Explorar lugares'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.lugares.length,
      itemBuilder: (context, index) {
        final lugar = widget.lugares[index];
        final bool salvo = _salvos.contains(lugar.id);

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(lugar.icone),
            ),
            title: Text(lugar.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lugar.endereco),
                if (widget.mostrarNota)
                  const Text('★ 4,8  ·  nota de demonstração'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                salvo ? Icons.bookmark : Icons.bookmark_border,
                color: salvo ? Colors.amber[800] : Colors.grey,
              ),
              onPressed: () {
                _alternarSalvo(lugar);
              },
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(lugar.nome),
                    content: Text('${lugar.descricao}\n\n${lugar.endereco}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: widget.mostrarMapa
          ? Column(
              children: [
                SizedBox(
                  height: 280,
                  child: MapaGoogle(lugares: widget.lugares),
                ),
                Expanded(
                  child: _construirLista(),
                ),
              ],
            )
          : _construirLista(),
    );
  }
}

class PaginaHome extends StatelessWidget {
  const PaginaHome({
    super.key,
    required this.onDiscovery,
    required this.onNearby,
    required this.lugarDestaque,
    required this.lugaresSalvos,
    required this.onSalvar,
  });

  final VoidCallback onDiscovery;
  final VoidCallback onNearby;
  final Lugar lugarDestaque;
  final List<Lugar> lugaresSalvos;
  final Function(Lugar) onSalvar;

  @override
  Widget build(BuildContext context) {
    final bool salvo = lugaresSalvos.any((lugar) => lugar.id == lugarDestaque.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá! Vamos encontrar um lugar para comer?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore restaurantes e lanchonetes perto do IFPI Teresina Central.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onDiscovery,
                  icon: const Icon(Icons.explore),
                  label: const Text('Explorar categorias'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onNearby,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Ver restaurantes próximos no mapa'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sugestão para conhecer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(lugarDestaque.icone),
                  ),
                  title: Text(lugarDestaque.nome),
                  subtitle: Text(lugarDestaque.endereco),
                  trailing: IconButton(
                    icon: Icon(
                      salvo ? Icons.bookmark : Icons.bookmark_border,
                      color: salvo ? Colors.amber[800] : Colors.grey,
                    ),
                    onPressed: () => onSalvar(lugarDestaque),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaPerfil extends StatelessWidget {
  const PaginaPerfil({
    super.key,
    required this.quantidadeSalvos,
  });

  final int quantidadeSalvos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 12),
          const Text(
            'Visitante',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Perfil de demonstração',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Lugares salvos'),
              trailing: Text('$quantidadeSalvos'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Cidade'),
              subtitle: Text('Teresina, Piauí'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Sobre o Places'),
              subtitle: Text('Encontre lugares para comer perto de você.'),
            ),
          ),
        ],
      ),
    );
  }
}

class PaginaNearby extends StatelessWidget {
  const PaginaNearby({
    super.key,
    required this.lugares,
  });

  final List<Lugar> lugares;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby restaurants'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MapaGoogle(lugares: lugares),
    );
  }
}

class MapaGoogle extends StatefulWidget {
  const MapaGoogle({
    super.key,
    required this.lugares,
  });

  final List<Lugar> lugares;

  @override
  State<MapaGoogle> createState() => _MapaGoogleState();
}

class _MapaGoogleState extends State<MapaGoogle> {
  LatLng? _posicaoAtual;

  @override
  void initState() {
    super.initState();
    _determinarPosicao();
  }

  Future<void> _determinarPosicao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
    if (!mounted) {
      return;
    }

    setState(() {
      _posicaoAtual = LatLng(posicao.latitude, posicao.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    const LatLng localReferencia = LatLng(-5.0887585, -42.8107683);
    Set<Marker> marcadores = {};

    for (final lugar in widget.lugares) {
      if (lugar.localizacao != null) {
        marcadores.add(
          Marker(
            markerId: MarkerId(lugar.id),
            position: lugar.localizacao!,
            infoWindow: InfoWindow(
              title: lugar.nome,
              snippet: '${lugar.categoria} · ${lugar.endereco}',
            ),
          ),
        );
      }
    }

    if (_posicaoAtual != null) {
      marcadores.add(
        Marker(
          markerId: const MarkerId('minha_localizacao'),
          position: _posicaoAtual!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(
            title: 'Você está aqui',
          ),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: localReferencia,
        zoom: 15,
      ),
      myLocationEnabled: _posicaoAtual != null,
      myLocationButtonEnabled: _posicaoAtual != null,
      markers: marcadores,
    );
  }
}
