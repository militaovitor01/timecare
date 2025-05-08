class Remedio {
  int? id;
  String nome;
  String tipo;
  String dosagem;
  int? frequencia;
  String? horario;

  Remedio({
    this.id,
    required this.nome,
    required this.tipo,
    required this.dosagem,
    required this.frequencia,
    required this.horario,
  });

  factory Remedio.fromSQLite(Map<String, dynamic> map) {
    return Remedio(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      tipo: map['tipo'] as String,
      dosagem: map['dosagem'] as String,
      frequencia:
          map['frequencia'] != null
              ? int.tryParse(map['frequencia'].toString())
              : null,
      horario: map['horario']?.toString(),
    );
  }

  static List<Remedio> fromSQLiteList(List<Map<String, dynamic>> listMap) {
    return listMap.map((item) => Remedio.fromSQLite(item)).toList();
  }
}
