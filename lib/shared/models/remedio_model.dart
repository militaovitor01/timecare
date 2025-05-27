class Remedio {
  int? id;
  final String nome;
  final String tipo;
  final String dosagem;
  final String? instrucoes;
  final int? frequencia;
  final String? horario;

  Remedio({
    this.id,
    required this.nome,
    required this.tipo,
    required this.dosagem,
    this.instrucoes,
    this.frequencia,
    this.horario,
  });

  factory Remedio.fromSQLite(Map<String, dynamic> map) {
    try {
      return Remedio(
        id: map['id'] as int?,
        nome: map['nome'] as String? ?? '',
        tipo: map['tipo'] as String? ?? '',
        dosagem: map['dosagem'] as String? ?? '',
        instrucoes: map['instrucoes'] as String?,
        frequencia:
            map['frequencia'] != null
                ? int.tryParse(map['frequencia'].toString())
                : null,
        horario: map['horario'] as String?,
      );
    } catch (e) {
      print('Erro ao converter mapa para Remedio: $map');
      print('Erro: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'dosagem': dosagem,
      'instrucoes': instrucoes,
      'frequencia': frequencia,
      'horario': horario,
    };
  }

  static List<Remedio> fromSQLiteList(List<Map<String, dynamic>> listMap) {
    return listMap.map((item) => Remedio.fromSQLite(item)).toList();
  }
}
