import '../model/banco_de_dados.dart';
import '../model/contato.dart';

class ContatoController {
  final BancoDeDados _banco = BancoDeDados.instancia;
  Future<List<Contato>>listar() => _banco.consultar();

  Future<void>salvar(Contato contato) async {
    if(contato.id == null) {
      await _banco.inserir(contato);
    }
    else {
      await _banco.atualizar(contato);
    }
  }

  Future<void>excluir(int id) async {
    await _banco.excluir(id);
  }
}