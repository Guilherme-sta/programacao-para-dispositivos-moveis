
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Lista de Compras',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
      ),
    ),
    home: const MyHomePage(
      title: 'Lista de Compras',
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'O que falta na sua lista de compras?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),
              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Itens da lista:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Lista de compras
              ...items.map((item) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      item.nome,
                      style: TextStyle(
                        fontSize: 17,
                        decoration: item.check
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    value: item.check,
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        item.check = value ?? false;
                      });
                    },
                  ),
                );
              }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
