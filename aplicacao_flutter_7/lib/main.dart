import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação com API do Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Aplicação com API do Google Maps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  bool _permissionGranted = false;
  final LatLng _center = const LatLng(-5.0887585, -42.8107683);
  
  Set<Marker> _marcadores = {};

  BitmapDescriptor? _iconeCidadania;
  BitmapDescriptor? _iconeIFPI;
  BitmapDescriptor? _iconeTrocaTroca;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('O serviço de localização está desabilitado');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('A permissão de localização foi negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Permissões de localização estão desabilitadas permanentemente.');
    }
    setState(() {
      _permissionGranted = true;
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _carregarIcones() async {
    _iconeCidadania = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)), 
      'assets/cidadania.jpg',
    );
    _iconeIFPI = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)), 
      'assets/IFPI.jpg',
    );
    _iconeTrocaTroca = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)), 
      'assets/troca_troca.jpg',
    );
  }

  void _abrirImagem(BuildContext context, String caminhoImagem, String titulo, String descricao) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView( // Permite rolar se a tela for pequena
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do local com bordas arredondadas
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), 
                  child: Image.asset(
                    caminhoImagem,
                    fit: BoxFit.cover,
                    height: 200, // Ocupa toda a largura disponível
                  ),
                ),
                const SizedBox(height: 16), // Espaçamento
                // Descrição do local
                Text(
                  descricao,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify, 
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _carregarMarcadores() async {
    await _carregarIcones(); // Espera as imagens carregarem antes de criar os pinos

    Set<Marker> marcadoresLocal = {};
    
    Marker marcadorIFPI = Marker(
      markerId: const MarkerId('IFPI Campus Teresina Central'),
      position: const LatLng(-5.0887585, -42.8107683),
      icon: _iconeIFPI!, // O "!" garante que a imagem já foi carregada
      infoWindow: const InfoWindow(
        title: 'IFPI Campus Teresina Central',
        snippet: "Teresina - PI",
      ),
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(-5.0887585, -42.8107683),
              zoom: 17.0, 
            ),
          ),
        );
        _abrirImagem(
          context, 
          'assets/IFPI.jpg', 
          'IFPI Campus Teresina Central', 
          'O Instituto Federal do Piauí oferece cursos técnicos, de graduação e pós-graduação gratuitos para a população, sendo uma das principais instituições de ensino da região.'
        );
      },
    );

    Marker marcadorTrocaTroca = Marker(
      markerId: const MarkerId('Mercado do Troca-Troca'),
      position: const LatLng(-5.09241, -42.81891),
      icon: _iconeTrocaTroca!,
      infoWindow: const InfoWindow(
        title: 'Mercado do Troca-Troca',
        snippet: "Teresina - PI",
      ),
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(-5.09241, -42.81891),
              zoom: 17.0,
            ),
          ),
        );
        _abrirImagem(
          context, 
          'assets/troca_troca.jpg', 
          'Mercado do Troca-Troca', 
          'Um dos pontos comerciais mais tradicionais de Teresina. Ideal para encontrar artesanato, comidas típicas e diversos produtos locais.'
        );
      },
    );

    Marker marcadorCidadania = Marker(
      markerId: const MarkerId('Parque da Cidadania'),
      position: const LatLng(-5.080788, -42.805516),
      icon: _iconeCidadania!,
      infoWindow: const InfoWindow(
        title: 'Parque da Cidadania',
        snippet: "Teresina - PI",
      ),
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(-5.080788, -42.805516),
              zoom: 17.0,
            ),
          ),
        );
        _abrirImagem(
          context, 
          'assets/cidadania.jpg', 
          'Parque da Cidadania', 
          'Um espaço de lazer e convivência para a população. Conta com áreas verdes, pistas para caminhada e quadras esportivas.'
        );
      },
    );

    marcadoresLocal.add(marcadorIFPI);
    marcadoresLocal.add(marcadorTrocaTroca);
    marcadoresLocal.add(marcadorCidadania);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GoogleMap(
        myLocationEnabled: _permissionGranted,
        myLocationButtonEnabled: true,
        mapType: MapType.hybrid,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _marcadores,
      ),
    );
  }
}