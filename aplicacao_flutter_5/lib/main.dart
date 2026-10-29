import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cadastro de Contatos",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ListaContatosPagina(),
    );
  }
}

class Contato{
  final int? id;
  final String nome;
  final String email;

  const Contato({
    this.id,
    required this.nome,
    required this.email,
  });

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nome': nome,
      'email': email,
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map){
    return Contato(
      id: map['id'] as int,
      nome: map['nome'] as String,
      email: map['email'] as String,
    );
  }
}

class BancodeDados{
  BancodeDados._();
  static final BancodeDados instancia = BancodeDados._();
  Database? _database;

  Future<Database> get database async{
    if (_database != null){
      return _database!;
    }

    final caminho = path.join(await getDatabasesPath(), 'contatos.db',);

    _database = await openDatabase(caminho, version: 1,
      onCreate: (db,version) async{
        await db.execute('''
        CREATE TABLE contatos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> inserir(Contato contato) async{
    final db = await database;

    return db.insert('contatos',{
      'nome': contato.nome,
      'email': contato.email,
    },
    );
  }

  Future<List<Contato>> consultar() async{
    final db = await database;
    final retorno = await db.query('contatos', orderBy: 'nome COLLATE NOCASE',);

    return retorno.map(Contato.fromMap).toList();
  }

  Future<int> atualizar(Contato contato) async{
    final db = await database;

    return db.update('contatos',{
      'nome': contato.nome,
      'email': contato.email,
    },
    where: 'id = ?',
    whereArgs: [contato.id],
    );
  }

  Future<int> excluir(int id) async{
    final db = await database;

    return db.delete('contatos', where: 'id = ?', whereArgs: [id],);
  }
}

class ListaContatosPagina extends StatefulWidget {
  const ListaContatosPagina({super.key});

  @override
  State<ListaContatosPagina> createState() => _ListaContatosPaginaState();
}

class _ListaContatosPaginaState extends State<ListaContatosPagina> {
  final BancodeDados _banco = BancodeDados.instancia;
  List<Contato> _contatos = [];
  bool _carregando = true;

  @override
  void initState(){
    super.initState();
    _carregarContatos();
  }

  Future<void> _carregarContatos() async{
    final contatos = await _banco.consultar();
    
    if (!mounted){
      return;
    }

    setState((){
      _contatos = contatos;
      _carregando = false;
    });
  }

  Future<void> _abrirFormulario({Contato? contato}) async{
    final resultado = await Navigator.push<Contato>(
    context,
      MaterialPageRoute(builder: (context) => FormularioContatoPagina(contato: contato),
      ),
    );

    if (resultado == null){
      return;
    }
    if (resultado.id == null){
      await _banco.inserir(resultado);
    }
    else{
      await _banco.atualizar(resultado);
    }

    await _carregarContatos();
  }

  Future<void> _confirmarExclusao(Contato contato) async{
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir contato?'),
          content: Text('Deseja excluir ${contato.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && contato.id != null){
      await _banco.excluir(contato.id!);
      await _carregarContatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          'Meus contatos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _construirLista(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.person_add),
        label: const Text('Adicionar'),
      ),
    );
  }

  Widget _construirLista() {
    if (_carregando){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_contatos.isEmpty){
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum contato cadastrado.\nToque em “Adicionar” para começar.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _contatos.length,
      itemBuilder: (context, index) {
        final contato = _contatos[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.person_outline),
            ),
            title: Text(contato.nome),
            subtitle: Text(contato.email),
            trailing: PopupMenuButton<String>(
              onSelected: (acao) {
                if (acao == 'editar') {
                  _abrirFormulario(contato: contato);
                } else if (acao == 'excluir') {
                  _confirmarExclusao(contato);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'editar',
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: 'excluir',
                  child: Text('Excluir'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormularioContatoPagina extends StatefulWidget {
  final Contato? contato;
  const FormularioContatoPagina({super.key,this.contato,});

  @override
  State<FormularioContatoPagina> createState() => _FormularioContatoPaginaState();
}

class _FormularioContatoPaginaState extends State<FormularioContatoPagina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.contato?.nome ?? '',
    );
    _emailController = TextEditingController(
      text: widget.contato?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final contato = Contato(
      id: widget.contato?.id,
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
    );

    Navigator.pop(context, contato);
    }

    @override
    Widget build(BuildContext context) {
      final bool editando = widget.contato != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(editando ? 'Editar contato' : 'Novo contato'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    final email = valor?.trim() ?? '';

                    if (email.isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      editando ? 'Salvar alterações' : 'Salvar contato',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}