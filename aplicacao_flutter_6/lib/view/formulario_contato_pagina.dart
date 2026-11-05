import 'package:flutter/material.dart';
import '../model/contato.dart';

class FormularioContatoPagina extends StatefulWidget {
  final Contato? contato;
  const FormularioContatoPagina({super.key,this.contato});

  @override
  State<FormularioContatoPagina> createState() =>
      _FormularioContatoPaginaState();
}

class _FormularioContatoPaginaState extends State<FormularioContatoPagina> {
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contato?.nome ?? '');
    _emailController = TextEditingController(text: widget.contato?.email ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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