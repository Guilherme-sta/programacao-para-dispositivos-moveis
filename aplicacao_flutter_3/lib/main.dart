import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Comparativo Gasolina x Álcool',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          ),
      ),
      home: const MyHomePage(
        title: 'Gasolina x Álcool',
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

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingControllerGasolina = TextEditingController();
  final TextEditingController _textEditingControllerAlcool = TextEditingController();

  String resultado = 'Informe os preços e clique em calcular';
  Color corResultado = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),

    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Que combustível está compensando mais?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX1TxnoEUqUmqsY82aha93RGqu35EeXx6VXNbB6VZgSQ&s=10',
            width: 150),
          ),
          const SizedBox(height: 24),

          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Valor do litro de gasolina',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(),
            ),
            controller: _textEditingControllerGasolina,
          ),

          const SizedBox(height: 16),

          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Valor do litro de álcool',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(),
            ),
            controller: _textEditingControllerAlcool,
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              double? gasolina = double.tryParse(_textEditingControllerGasolina.text.replaceAll(',','.'));
              double? alcool = double.tryParse(_textEditingControllerAlcool.text.replaceAll(',','.'));

              if (gasolina == null || alcool == null || gasolina <= 0 || alcool <= 0) {
              setState(() {
                resultado = 'Digite valores adequados';
                corResultado = Colors.red;
              });
              return;
            }

            setState(() {
              var calculo = (alcool / gasolina) * 100;

              if (calculo <= 70){
                resultado = 'Vale mais a pena abastecer com álcool';
                corResultado = Colors.green;
              }
              else{
                resultado = 'Vale mais a pena abastecer com gasolina';
                corResultado = Colors.orange;
              }
            });
            },
            child: const Text('Calcular'),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: corResultado.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              resultado,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: corResultado,
              ),
            )
          )
        ],
      ),
    ),
    );
  }
}