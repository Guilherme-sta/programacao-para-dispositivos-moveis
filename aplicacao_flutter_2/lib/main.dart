import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Rotas Nomeadas Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          ),
      ),
    initialRoute: '/',
    routes: {
      '/':(context) => FirstRoute(),
      '/second':(context) => SecondRoute(),
    }
  ));  
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Primeira Rota",
        style: TextStyle(
          color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text('Abri 2ª rota',
          style: TextStyle(
            color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/second'
            );
          },
        )
      )
    );
  } 
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Rota",
        style: TextStyle(
          color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text('Retornar!',
          style: TextStyle(
            color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      )
    );
  } 
}