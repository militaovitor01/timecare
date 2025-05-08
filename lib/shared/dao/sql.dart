import 'package:timecare/shared/models/remedio_model.dart';

class ConnectionSQL {
  static const String CREATE_TABLE_REMEDIO = '''
  CREATE TABLE Remedios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    tipo TEXT NOT NULL,
    dosagem TEXT NOT NULL,
    frequencia INTEGER,
    horario TEXT
  );
  ''';

  static String selecionarTodosOsRemedios() {
    return 'SELECT * FROM Remedios;';
  }

  static String adicionarRemedio(Remedio remedio) {
    return '''
      INSERT INTO Remedios (nome, tipo, dosagem, frequencia, horario)
      VALUES ("${remedio.nome}", "${remedio.tipo}", "${remedio.dosagem}", "${remedio.frequencia}", "${remedio.horario}")
    ''';
  }

  static String atualizarRemedio(Remedio remedio) {
    return '''
    UPDATE Remedios SET 
      nome = "${remedio.nome}", 
      tipo = "${remedio.tipo}", 
      dosagem = "${remedio.dosagem}", 
      frequencia = ${remedio.frequencia}, 
      horario = "${remedio.horario}" 
    WHERE id = ${remedio.id}
  ''';
  }

  static String deletarRemedio(Remedio remedio) {
    return 'DELETE from Remedios WHERE id = ${remedio.id};';
  }
}
