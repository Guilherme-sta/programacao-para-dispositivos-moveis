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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vorcaro Bank'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 35,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Guilherme Alves',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Conta: 674206-9',
                  style: TextStyle(
                    color: Colors.white,
                  )
                ),
              ],
            ),
          ),

            ListTile(
              leading: Icon(
                Icons.account_balance_wallet, size: 30),
              title: Text('Saldo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.receipt, size: 30),
              title: Text('Extrato'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.credit_card, size: 30),
              title: Text('Pagamentos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset(
                'img/pix-logo.png',
                width: 30,
                height: 30,
              ),
              title: Text('Pix'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'img/vasco-logo.png',
                width: 300,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo",
                      style: TextStyle(
                        fontSize: 20, 
                      ),
                    ),
                    Text(
                      "Saldo disponível: R\$ 657,13",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          Positioned(
            top: 100,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.receipt,
                  size: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Extrato",
                      style: TextStyle(
                        fontSize: 20, 
                      ),
                    ),
                    Text(
                      "Consulte seu histórico de movimentações",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          Positioned(
            top: 180,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.credit_card,
                  size: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pagamentos",
                      style: TextStyle(
                        fontSize: 20, 
                      ),
                    ),
                    Text(
                      "Consulte seus lançamentos futuros",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          Positioned(
            top: 260,
            left: 20,
            child: Row(
              children: [
                Image.asset(
                  'img/pix-logo.png',
                  width: 40,
                  height: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pix",
                      style: TextStyle(
                        fontSize: 20, 
                      ),
                    ),
                    Text(
                      "Realize um pagamento via PIX",
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          ], 
        ),
        
      
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],),
      floatingActionButton: FloatingActionButton(onPressed: () {},
      tooltip: 'Increment',
      child: Icon(Icons.add),),
    );
  }
}