import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'TabBar para diferentes estados de tempo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          ),
      ),
      home: const MyHomePage(
        title: 'TabBar Widget',
      ),
  ));
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

class TabNublado extends StatelessWidget{
  const TabNublado({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("O tempo está nublado por aqui"),
    );
  }
}

class TabChuvoso extends StatelessWidget{
  const TabChuvoso({super.key});

  @override 
  Widget build(BuildContext context) {
    return const Center(
      child: Text("O tempo está chuvoso por aqui"),
    );
  }
}

class TabEnsolarado extends StatelessWidget{
  const TabEnsolarado({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('O tempo está ensolarado por aqui'),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text(widget.title,
          style: TextStyle(
          color: Colors.white,
        ),
      ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined, color: Colors.white),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp, color: Colors.white),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp, color: Colors.white),
              ),
            ],
          ),
    ),
    
    body: TabBarView(
      children: <Widget>[
        TabNublado(),
        TabChuvoso(),
        TabEnsolarado(),
      ],
    ),
      ),
    );
  }
}