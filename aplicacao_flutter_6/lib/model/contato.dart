class Contato {
  final int? id;
  final String nome;
  final String email;

  const Contato({
    this.id,
    required this.nome,
    required this.email,
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
    };
  }

  factory Contato.fromMap(Map<String,dynamic> map) {
    return Contato(
      id: map['id'] as int,
      nome: map['nome'] as String,
      email: map['email'] as String,
    );
  }
}