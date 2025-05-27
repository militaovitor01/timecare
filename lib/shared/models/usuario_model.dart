class Usuario {
  int? id;
  final String nome;
  final String email;
  final String? telefone;
  final String? endereco;
  final int? idade;
  final String? foto;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.endereco,
    this.idade,
    this.foto,
  });

  factory Usuario.fromSQLite(Map<String, dynamic> map) {
    try {
      return Usuario(
        id: map['id'] as int?,
        nome: map['nome'] as String? ?? '',
        email: map['email'] as String? ?? '',
        telefone: map['telefone'] as String?,
        endereco: map['endereco'] as String?,
        idade:
            map['idade'] != null ? int.tryParse(map['idade'].toString()) : null,
        foto: map['foto'] as String?,
      );
    } catch (e) {
      print('Erro ao converter mapa para Usuario: $map');
      print('Erro: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'idade': idade,
      'foto': foto,
    };
  }

  static List<Usuario> fromSQLiteList(List<Map<String, dynamic>> listMap) {
    return listMap.map((item) => Usuario.fromSQLite(item)).toList();
  }
}
