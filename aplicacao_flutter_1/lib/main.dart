import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Item {
  String nome;
  bool check;

  Item({
    required this.nome,
    required this.check,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [
    Item(nome: "Arroz", check: true),
    Item(nome: "Feijão", check: true),
    Item(nome: "Farinha", check: true),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        leading: Text("OP"),
        title: Text("Home"),
        actions: <Widget>[
          Icon(Icons.local_grocery_store),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext contex, int index) {
          final item = items[index];
          return CheckboxListTile(
            title: Text(item.nome),
            key: Key(item.nome),
            value: item.check,
            onChanged: (value) {
              setState(() {
                item.check = value ?? false;
              });
            },
          );
        },
      ),
    );
  }
}