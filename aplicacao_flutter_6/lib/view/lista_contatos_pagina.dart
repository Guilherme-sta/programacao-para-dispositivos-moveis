import 'package:flutter/material.dart';
import '../controller/contato_controller.dart';
import '../model/contato.dart';
import 'formulario_contato_pagina.dart';

class ListaContatosPagina extends StatefulWidget {
  const ListaContatosPagina({super.key});

  @override
  State<ListaContatosPagina>createState() => _ListaContatosPaginaState();
}

class _ListaContatosPaginaState extends State<ListaContatosPagina> {
  final ContatoController _controller = ContatoController();
  List<Contato> _contatos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  Future<void>_carregarContatos() async {
    final contatos = await _controller.listar();
    if (!mounted){
      return;
    }

    setState(() {
      _contatos = contatos;
      _carregando = false;
    });
  }

  Future<void>_abrirFormulario({Contato? contato}) async {
    final resultado = await Navigator.push<Contato>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioContatoPagina(contato: contato),
      ),
    );

    if (resultado == null) {
      return;
    }
    await _controller.salvar(resultado);
    await _carregarContatos();
  }

  Future<void>_confirmarExclusao(Contato contato) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );

    if (confirmar == true && contato.id != null) {
      await _controller.excluir(contato.id!);
      await _carregarContatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Meus contatos'),
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
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_contatos.isEmpty) {
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
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.person_outline),
            ),
            title: Text(contato.nome),
            subtitle: Text(contato.email),
            trailing: PopupMenuButton<String>(
              onSelected: (acao) {
                if (acao == 'editar') {
                  _abrirFormulario(contato: contato);
                } 
                else if (acao == 'excluir') {
                  _confirmarExclusao(contato);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'excluir', child: Text('Excluir')),
              ],
            ),
          ),
        );
      },
    );
  }
}